import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_center_date_picker/datepicker_controller.dart';
import 'package:stacked/stacked.dart';
import '../../services/notifications.dart';
import '../../services/session_manager.dart';
import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';
import 'home_vu.dart';

class HomeVM extends BaseViewModel {
  HomeVM(context) {
    Notifications.init(context, user!);
    listenNotifications();
    fetchProfileData();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DatePickerController datePickerController = DatePickerController();

  final user = SessionController().userId;
  bool on = true;
  String? profileImageUrl;
  String? firstName;
  String? lastName;
  String? email;

  DateTime selectedDate = DateTime.now();

  List<String> dose = ['20 mg', '40 mg', '60 mg'];

  Stream<QuerySnapshot> reminderStream(String userId, DateTime date) {
    DateTime startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return firestore
        .collection('users')
        .doc(userId)
        .collection('reminder')
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .snapshots();
  }

  Future<void> fetchProfileData() async {
    setBusy(true);
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(SessionController().userId)
          .get();

      firstName = userDoc['firstName'] as String?;
      lastName = userDoc['lastName'] as String?;

      profileImageUrl = userDoc['profilePictureUrl'] as String?;

      notifyListeners();
    } catch (e) {
      Utils.toastMessage(e.toString());
    }
    setBusy(false);
  }

  void updateSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void logOut(BuildContext context) {
    auth.signOut().then((value) {
      Navigator.pushNamed(context, RouteName.loginScreen);
      Utils.toastMessage('Logged Out Successfully');
    });
  }

  void listenNotifications() {
    Notifications.onNotifications.listen((value) {});
  }

  void onClickedNotifications(String? payload, BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeVU()));
  }

  Widget getDoseTypeIcon(String doseType) {
    switch (doseType) {
      case 'Tablets':
        return const Icon(Icons.medication, color: Colors.blue);
      case 'Pill':
        return const Icon(Icons.medication, color: Colors.yellow);
      case 'Liquid':
        return const Icon(Icons.liquor, color: Colors.orange);
      case 'Injection':
        return const Icon(Icons.local_pharmacy, color: Colors.red);
      default:
        return const Icon(
            Icons.help_outline); // Default icon for unknown dose types
    }
  }
}
