import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../view.dart';

class BottomNavigationBarVM extends BaseViewModel {
  int selectedIndex = 0;
  List<Widget> screenNames = [
    const HomeVU(),
    const AddReminderVU(),
    const ProfileVU(),
  ];

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
