import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/reminder_model.dart';

class Checker extends StatefulWidget {
  final bool onOff;
  final String uid;
  final Timestamp timestamp;
  final String id;
  final Function(bool) onToggle;

  const Checker(
      {super.key,
      required this.onOff,
      required this.uid,
      required this.timestamp,
      required this.id,
      required this.onToggle});

  @override
  State<Checker> createState() => _CheckerState();
}

class _CheckerState extends State<Checker> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: widget.onOff,
      onChanged: (bool? value) {
        if (value == null) return;
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
    );
  }
}
