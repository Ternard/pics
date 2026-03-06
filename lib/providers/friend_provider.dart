import 'package:flutter/material.dart';
import '../models/friend.dart';

class FriendProvider with ChangeNotifier {
  List<Friend> _closeFriends = [];
  List<Friend> _allFriends = [];
  bool _isLoading = false;

  List<Friend> get closeFriends => _closeFriends;
  List<Friend> get allFriends => _allFriends;
  bool get isLoading => _isLoading;

  // Mock data for now - will be replaced with Supabase calls
  void loadMockData() {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _closeFriends = [
        Friend(id: '1', name: 'Ben', isOnline: true, avatarUrl: null),
        Friend(id: '2', name: 'Anna', isOnline: true, avatarUrl: null),
        Friend(id: '3', name: 'Jane', isOnline: false, lastActive: '2h ago'),
        Friend(id: '4', name: 'Lily', isOnline: false, lastActive: '1d ago'),
        Friend(id: '5', name: 'Mila', isOnline: true, avatarUrl: null),
        Friend(id: '6', name: 'Zee', isOnline: false, lastActive: '30m ago'),
        Friend(id: '7', name: 'Hay', isOnline: true, avatarUrl: null),
      ];

      _allFriends = [
        ..._closeFriends,
        Friend(id: '8', name: 'Alex', isOnline: false, lastActive: '3h ago'),
        Friend(id: '9', name: 'Sam', isOnline: true, avatarUrl: null),
        Friend(id: '10', name: 'Jordan', isOnline: false, lastActive: '5h ago'),
      ];

      _isLoading = false;
      notifyListeners();
    });
  }

  void addToCloseFriends(String friendId) {
    // Implementation for adding to close friends
  }

  void removeFromCloseFriends(String friendId) {
    // Implementation for removing from close friends
  }
}