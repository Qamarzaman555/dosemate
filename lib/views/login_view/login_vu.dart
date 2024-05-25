import 'package:dosemate/utils/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import '../../utils/routes/routes_name.dart';
import '../../widgets/uk_text_button.dart';
import '../../widgets/uk_text_field.dart';
import 'login_vm.dart';

class LoginVU extends StackedView<LoginVM> {
  const LoginVU({super.key});

  @override
  Widget builder(BuildContext context, LoginVM viewModel, Widget? child) {
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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        children: [
                          appName(context),
                          20.spaceY,
                          emailField(context, viewModel),
                          24.spaceY,
                          passwordField(viewModel, context),
                          8.spaceY,
                          forgotPassTextBtn(context),
                          32.spaceY,
                          signinBtn(context, viewModel),
                          12.spaceY,
                          signupNavBtn(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget signupNavBtn(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RouteName.signupScreen);
      },
      child: Text.rich(
        TextSpan(
          text: "Don't have an account? ",
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

  Widget appName(BuildContext context) {
    return Text(
      'Dosemate',
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700),
    );
  }

  Widget headerText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.sizeOf(context).height / 6, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome Back',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(color: Colors.white),
          ),
          20.spaceY,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Text(
              'We are ready to assist your health here',
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

  Widget signinBtn(BuildContext context, LoginVM viewModel) {
    return UkTextButton(
      width: MediaQuery.sizeOf(context).width * 0.7,
      text: const Text(
        'Sign In',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
      ),
      onPressed: () {
        viewModel.login(context);
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget forgotPassTextBtn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteName.forgotPassScreen);
          },
          child: Text.rich(
            TextSpan(
              text: 'forgot password?',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Colors.black.withOpacity(0.7)),
              children: [
                TextSpan(
                  text: 'Click here',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary),
                )
              ],
            ),
          ),
        ),
        24.spaceX,
      ],
    );
  }

  Widget passwordField(LoginVM viewModel, BuildContext context) {
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
        validator: viewModel.passwordValidator);
  }

  Widget emailField(BuildContext context, LoginVM viewModel) {
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

  @override
  LoginVM viewModelBuilder(BuildContext context) => LoginVM();
}
