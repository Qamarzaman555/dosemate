import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/reminder_model.dart';

class Switcher extends StatefulWidget {
  final bool onOff;
  final String uid;
  final Timestamp timestamp;
  final String id;
  final Function(bool) onToggle;

  const Switcher(
      {super.key,
      required this.onOff,
      required this.uid,
      required this.timestamp,
      required this.id,
      required this.onToggle});

  @override
  State<Switcher> createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: (bool value) {
        ReminderModel reminderModel = ReminderModel();
        reminderModel.onOff = value;
        reminderModel.timestamp = widget.timestamp;
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .collection('reminder')
            .doc(widget.id)
            .update(reminderModel.toJson())
            .then((_) {
          widget.onToggle(value);
        });
      },
      value: widget.onOff,
    );
  }
}
