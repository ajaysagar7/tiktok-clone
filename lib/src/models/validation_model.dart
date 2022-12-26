// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

class ValidationModel {
  String? value;
  String? error;
  ValidationModel({
    this.value,
    this.error,
  });

  factory ValidationModel.fromJson(Map<String, dynamic> json) {
    return ValidationModel(value: json["value"], error: json["error"]);
  }

  Map<String, dynamic> toJson() {
    return {"value": value, "error": error};
  }
}
