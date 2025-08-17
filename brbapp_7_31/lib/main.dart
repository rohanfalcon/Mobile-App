import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:brbapp/routes.dart';
import 'package:brbapp/Loading/Loading.dart';
import 'assets/brbGlobals.dart';

void main() async {
  // void main() {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  PushNotificationService pushNotificationService = PushNotificationService();
  await pushNotificationService.initialize();

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling a background message: ${message.messageId}');
  }

  void checkInitialMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      print('Initial message: ${initialMessage.notification?.title}');
    }
  }

  checkInitialMessage();
  // doesnt work

  // Messaging Stuff I added
  // Path to your service account JSON key file

  // Load the service account credentials

  // final serviceAccountJson = File(serviceAccountPath).readAsStringSync();

  /////////////////////////////////
  // await FirebaseAppCheck.instance.activate(
  // androidProvider:AndroidProvider.playIntegrity,
  // );

  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Directionality(
            textDirection: TextDirection.ltr,
            child: Text('Snapshot has Error'),
          );
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done ||
            !snapshot.hasData) {
          //return const MaterialApp(
          return MaterialApp(
            title: 'Flutter Code Sample for Navigator',
            // MaterialApp contains our top-level Navigator
            initialRoute: '/',
            routes: appRoutes,
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return const MaterialApp(home: LoadingScreen());
      },
    );
  }

  // MY code

  // My Code
}
