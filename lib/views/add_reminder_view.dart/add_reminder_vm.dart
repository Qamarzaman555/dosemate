import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dosemate/models/dose_type_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_center_date_picker/datepicker_controller.dart';
import 'package:stacked/stacked.dart';
import '../../models/medication_model.dart';
import '../../services/notifications.dart';
import '../../services/session_manager.dart';
import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';

class AddReminderVM extends BaseViewModel {
  FirebaseAuth auth = FirebaseAuth.instance;

  TimeOfDay time = TimeOfDay.now();
  String? name, selectedNote;
  DateTime selectedDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 30));
  DatePickerController datePickerController = DatePickerController();
  String? selectedDoseType;
  String? selectedDose;

  List<DoseTypeModel> doseTypeModel = [
    DoseTypeModel(customImage('assets/medicine.png'), 'Tablets'),
    DoseTypeModel(customImage('assets/capsules.png'), 'Pill'),
    DoseTypeModel(customImage('assets/syrup.png'), 'Liquid'),
    DoseTypeModel(customImage('assets/needle.png'), 'Injection'),
  ];
  Map<String, List<String>> doseOptions = {
    'Tablets': ['200 mg', '400 mg', '600 mg'],
    'Pill': ['1 pill', '2 pills', '3 pills'],
    'Liquid': ['1 spoon', '2 spoons', '3 spoons'],
    'Injection': ['1 shot', '2 shots', '3 shots'],
  };

  void logOut(BuildContext context) {
    auth.signOut().then((value) {
      Navigator.pushNamed(context, RouteName.loginScreen);
      Utils.toastMessage('Logged Out Successfully');
    });
  }

  void updateSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void updateSelectedTime(TimeOfDay newTime) {
    time = newTime;
    notifyListeners();
  }

  void updateName(String value) {
    name = value;
  }

  void updateSelectedNote(String? note) {
    selectedNote = note;
    notifyListeners();
  }

  void updateSelectedDoseType(String? newValue) {
    selectedDoseType = newValue;
    selectedDose = null;
    notifyListeners();
  }

  void updateSelectedDose(String? dose) {
    selectedDose = dose;
    notifyListeners();
  }

  bool validateFields() {
    return name != null &&
        name!.isNotEmpty &&
        selectedDoseType != null &&
        selectedDose != null &&
        selectedNote != null;
  }

  Future<void> addReminder(BuildContext context, String uid) async {
    if (!validateFields()) {
      Utils.toastMessage('Please fill all the fields');
      return;
    }

    setBusy(true);
    try {
      DateTime dateTime = DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, time.hour, time.minute);
      Timestamp timestamp = Timestamp.fromDate(dateTime);
      MedicationModel medicationModel = MedicationModel(
        name: name,
        dosage: selectedDose,
        notes: selectedNote,
        timestamp: timestamp,
        onOff: false,
        doseType: selectedDoseType,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(SessionController().userId)
          .collection('reminder')
          .doc()
          .set(medicationModel.toJson());

      Notifications.showNotifications(
        dateTime: dateTime,
        title: 'Medication Reminder',
        body: 'Don\'t forget to take your medication: $name',
        payload: 'medication_reminder',
      );

      Utils.toastMessage('Reminder Added');
    } catch (e) {
      Utils.toastMessage('Not Added');
    }
    setBusy(false);
  }
}
