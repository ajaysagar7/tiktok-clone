import 'dart:developer';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/src/models/validation_model.dart';

class ValidationProvider with ChangeNotifier {
  ValidationModel _emailModel = ValidationModel();
  ValidationModel _passModel = ValidationModel();

  File? imageFile;
  bool isImageSelected = false;

  pickImage() async {
    try {
      final pickedFile =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (pickedFile != null) {
        imageFile = File(pickedFile.files.first.path!);
        notifyListeners();
        isImageSelected = true;
        notifyListeners();
      } else {
        log("no image selected");
        isImageSelected = false;
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
      isImageSelected = false;
      notifyListeners();
    }
  }

  ValidationModel get emailModel => _emailModel;
  ValidationModel get passModel => _passModel;

  void emailValidation({required String value}) async {
    try {
      if (value.isEmpty) {
        _emailModel = ValidationModel(error: "please enter email", value: "");
        notifyListeners();
      } else if (value.length < 3) {
        _emailModel = ValidationModel(
            error: "please enter more than 3 charcters", value: "");
        notifyListeners();
      } else if (!EmailValidator.validate(value)) {
        _emailModel = ValidationModel(
          error: "pleaes enter a valid email",
        );
        notifyListeners();
      } else {
        _emailModel = ValidationModel(
          value: value,
        );
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void passwordValidation({required String passValue}) {
    if (passValue.isEmpty) {
      _passModel =
          ValidationModel(error: "password is empty", value: passValue);
      notifyListeners();
    } else if (passValue.length < 3) {
      _passModel =
          ValidationModel(error: "password is too short", value: passValue);
      notifyListeners();
    } else if (passValue.length > 14) {
      _passModel =
          ValidationModel(error: "password is too long", value: passValue);
      notifyListeners();
    } else {
      _passModel = ValidationModel(value: passValue, error: null);
      notifyListeners();
    }
  }
}
