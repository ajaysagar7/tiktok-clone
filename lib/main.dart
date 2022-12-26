import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_app/constants/app_routes.dart';
import 'package:flutter_chat_app/src/provider/auth_provider.dart';
import 'package:flutter_chat_app/src/provider/notification_provider.dart';
import 'package:flutter_chat_app/src/provider/validation_provider.dart';
import 'package:flutter_chat_app/src/views/auth/notification_example.dart';
import 'package:flutter_chat_app/src/views/home_screen.dart';
import 'package:flutter_chat_app/src/views/users_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'src/views/auth/signin_screen.dart';

AndroidNotificationChannel androidNotificationChannel =
    const AndroidNotificationChannel(
        importance: Importance.high,
        playSound: true,
        description: "push notification in flutter",
        enableLights: true,
        enableVibration: true,
        showBadge: true,
        "high_importance_channel",
        "this channel is used for high important notifications");

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  //
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (
          c,
          _,
        ) =>
            MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => AuthProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => ValidationProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => NotificationProvider(),
                ),
              ],
              child: MaterialApp(
                title: 'Chat App',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                onGenerateRoute: RouteGenerator.getRoute,
                // initialRoute: Routes.signInScreen,
                home: StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        return const HomeScreen();
                      } else if (!snapshot.hasData) {
                        return const SigninScreen();
                      }
                      return Container();
                    }),
              ),
            ));
  }
}
