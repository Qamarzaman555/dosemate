import 'package:flutter/material.dart';
import '../../services/splash_services.dart';

class SplashScreenVU extends StatefulWidget {
  const SplashScreenVU({super.key});

  @override
  State<SplashScreenVU> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenVU> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    super.initState();
    splashServices.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dosemate',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Be in control of your meds',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
