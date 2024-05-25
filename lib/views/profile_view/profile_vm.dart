import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'dart:io';
import '../../services/session_manager.dart';
import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { male, female }

class ProfileVM extends BaseViewModel {
  final ImagePicker _picker = ImagePicker();
  File? profileImage;
  String? profileImageUrl;
  String? firstName;
  String? lastName;
  String? email;
  String? dob;
  String? phoneNumber;
  Gender? gender;
  String? address;

  final formKey = GlobalKey<FormState>();

  ProfileVM() {
    fetchProfileData();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  void logOut(BuildContext context) {
    auth.signOut().then((value) {
      Navigator.pushNamed(context, RouteName.loginScreen);
      Utils.toastMessage('Logged Out Successfully');
    });
  }

  Future<void> fetchProfileData() async {
    setBusy(true);
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(SessionController().userId)
          .get();

      firstName = userDoc['firstName'] as String?;
      lastName = userDoc['lastName'] as String?;
      dob = userDoc['dob'] as String?;
      phoneNumber = userDoc['phoneNumber'] as String?;
      gender = userDoc['gender'] != null
          ? Gender.values.firstWhere(
              (g) => g.toString().split('.').last == userDoc['gender'])
          : null;
      address = userDoc['address'] as String?;
      profileImageUrl = userDoc['profilePictureUrl'] as String?;

      notifyListeners();
    } catch (e) {
      Utils.toastMessage(e.toString());
    }
    setBusy(false);
  }

  void onFirstNameSaved(String? value) {
    firstName = value;
  }

  void onLastNameSaved(String? value) {
    lastName = value;
  }

  void onDOBSaved(String? value) {
    dob = value;
  }

  void onPhoneNoSaved(String? value) {
    phoneNumber = value;
  }

  void onGenderSaved(Gender? value) {
    gender = value;
  }

  void onAddressSaved(String? value) {
    address = value;
  }

  String? firstNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'First Name is required';
    }
    return null;
  }

  String? lastNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last Name is required';
    }
    return null;
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> uploadProfilePicture(BuildContext context) async {
    if (profileImage == null) {
      Utils.toastMessage('No image selected');
      return;
    }

    setBusy(true);

    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${SessionController().userId}');
      UploadTask uploadTask = storageReference.putFile(profileImage!);

      await uploadTask.whenComplete(() {});

      String downloadUrl = await storageReference.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(SessionController().userId)
          .update({
        'profilePictureUrl': downloadUrl,
      });

      profileImageUrl = downloadUrl;
      Utils.toastMessage('Profile picture uploaded successfully');
    } catch (e) {
      Utils.toastMessage(e.toString());
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> updateProfileData() async {
    setBusy(true);

    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(SessionController().userId)
            .update({
          'firstName': firstName,
          'lastName': lastName,
          'dob': dob,
          'phoneNumber': phoneNumber,
          'gender': gender.toString().split('.').last,
          'address': address,
        });

        Utils.toastMessage('Profile updated successfully');
      } catch (e) {
        Utils.toastMessage(e.toString());
      }
      setBusy(false);
      notifyListeners();
    }
  }
}
