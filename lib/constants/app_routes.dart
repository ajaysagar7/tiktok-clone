import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/views/auth/signin_screen.dart';
import 'package:flutter_chat_app/src/views/auth/signup_screen.dart';
import 'package:flutter_chat_app/src/views/users_screen.dart';

class Routes {
  static const String signInScreen = "/signin";
  static const String signUpScreen = "/signup";
  static const String homeScreen = "/homescreen";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.signInScreen:
        return MaterialPageRoute(builder: (_) => const SigninScreen());
      case Routes.signUpScreen:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const UsersScreen());
      default:
        return unDefinedRoute();
    }
  }
}

Route<dynamic> unDefinedRoute() {
  return MaterialPageRoute(
      builder: (_) => Scaffold(
            appBar: AppBar(title: const Text("Undefined Route")),
            body: const Center(child: Text("No Route Found")),
          ));
}
