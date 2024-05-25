import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationModel {
  String? name;
  String? dosage;
  String? notes;
  Timestamp? timestamp;
  bool? onOff;
  String? doseType;

  MedicationModel({
    this.name,
    this.dosage,
    this.notes,
    this.timestamp,
    this.onOff,
    this.doseType,
  });

  MedicationModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dosage = json['dosage'];
    notes = json['notes'];
    timestamp = json['timestamp'];
    onOff = json['onOff'];
    doseType = json['doseType'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'notes': notes,
      'timestamp': timestamp,
      'onOff': onOff,
      'doseType': doseType,
    };
  }
}
