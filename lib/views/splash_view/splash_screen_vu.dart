import 'package:dosemate/utils/utils.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            'Dosemate',
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          // 14.spaceY,
          Text(
            'Be in control of your meds',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 50),
          // 50.spaceY,
          // customImage(
          //     height: MediaQuery.sizeOf(context).height / 2.8,
          //     width: MediaQuery.sizeOf(context).width,
          //     'assets/macro-pills.png'),
          Container(
            height: MediaQuery.sizeOf(context).height / 2.8,
            width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/macro-pills.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }
}
