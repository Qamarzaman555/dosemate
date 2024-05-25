import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../services/session_manager.dart';
import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';

// import '../../utils/routes/routes_name.dart';
// import '../home_view/home_vu.dart';

class LoginVM extends BaseViewModel {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('User');
  final formKey = GlobalKey<FormState>();
  String? email, password;
  bool obsecurePassword = true;
  IconData iconPassword = Icons.visibility;

  obsecureToggle() {
    obsecurePassword = !obsecurePassword;
    if (obsecurePassword) {
      iconPassword = Icons.visibility;
    } else {
      iconPassword = Icons.visibility_off;
    }
    notifyListeners();
  }

  void onEmailSaved(String? value) {
    email = value;
    // user?.email = email;
  }

  void onPasswordSaved(String? value) {
    password = value;
    // user?.email = email;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4$}').hasMatch(value)) {
    //   return 'Please enter a valid email';
    // }

    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    //  else if (!RegExp(
    //         r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
    //     .hasMatch(value)) {
    //   return 'Please enter a valid password';
    // }
    return null;
  }

  void login(BuildContext context) async {
    setBusy(true);
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();

      firebaseAuth
          .signInWithEmailAndPassword(email: email!, password: password!)
          .then((userCredential) {
        SessionController().userId = userCredential.user!.uid.toString();
        Utils.toastMessage('User Logged In Successfully');

        Navigator.pushNamed(context, RouteName.btmNavScreen);
      }).catchError((error) {
        Utils.toastMessage(error.toString());
        return null;
      }).whenComplete(() => setBusy(false));
    }
    setBusy(false);
  }
}
