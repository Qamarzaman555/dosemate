import 'package:dosemate/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../widgets/uk_appbar.dart';
import '../../widgets/uk_text_button.dart';
import '../../widgets/uk_text_field.dart';
import 'profile_vm.dart';

class ProfileVU extends StackedView<ProfileVM> {
  const ProfileVU({super.key});

  @override
  Widget builder(BuildContext context, ProfileVM viewModel, Widget? child) {
    return Scaffold(
      appBar: const UkAppBar(
        title: 'Profile',
        automaticallyImplyLeading: false,
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: viewModel.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    20.spaceY,
                    if (viewModel.profileImage != null)
                      InkWell(
                        onTap: () => profileUpload(context, viewModel),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(viewModel.profileImage!),
                        ),
                      )
                    else if (viewModel.profileImageUrl != null &&
                        viewModel.profileImageUrl!.isNotEmpty)
                      InkWell(
                        onTap: () => profileUpload(context, viewModel),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(viewModel.profileImageUrl!),
                        ),
                      )
                    else
                      InkWell(
                        onTap: () => profileUpload(context, viewModel),
                        child: const CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person),
                        ),
                      ),
                    30.spaceY,
                    firstNameField(viewModel, context),
                    12.spaceY,
                    lastNameField(viewModel, context),
                    12.spaceY,
                    dobField(viewModel, context),
                    12.spaceY,
                    addressField(viewModel, context),
                    12.spaceY,
                    phoneNoField(viewModel, context),
                    12.spaceY,
                    genderSelectionBtns(viewModel),
                    12.spaceY,
                    saveProfileBtn(context, viewModel),
                    12.spaceY,
                    logoutBtn(context, viewModel),
                  ],
                ),
              ),
            ),
    );
  }

  Widget logoutBtn(BuildContext context, ProfileVM viewModel) {
    return UkTextButton(
      width: MediaQuery.sizeOf(context).width * 0.7,
      text: const Text('Logout'),
      onPressed: () => viewModel.logOut(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget saveProfileBtn(BuildContext context, ProfileVM viewModel) {
    return UkTextButton(
      width: MediaQuery.sizeOf(context).width * 0.7,
      text: const Text('Save Changes'),
      onPressed: () => viewModel.updateProfileData(),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget genderSelectionBtns(ProfileVM viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<Gender>(
          value: Gender.male,
          groupValue: viewModel.gender,
          onChanged: viewModel.onGenderSaved,
        ),
        const Text('Male'),
        Radio<Gender>(
          value: Gender.female,
          groupValue: viewModel.gender,
          onChanged: viewModel.onGenderSaved,
        ),
        const Text('Female'),
      ],
    );
  }

  Widget phoneNoField(ProfileVM viewModel, BuildContext context) {
    return UkTextField(
      hintText: 'Phone Number',
      initialValue: viewModel.phoneNumber,
      prefixIcon: Icon(
        Icons.phone,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
      keyBordType: TextInputType.phone,
      onSaved: viewModel.onPhoneNoSaved,
    );
  }

  Widget addressField(ProfileVM viewModel, BuildContext context) {
    return UkTextField(
      hintText: 'Address',
      initialValue: viewModel.address,
      prefixIcon: Icon(
        Icons.location_on,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
      keyBordType: TextInputType.text,
      onSaved: viewModel.onAddressSaved,
    );
  }

  Widget dobField(ProfileVM viewModel, BuildContext context) {
    return UkTextField(
      hintText: 'DOB',
      initialValue: viewModel.dob,
      prefixIcon: Icon(
        Icons.cake,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
      keyBordType: TextInputType.text,
      onSaved: viewModel.onDOBSaved,
    );
  }

  Widget lastNameField(ProfileVM viewModel, BuildContext context) {
    return UkTextField(
      hintText: 'Last Name',
      initialValue: viewModel.lastName,
      prefixIcon: Icon(
        Icons.person,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
      keyBordType: TextInputType.text,
      onSaved: viewModel.onLastNameSaved,
      validator: viewModel.lastNameValidator,
    );
  }

  Widget firstNameField(ProfileVM viewModel, BuildContext context) {
    return UkTextField(
      hintText: 'First Name',
      initialValue: viewModel.firstName,
      prefixIcon: Icon(
        Icons.person,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
      keyBordType: TextInputType.text,
      onSaved: viewModel.onFirstNameSaved,
      validator: viewModel.firstNameValidator,
    );
  }

  @override
  ProfileVM viewModelBuilder(BuildContext context) => ProfileVM();
}

profileUpload(BuildContext context, ProfileVM viewModel) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        title: const Text('Upload Profile Picture'),
        content: const Text('Select the picture you want to upload'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customButtons(context, () {
                viewModel.pickImage();
              }, 'Select'),
              customButtons(context, () {
                viewModel.uploadProfilePicture(context);
                Navigator.pop(context);
              }, 'Upload'),
            ],
          ),
        ],
      );
    },
  );
}

Widget customButtons(
    BuildContext context, void Function()? onTap, String text) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    ),
  );
}
