import 'package:flutter/material.dart';
import '../../views/view.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final arguments = settings.arguments;
    switch (settings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreenVU());

      case RouteName.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginVU());
      case RouteName.signupScreen:
        return MaterialPageRoute(builder: (_) => const SignUpVU());
      case RouteName.forgotPassScreen:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordVU());
      case RouteName.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeVU());
      case RouteName.btmNavScreen:
        return MaterialPageRoute(builder: (_) => const BottomNavigationVU());

      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}
