import 'package:dosemate/utils/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import '../../utils/routes/routes_name.dart';
import '../../widgets/uk_text_button.dart';
import '../../widgets/uk_text_field.dart';
import 'signup_vm.dart';

class SignUpVU extends StackedView<SignUpVM> {
  const SignUpVU({super.key});

  @override
  Widget builder(BuildContext context, SignUpVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
      body: Column(
        children: [
          headerText(context),
          Expanded(
            child: Container(
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
                      40.spaceY,
                      emailField(context, viewModel),
                      20.spaceY,
                      passwordField(viewModel, context),
                      20.spaceY,
                      passwordValidatorView(viewModel, context),
                      20.spaceY,
                      firstNameField(context, viewModel),
                      20.spaceY,
                      lastNameField(context, viewModel),
                      30.spaceY,
                      signUpBtn(context, viewModel),
                      12.spaceY,
                      signinNavBtn(context),
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

  Widget signinNavBtn(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RouteName.loginScreen);
      },
      child: Text.rich(
        TextSpan(
          text: "Already have an account? ",
          style: Theme.of(context).textTheme.titleMedium,
          children: [
            TextSpan(
              text: 'Create here',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary),
            )
          ],
        ),
      ),
    );
  }

  Widget signUpBtn(BuildContext context, SignUpVM viewModel) {
    return UkTextButton(
      width: MediaQuery.sizeOf(context).width * 0.7,
      label: 'Sign Up',
      onPressed: () {
        viewModel.signUp(context);
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget lastNameField(BuildContext context, SignUpVM viewModel) {
    return UkTextField(
        hintText: 'Last Name',
        prefixIcon: Icon(
          Icons.mail,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        ),
        keyBordType: TextInputType.text,
        onSaved: viewModel.onLastNameSaved,
        validator: viewModel.lastNameValidator);
  }

  Widget firstNameField(BuildContext context, SignUpVM viewModel) {
    return UkTextField(
        hintText: 'First Name',
        prefixIcon: Icon(
          Icons.mail,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        ),
        keyBordType: TextInputType.text,
        onSaved: viewModel.onFirstNameSaved,
        validator: viewModel.firstNameValidator);
  }

  Widget emailField(BuildContext context, SignUpVM viewModel) {
    return UkTextField(
        hintText: 'Email',
        prefixIcon: Icon(
          Icons.mail,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        ),
        keyBordType: TextInputType.emailAddress,
        onSaved: viewModel.onEmailSaved,
        validator: viewModel.emailValidator);
  }

  Widget headerText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.sizeOf(context).height / 9, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hello',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(color: Colors.white),
          ),
          20.spaceY,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Text(
              "Let's create an account",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget passwordField(SignUpVM viewModel, BuildContext context) {
    return UkTextField(
      hintText: 'password',
      obsecureText: viewModel.obsecurePassword,
      suffixIcon: IconButton(
          onPressed: () => viewModel.obsecureToggle(),
          icon: Icon(
            viewModel.iconPassword,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          )),
      prefixIcon: Icon(
        Icons.password,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
      onSaved: viewModel.onPasswordSaved,
      validator: viewModel.passwordValidator,
      onChanged: viewModel.onChangedValue,
    );
  }

  Widget passwordValidatorView(SignUpVM viewModel, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "⚈  1 uppercase",
              style: TextStyle(
                  color: viewModel.containsUpperCase
                      ? Colors.green
                      : Theme.of(context).colorScheme.outline.withOpacity(0.5)),
            ),
            Text(
              "⚈  1 lowercase",
              style: TextStyle(
                  color: viewModel.containsLowerCase
                      ? Colors.green
                      : Theme.of(context).colorScheme.outline.withOpacity(0.5)),
            ),
            Text(
              "⚈  1 number",
              style: TextStyle(
                  color: viewModel.containsNumber
                      ? Colors.green
                      : Theme.of(context).colorScheme.outline.withOpacity(0.5)),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "⚈  1 special character",
              style: TextStyle(
                  color: viewModel.containsSpecialChar
                      ? Colors.green
                      : Theme.of(context).colorScheme.outline.withOpacity(0.5)),
            ),
            Text(
              "⚈  8 minimum character",
              style: TextStyle(
                  color: viewModel.contains8Length
                      ? Colors.green
                      : Theme.of(context).colorScheme.outline.withOpacity(0.5)),
            ),
          ],
        ),
      ],
    );
  }

  @override
  SignUpVM viewModelBuilder(BuildContext context) => SignUpVM();
}
