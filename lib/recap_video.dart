import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecapVideoScreen extends StatefulWidget {
  final String eventId;

  const RecapVideoScreen({super.key, required this.eventId});

  @override
  State<RecapVideoScreen> createState() => _RecapVideoScreenState();
}

class _RecapVideoScreenState extends State<RecapVideoScreen> {
  VideoPlayerController? _controller;
  bool _isGenerating = true;
  String? _videoUrl;
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _generateRecap();
  }

  Future<void> _generateRecap() async {
    setState(() => _isGenerating = true);

    try {
      // First, check if recap already exists
      final existingRecap = await _supabase
          .from('event_recaps')
          .select()
          .eq('event_id', widget.eventId)
          .maybeSingle();

      if (existingRecap != null) {
        setState(() {
          _videoUrl = existingRecap['video_url'];
          _isGenerating = false;
        });
        _initializeVideo();
        return;
      }

      // Get all photos for this event
      final photos = await _supabase
          .from('photos')
          .select('image_url')
          .eq('event_id', widget.eventId)
          .order('created_at', ascending: true);

      if (photos.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No photos to create recap')),
          );
          Navigator.pop(context);
        }
        return;
      }

      // In production, this would call a cloud function to generate video
      // For now, simulate generation
      await Future.delayed(const Duration(seconds: 3));

      // Mock video URL - in production, this would be the actual generated video
      final mockVideoUrl = 'https://example.com/recap.mp4';

      // Save recap record
      await _supabase.from('event_recaps').insert({
        'event_id': widget.eventId,
        'video_url': mockVideoUrl,
        'created_at': DateTime.now().toIso8601String(),
      });

      setState(() {
        _videoUrl = mockVideoUrl;
        _isGenerating = false;
      });

      _initializeVideo();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate recap: $e')),
        );
        Navigator.pop(context);
      }
    }
  }

  void _initializeVideo() {
    if (_videoUrl != null) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(_videoUrl!))
        ..initialize().then((_) {
          setState(() {});
          _controller?.play();
          _controller?.setLooping(true);
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Recap'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Download video
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download started')),
              );
            },
          ),
        ],
      ),
      body: _isGenerating
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'Creating your recap video...',
              style: TextStyle(color: Colors.brown[700]),
            ),
            const SizedBox(height: 10),
            const Text(
              'This may take a moment',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      )
          : _controller == null || !_controller!.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.brown,
                  size: 40,
                ),
                onPressed: () {
                  setState(() {
                    _controller!.value.isPlaying
                        ? _controller!.pause()
                        : _controller!.play();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Event Memories',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
          const SizedBox(height: 10),
          const Text(
            'Share this recap with your friends',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}