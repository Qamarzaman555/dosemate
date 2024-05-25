import 'package:flutter/material.dart';

class DoseTypeModel {
  IconData? icon;
  String? doseType;

  DoseTypeModel(
    this.icon,
    this.doseType,
  );

  DoseTypeModel.fromJson(Map<String, dynamic> json) {
    doseType = json['doseType'];
  }

  Map<String, dynamic> toJson() {
    return {
      'doseType': doseType,
    };
  }
}
