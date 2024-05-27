import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:stacked/stacked.dart';

import '../../utils/utils.dart';
import 'bottom_navigation_vm.dart';

class BottomNavigationVU extends StackedView<BottomNavigationBarVM> {
  const BottomNavigationVU({super.key});

  @override
  Widget builder(
      BuildContext context, BottomNavigationBarVM viewModel, Widget? child) {
    return Scaffold(
      body: Center(
        child: viewModel.screenNames.elementAt(viewModel.selectedIndex),
      ),
      bottomNavigationBar: FlashyTabBar(
        height: 55,
        iconSize: 24,
        selectedIndex: viewModel.selectedIndex,
        showElevation: true,
        onItemSelected: (index) {
          viewModel.onItemTapped(index);
        },
        items: [
          FlashyTabBarItem(
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveColor: Theme.of(context).colorScheme.onSecondary,
            icon: customImage('assets/bell.png'),
            title: const Text('Home'),
          ),
          FlashyTabBarItem(
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveColor: Theme.of(context).colorScheme.onSecondary,
            icon: customImage('assets/clock.png'),
            title: const Text('Add Reminder'),
          ),
          FlashyTabBarItem(
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveColor: Theme.of(context).colorScheme.onSecondary,
            icon: customImage('assets/profile.png'),
            title: const Text('Profile'),
          ),
        ],
      ),
    );
  }

  @override
  BottomNavigationBarVM viewModelBuilder(BuildContext context) =>
      BottomNavigationBarVM();
}
