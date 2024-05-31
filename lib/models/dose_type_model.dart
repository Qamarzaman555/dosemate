import 'package:flutter/material.dart';

class DoseTypeModel {
  Widget? icon;
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
