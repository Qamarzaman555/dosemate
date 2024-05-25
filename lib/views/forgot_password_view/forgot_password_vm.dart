import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';

class ForgotPasswordVM extends BaseViewModel {
  String? email;
  final formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void onEmailSaved(String? value) {
    email = value;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  void forgotPassword(BuildContext context) async {
    setBusy(true);
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();

      try {
        await firebaseAuth.sendPasswordResetEmail(email: email!);
        Utils.toastMessage(
            'An email is sent to your account, go and reset your password');
        Navigator.pushNamed(context, RouteName.loginScreen);
      } catch (error) {
        Utils.toastMessage(error.toString());
      }
    }
    setBusy(false);
  }
}
