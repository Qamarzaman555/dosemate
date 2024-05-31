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
  late final ImageProvider backgroundImage;

  @override
  void initState() {
    super.initState();
    backgroundImage = const AssetImage('assets/macro-pills.jpg');
    splashServices.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height / 2.8;
    final double screenWidth = MediaQuery.of(context).size.width;

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
          14.spaceY,
          Text(
            'Be in control of your meds',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          50.spaceY,
          SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: Image(
              image: backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
