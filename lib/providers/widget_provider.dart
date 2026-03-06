import 'package:flutter/material.dart';
import '../models/photo_widget.dart';
import '../models/notification.dart';

class WidgetProvider with ChangeNotifier {
  List<PhotoWidget> _sharedWidgets = [];
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<PhotoWidget> get sharedWidgets => _sharedWidgets;
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  // Mock data for now
  void loadMockData() {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      _sharedWidgets = [
        PhotoWidget(
          id: '1',
          imageUrl: 'https://picsum.photos/400/400?random=1',
          uploadedBy: 'Ben',
          uploadedById: '1',
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
          likedBy: ['2', '3'],
          comments: [
            Comment(
              id: 'c1',
              userId: '2',
              userName: 'Anna',
              text: 'So cute!',
              createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
            ),
          ],
          sharedWith: ['1', '2', '3', '4'],
        ),
        PhotoWidget(
          id: '2',
          imageUrl: 'https://picsum.photos/400/400?random=2',
          uploadedBy: 'Anna',
          uploadedById: '2',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          likedBy: ['1', '3'],
          comments: [],
          sharedWith: ['1', '2', '3'],
        ),
        PhotoWidget(
          id: '3',
          imageUrl: 'https://picsum.photos/400/400?random=3',
          uploadedBy: 'Mila',
          uploadedById: '5',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          likedBy: ['1', '2', '4'],
          comments: [
            Comment(
              id: 'c2',
              userId: '1',
              userName: 'Ben',
              text: 'Love this!',
              createdAt: DateTime.now().subtract(const Duration(hours: 4)),
            ),
            Comment(
              id: 'c3',
              userId: '4',
              userName: 'Lily',
              text: 'Where is this?',
              createdAt: DateTime.now().subtract(const Duration(hours: 3)),
            ),
          ],
          sharedWith: ['1', '2', '4', '5'],
        ),
      ];

      _notifications = [
        NotificationModel(
          id: 'n1',
          type: 'comment',
          userId: '2',
          userName: 'Anna',
          photoId: '1',
          commentText: 'So cute!',
          createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
        NotificationModel(
          id: 'n2',
          type: 'share',
          userId: '5',
          userName: 'Mila',
          photoId: '3',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        NotificationModel(
          id: 'n3',
          type: 'add_to_widget',
          userId: '6',
          userName: 'Zee',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        NotificationModel(
          id: 'n4',
          type: 'add_to_widget',
          userId: '6',
          userName: 'Zee',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        NotificationModel(
          id: 'n5',
          type: 'add_to_widget',
          userId: '6',
          userName: 'Zee',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        NotificationModel(
          id: 'n6',
          type: 'comment',
          userId: '3',
          userName: 'Jane',
          photoId: '2',
          commentText: 'So cute!',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        NotificationModel(
          id: 'n7',
          type: 'comment',
          userId: '3',
          userName: 'Jane',
          photoId: '2',
          commentText: 'So cute!',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        NotificationModel(
          id: 'n8',
          type: 'comment',
          userId: '3',
          userName: 'Jane',
          photoId: '2',
          commentText: 'So cute!',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        NotificationModel(
          id: 'n9',
          type: 'add_to_widget',
          userId: '3',
          userName: 'Jane',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        NotificationModel(
          id: 'n10',
          type: 'add_to_widget',
          userId: '3',
          userName: 'Jane',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ];

      _isLoading = false;
      notifyListeners();
    });
  }

  void addWidget(PhotoWidget widget) {
    _sharedWidgets.insert(0, widget);
    notifyListeners();
  }

  void likeWidget(String widgetId, String userId) {
    final index = _sharedWidgets.indexWhere((w) => w.id == widgetId);
    if (index != -1) {
      if (!_sharedWidgets[index].likedBy.contains(userId)) {
        _sharedWidgets[index].likedBy.add(userId);
      } else {
        _sharedWidgets[index].likedBy.remove(userId);
      }
      notifyListeners();
    }
  }

  void addComment(String widgetId, Comment comment) {
    final index = _sharedWidgets.indexWhere((w) => w.id == widgetId);
    if (index != -1) {
      _sharedWidgets[index].comments.add(comment);
      notifyListeners();
    }
  }

  void markNotificationAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    notifyListeners();
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;
}