import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'photo_viewer.dart';

class GalleryGridScreen extends StatefulWidget {
  final String eventId;

  const GalleryGridScreen({super.key, required this.eventId});

  @override
  State<GalleryGridScreen> createState() => _GalleryGridScreenState();
}

class _GalleryGridScreenState extends State<GalleryGridScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _photos = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
    _subscribeToNewPhotos();
  }

  Future<void> _loadPhotos() async {
    try {
      final photos = await _supabase
          .from('photos')
          .select('*, users(email)')
          .eq('event_id', widget.eventId)
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _photos = List<Map<String, dynamic>>.from(photos);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _subscribeToNewPhotos() {
    _supabase
        .channel('photos-${widget.eventId}')
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'photos',
      filter: PostgresChangeFilter(
        column: 'event_id',
        value: widget.eventId,
        type: PostgresChangeFilterType.eq,
      ),
      callback: (payload) {
        if (mounted) {
          _loadPhotos(); // Reload when new photo added
        }
      },
    )
        .subscribe();
  }

  Future<void> _downloadPhoto(String url) async {
    try {
      // In production, use gallery_saver or similar package
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download started')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Gallery'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Download all photos (in production, zip them)
            },
          ),
          IconButton(
            icon: const Icon(Icons.movie),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/recap',
                arguments: widget.eventId,
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 50, color: Colors.red),
            const SizedBox(height: 20),
            Text('Error: $_errorMessage'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadPhotos,
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : _photos.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.photo_library, size: 80, color: Colors.brown),
            const SizedBox(height: 20),
            const Text(
              'No photos yet',
              style: TextStyle(fontSize: 20, color: Colors.brown),
            ),
            const SizedBox(height: 10),
            const Text(
              'Take photos to see them here',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
              ),
              child: const Text(
                'Back to Camera',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadPhotos,
        child: GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: _photos.length,
          itemBuilder: (context, index) {
            final photo = _photos[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoViewerScreen(
                      photoUrl: photo['image_url'],
                      uploadedBy: photo['users']?['email'] ?? 'Unknown',
                      timestamp: photo['created_at'],
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: photo['image_url'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: IconButton(
                      icon: const Icon(Icons.download, size: 16, color: Colors.white),
                      onPressed: () => _downloadPhoto(photo['image_url']),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}