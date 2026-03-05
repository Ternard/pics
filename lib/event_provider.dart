import 'package:flutter/material.dart';

class EventProvider with ChangeNotifier {
  String? _currentEventId;
  String? _currentEventCode;
  final List<Map<String, dynamic>> _pendingUploads = [];

  String? get currentEventId => _currentEventId;
  String? get currentEventCode => _currentEventCode;
  List<Map<String, dynamic>> get pendingUploads => _pendingUploads;

  void setCurrentEvent(String eventId, String eventCode) {
    _currentEventId = eventId;
    _currentEventCode = eventCode;
    notifyListeners();
  }

  void addPendingUpload(Map<String, dynamic> photo) {
    _pendingUploads.add(photo);
    notifyListeners();
  }

  void removePendingUpload(int index) {
    _pendingUploads.removeAt(index);
    notifyListeners();
  }

  void clearPendingUploads() {
    _pendingUploads.clear();
    notifyListeners();
  }

  void leaveEvent() {
    _currentEventId = null;
    _currentEventCode = null;
    notifyListeners();
  }
}