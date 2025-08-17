import 'package:flutter/material.dart';
import 'package:brbapp/login/login.dart';
//import 'package:brbapp/shared/shared.dart';
import 'package:brbapp/Transaction/Transaction.dart';
import 'package:brbapp/services/auth.dart';
import 'package:brbapp/Loading/loading.dart';
import 'package:upgrader/upgrader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return const Center(child: Text('You made an error'));
        } else if (snapshot.hasData) {
          // Listen to incoming messages
          FirebaseMessaging.onMessage.listen((RemoteMessage message) {
            print('Message received: ${message.notification?.title}');
            if (message.notification != null) {
              // Show both dialog and system notification
              _showMessageDialog(
                message.notification!.title,
                message.notification!.body,
                context,
              );
              //_showNotification(message.notification!.title, message.notification!.body);
            }
          });

          FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
            print('Message opened app: ${message.notification?.title}');
          });
          return const TransactionScreen();
          //return const LoginScreen();
        } else {
          return UpgradeAlert(child: const LoginScreen());
        }
      },
    );
  }

  void _showMessageDialog(String? title, String? body, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? 'Notification'),
        content: Text(body ?? 'No content available'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
