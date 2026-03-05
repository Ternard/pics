import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Save photo locally when offline
  Future<File> savePhotoOffline(File imageFile, String eventId) async {
    final appDir = await getApplicationDocumentsDirectory();
    final eventDir = Directory('${appDir.path}/offline_photos/$eventId');

    if (!await eventDir.exists()) {
      await eventDir.create(recursive: true);
    }

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedFile = await imageFile.copy('${eventDir.path}/$fileName');

    return savedFile;
  }

  // Get all offline photos for an event
  Future<List<File>> getOfflinePhotos(String eventId) async {
    final appDir = await getApplicationDocumentsDirectory();
    final eventDir = Directory('${appDir.path}/offline_photos/$eventId');

    if (!await eventDir.exists()) {
      return [];
    }

    final files = await eventDir.list().toList();
    return files.whereType<File>().toList();
  }

  // Delete offline photos after successful upload
  Future<void> deleteOfflinePhotos(String eventId) async {
    final appDir = await getApplicationDocumentsDirectory();
    final eventDir = Directory('${appDir.path}/offline_photos/$eventId');

    if (await eventDir.exists()) {
      await eventDir.delete(recursive: true);
    }
  }

  // Upload photo to Supabase storage
  Future<String?> uploadPhoto(File imageFile, String eventId, String userId) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'events/$eventId/$userId/$fileName';

      await _supabase.storage
          .from('photos')
          .upload(filePath, imageFile);

      final imageUrl = _supabase.storage
          .from('photos')
          .getPublicUrl(filePath);

      return imageUrl;
    } catch (e) {
      return null;
    }
  }

  // Get total storage used by user
  Future<int> getUserStorageUsed(String userId) async {
    try {
      final photos = await _supabase
          .from('photos')
          .select('storage_path')
          .eq('user_id', userId);

      int totalSize = 0;
      for (var photo in photos) {
        // In production, you'd need to get file sizes from storage
        // This is simplified
        totalSize += 500000; // Assume 500KB per photo
      }

      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  // Clean up expired events' photos
  Future<void> cleanupExpiredEvents() async {
    try {
      final expiredEvents = await _supabase
          .from('events')
          .select('id')
          .lt('expires_at', DateTime.now().toIso8601String());

      for (var event in expiredEvents) {
        // Delete photos from storage
        final photos = await _supabase
            .from('photos')
            .select('storage_path')
            .eq('event_id', event['id']);

        for (var photo in photos) {
          if (photo['storage_path'] != null) {
            await _supabase.storage
                .from('photos')
                .remove([photo['storage_path']]);
          }
        }

        // Delete photo records
        await _supabase
            .from('photos')
            .delete()
            .eq('event_id', event['id']);

        // Delete event
        await _supabase
            .from('events')
            .delete()
            .eq('id', event['id']);
      }
    } catch (e) {
      print('Cleanup error: $e');
    }
  }
}