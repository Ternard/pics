import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class CameraScreen extends StatefulWidget {
  final String eventId;
  final String eventCode;

  const CameraScreen({
    super.key,
    required this.eventId,
    required this.eventCode,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isUploading = false;
  bool _isRearCamera = true;
  final SupabaseClient _supabase = Supabase.instance.client;
  List<File> _pendingUploads = [];
  bool _hasConnection = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    // Simplified connectivity check - in production use connectivity_plus package
    try {
      final result = await InternetAddress.lookup('google.com');
      setState(() {
        _hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      });
    } on SocketException catch (_) {
      setState(() {
        _hasConnection = false;
      });
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        throw Exception('No cameras available');
      }

      _controller = CameraController(
        _cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back),
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera error: $e')),
        );
      }
    }
  }

  Future<void> _toggleCamera() async {
    if (_controller == null || _cameras.isEmpty) return;

    final newLensDirection = _isRearCamera
        ? CameraLensDirection.front
        : CameraLensDirection.back;

    final newCamera = _cameras.firstWhere(
          (camera) => camera.lensDirection == newLensDirection,
    );

    final oldController = _controller;
    _controller = CameraController(
      newCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    await oldController?.dispose();

    setState(() {
      _isRearCamera = !_isRearCamera;
    });
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _isUploading) return;

    try {
      setState(() {
        _isUploading = true;
      });

      final XFile picture = await _controller!.takePicture();
      final File imageFile = File(picture.path);

      if (_hasConnection) {
        await _uploadPhoto(imageFile);
      } else {
        // Save locally for later upload
        final appDir = await getApplicationDocumentsDirectory();
        final eventDir = Directory('${appDir.path}/pending_uploads/${widget.eventId}');
        await eventDir.create(recursive: true);

        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedFile = await imageFile.copy('${eventDir.path}/$fileName');

        setState(() {
          _pendingUploads.add(savedFile);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo saved offline. Will upload when connected.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to take picture: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _uploadPhoto(File imageFile) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      // Compress image (simplified - use image compression package in production)
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'events/${widget.eventId}/$fileName';

      await _supabase.storage
          .from('photos')
          .upload(filePath, imageFile);

      final imageUrl = _supabase.storage
          .from('photos')
          .getPublicUrl(filePath);

      // Save photo record to database
      await _supabase.from('photos').insert({
        'event_id': widget.eventId,
        'user_id': user.id,
        'image_url': imageUrl,
        'storage_path': filePath,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo uploaded to event!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    }
  }

  Future<void> _uploadPendingPhotos() async {
    if (_pendingUploads.isEmpty || !_hasConnection) return;

    setState(() {
      _isUploading = true;
    });

    int successCount = 0;
    for (File photo in _pendingUploads) {
      try {
        await _uploadPhoto(photo);
        await photo.delete();
        successCount++;
      } catch (e) {
        debugPrint('Failed to upload pending photo: $e');
      }
    }

    setState(() {
      _pendingUploads.removeWhere((file) => !file.existsSync());
      _isUploading = false;
    });

    if (mounted && successCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$successCount photos uploaded from offline queue'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkConnectivity();
      if (_hasConnection) {
        _uploadPendingPhotos();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          if (_controller != null && _controller!.value.isInitialized)
            CameraPreview(_controller!),

          // Top bar with event info and connection status
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Event: ${widget.eventCode}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      if (!_hasConnection)
                        const Text(
                          'Offline mode',
                          style: TextStyle(color: Colors.orange, fontSize: 10),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      if (_pendingUploads.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${_pendingUploads.length}',
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.grid_view, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/gallery',
                            arguments: {'eventId': widget.eventId},
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 30),
                  onPressed: _toggleCamera,
                ),
                GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: _isUploading
                        ? const Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(color: Colors.brown),
                      ),
                    )
                        : null,
                  ),
                ),
                const SizedBox(width: 50), // Placeholder for symmetry
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Add this import at the top
import 'dart:io';
import 'dart:async';