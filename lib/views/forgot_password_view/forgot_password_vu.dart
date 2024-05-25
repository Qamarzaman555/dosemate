import 'dart:ui';

import 'package:dosemate/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/uk_text_button.dart';
import '../../widgets/uk_text_field.dart';
import 'forgot_password_vm.dart';

class ForgotPasswordVU extends StackedView<ForgotPasswordVM> {
  const ForgotPasswordVU({super.key});

  @override
  Widget builder(
      BuildContext context, ForgotPasswordVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
      body: Column(
        children: [
          backButton(context),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.spaceX,
                ],
              ),
              Text(
                'forgot password',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.white),
              ),
              20.spaceY,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: Text(
                  'Enter your email \nto recover your passwor',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.white, fontSize: 20),
                ),
              ),
              40.spaceY,
            ],
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: viewModel.formKey,
                  child: Column(
                    children: [
                      60.spaceY,
                      UkTextField(
                          hintText: 'Enter your email',
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5),
                          ),
                          keyBordType: TextInputType.emailAddress,
                          onSaved: viewModel.onEmailSaved,
                          validator: viewModel.emailValidator),
                      20.spaceY,
                      UkTextButton(
                        width: MediaQuery.sizeOf(context).width * 0.7,
                        text: const Text(
                          'Send',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        onPressed: viewModel.isBusy
                            ? null
                            : () {
                                viewModel.forgotPassword(context);
                              },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding backButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.sizeOf(context).height / 6, top: 70, left: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ],
      ),
    );
  }

  Widget purpleContainer(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(2.7, -1.2),
      child: Container(
        height: MediaQuery.sizeOf(context).width / 1.3,
        width: MediaQuery.sizeOf(context).width / 1.3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget pinkContainer(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(-2.7, -1.2),
      child: Container(
        height: MediaQuery.sizeOf(context).width / 1.3,
        width: MediaQuery.sizeOf(context).width / 1.3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  Widget orangeContainer(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(20, -1.2),
      child: Container(
        height: MediaQuery.sizeOf(context).width,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }

  @override
  ForgotPasswordVM viewModelBuilder(BuildContext context) => ForgotPasswordVM();
}
