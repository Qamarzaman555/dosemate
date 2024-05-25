import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  Timestamp? timestamp;
  bool? onOff;

  ReminderModel({this.timestamp, this.onOff});

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'onOff': onOff,
    };
  }

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      timestamp: json['timestamp'],
      onOff: json['onOff'],
    );
  }
}
