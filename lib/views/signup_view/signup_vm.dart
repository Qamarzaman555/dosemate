import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/user_model.dart';
import '../../services/session_manager.dart';
import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';

class SignUpVM extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  String? email, password, firstName, lastName;

  bool obsecurePassword = true;
  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;
  IconData iconPassword = Icons.visibility;

  obsecureToggle() {
    obsecurePassword = !obsecurePassword;
    iconPassword = obsecurePassword ? Icons.visibility : Icons.visibility_off;
    notifyListeners();
  }

  String? onChangedValue(val) {
    containsUpperCase = val.contains(RegExp(r'[A-Z]'));
    containsLowerCase = val.contains(RegExp(r'[a-z]'));
    containsNumber = val.contains(RegExp(r'[0-9]'));
    containsSpecialChar =
        val.contains(RegExp(r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'));
    contains8Length = val.length >= 8;
    notifyListeners();
    return null;
  }

  void onEmailSaved(String? value) {
    email = value;
  }

  void onPasswordSaved(String? value) {
    password = value;
  }

  void onFirstNameSaved(String? value) {
    firstName = value;
  }

  void onLastNameSaved(String? value) {
    lastName = value;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (!RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
        .hasMatch(value)) {
      return 'Please enter a valid password';
    }
    return null;
  }

  String? firstNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'First Name is required';
    }
    return null;
  }

  String? lastNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'lastName is required';
    }
    return null;
  }

  void signUp(BuildContext context) async {
    setBusy(true);
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
      try {
        UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );

        String uid = userCredential.user!.uid;

        UserModel userModel = UserModel(
            uid: uid,
            email: email,
            firstName: firstName,
            lastName: lastName,
            dob: '',
            phoneNumber: '',
            gender: '',
            address: '',
            profilePictureUrl: '');

        await firestore.collection('users').doc(uid).set(userModel.toJson());

        SessionController().userId = uid;

        Utils.toastMessage('Account Created Successfully');
        Navigator.pushNamed(context, RouteName.homeScreen);
      } catch (e) {
        // Utils.toastMessage('Something went wrong, try again');
        Utils.toastMessage(e.toString());
      }
    }
    setBusy(false);
  }
}
