import 'dart:core';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:churchapp/Model/PushNotification.dart';
import 'package:churchapp/Screens/Dashboard/Dashboard.dart';
import 'package:churchapp/Screens/Landing.dart';
import 'package:churchapp/Screens/RestService/MasstimingService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'Screens/LoginPage/login_screen.dart';
import 'amplifyconfiguration.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _isAmplifyConfigured = false;

  @override
  initState() {
    super.initState();
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    // pushNotificationService.notificationPluginInitilization(); //Test
    // MassTimingService().updateWeelyMassTiming1(); //Test
    pushNotificationService.initialise();
    pushNotificationService.context = context;

    // configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barnabas',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 219, 69, 71),
      ),
      routes: <String, WidgetBuilder>{
        '/': (context) => Landing(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => Dashboard(),
      },
    );
  }

  void configureAmplify() async {
    // First add plugins (Amplify native requirements)

    AmplifyAuthCognito auth = new AmplifyAuthCognito();
    Amplify.addPlugins([auth]);

    try {
      // Configure
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      print(
          'Amplify was already configured. Looks like app restarted on android.');
    }

    setState(() {
      _isAmplifyConfigured = true;
    });
  }
}

// Map<String, dynamic> userAttributes = {
//       'email': 'dineshprasanna1987@gmail.com',
//       // Note: phone_number requires country code
//       'phone_number': '+919994490142',
//     };

firebaseSetUP() async {
  // try {
  //   SignUpResult res = await Amplify.Auth.signUp(
  //       username: '+919994490142', password: 'mysupersecurepassword');
  //   print(res);
  // } on AuthException catch (e) {
  //   print(e.exception);
  // }
  // FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // firebaseMessaging.requestPermission(alert: true, badge: false, sound: true);
  // tokenCreation();
  // receiveFirebbasePushMessageHadling();
}

// receiveFirebbasePushMessageHadling() {
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     log('[onMessage] message: $message');
//     showNotification(message);
//   });
//   FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
// }

// Future<void> onBackgroundMessage(RemoteMessage message) {
//   log('[onBackgroundMessage] message: $message');
//   showNotification(message);
//   return Future.value();
// }

// tokenCreation() async {
//   FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//   String token;
//   if (Platform.isAndroid) {
//     token = await firebaseMessaging.getToken();
//   } else if (Platform.isIOS) {
//     token = await firebaseMessaging.getAPNSToken();
//   }

//   if (token.isNotEmpty) {
//     subscribe(token);
//   }

//   firebaseMessaging.onTokenRefresh.listen((newToken) {
//     subscribe(newToken);
//   });
// }

// subscribe(String token) async {
//   log('[subscribe] token: $token');
// }

// void showNotification(RemoteMessage message) {}
