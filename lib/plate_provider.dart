import 'package:flutter/material.dart';

class PlateProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _plateItems = [];

  List<Map<String, dynamic>> get plateItems => _plateItems;

  void addToPlate(Map<String, dynamic> meal) {
    _plateItems.add(meal);
    notifyListeners();
  }

  void removeFromPlate(int index) {
    _plateItems.removeAt(index);
    notifyListeners();
  }
}