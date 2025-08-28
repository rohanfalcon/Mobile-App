import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:brbapp/User/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/src/intl/date_format.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import "package:flutter/services.dart" as s;

import '../Paypal/paypal_login.dart';

var brbuser = BrbUser(); // This will make it retain the last input. Not using.
final messaging = FirebaseMessaging.instance;

//Initialize all instances one time
final newInstance = FirebaseAuth.instance.currentUser!;
final Fireuser = newInstance.uid;
var fireuserEmail = 'not assigned';
dynamic accessToken;
dynamic token;

final CollectionReference UserCollection = FirebaseFirestore.instance
    .collection('Users');

bool login = false;
bool transmit = false;
bool guestAccess = false;
var docPath = '';
var userEmail = '';
var globalFileName = '';
late BuildContext globalContext;
//bool pick = false;

////***************************************************************************************
const username =
    'AevJ4ZoI7uKpAreL_FnWzJH_5KuOcTrPwTVsa9JAVwyUs-t6EUkYuQjHJpQPuj4swO_9iOPmXZOyJW7A'; // prod
const password =
    'EDBnNEbMlqShenpSWfBAhPzlG21yDiw4jSnJn0heylM0yrp2oGukASn071Tt220mSgvbskP_P0YJjohs'; //

const redirectURL = 'brbapp://auth';
//final username = 'ARMCFU9AHMEPcEvJAbTkJAdPeoitl4C5gZfHTK94b5FeVtpmcUqu13BGS_hz3R7Kw2vn962L1V8QzEKN';
//final password = 'EEUmyDHy6F8_04bu6uS0MKb0rhqxxDJab2yTiV8lLg85Z7kT7wKtPd6LrPRJKLMCBuywKTCxCjyIZc6X';

//const env = 'developer.paypal.com';
//const env ='api.sandbox.paypal.com';
const env = 'api.paypal.com';

////****************************************************************************************

var themeColor = const Color.fromARGB(200, 114, 101, 252);

/*getemail(BuildContext context) {
 final newuser =  FirebaseAuth.instance.currentUser!.email;
 print('this is email $newuser');
 return newuser;
} */

sendNotification(title, messageBody, localtoken) async {
  // Scopes required for Firebase Cloud Messaging
  const List<String> scopes = [
    'https://www.googleapis.com/auth/firebase.messaging',
  ];
  final serviceAccountJson = await s.rootBundle.loadString(
    "lib/assets/serviceAccountKey.json",
  );
  // Obtain credentials using the service account
  final credentials = ServiceAccountCredentials.fromJson(serviceAccountJson);

  // Obtain an OAuth2 access token
  final authClient = await clientViaServiceAccount(credentials, scopes);

  // Print the access token
  //print('This is Access Token: ${authClient.credentials.accessToken.data}');
  //print('This is Access Token: ${authClient.credentials.accessToken}');
  accessToken = authClient.credentials.accessToken.data;

  // Close the client
  authClient.close();

  //if (context.mounted) {

  // }
  if (kDebugMode) {}
  var data = {
    "message": {
      "token":
          localtoken, // If this token changes and cause problems now with new builds. Token management must be implemented
      "notification": {"title": title, "body": messageBody},
    },
  };
  var response = await http.post(
    Uri.parse(
      'https://content-fcm.googleapis.com/v1/projects/brb-project-234ba/messages:send?alt=json',
    ),
    //var response= await http.post(Uri.parse('https://content-fcm.googleapis.com/v1/projects/brb-project-234ba/messages:send'),
    body: jsonEncode(data),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    },
  );

  print('This is response ${response.body}');
  print('This is phone token $localtoken');
}

String fixDate(DateTime mydate) {
  //var now = DateTime.now();
  //String fixedate = DateFormat('yyyy/MM/dd hh:mm').format(mydate);   //yyyy/MM/dd hh:mm
  String fixedate = DateFormat('MM/dd/yyyy hh:mm').format(mydate);
  String date = fixedate;
  //DateFormat myDateFormat = DateFormat('yyyy/MM/dd hh:mm');
  DateFormat myDateFormat = DateFormat('MM/dd/yyyy hh:mm');
  DateTime newDate = myDateFormat.parse(date);
  String amPm = 'AM';
  if (mydate.hour >= 12) {
    amPm = 'PM';
  }
  var myString =
      myDateFormat.format(newDate) + DateFormat('').format(newDate) + amPm;
  return myString;
}

Future<bool> getEmail(BuildContext context, uid) async {
  if (context.mounted) {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PayPalLoginPage()),
    );
  }
  final email1 = userEmail;
  print('Paypal email is from Transaction Screen $email1');
  // put email in the database
  if (email1 != '') {
    final CollectionReference paypalCollection = FirebaseFirestore.instance
        .collection('paypal');
    paypalCollection.add({'uid': uid, 'paypalemail': email1});
    userEmail = ''; // re-initialize
    // no More dialog
    return true;
  } else {
    return false;
  }
}

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('lib/assets/$path');
  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.writeAsBytes(
    byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
  );
  return file;
}

updateIcon(context) {
  _reloadPage(context);
  return fireuserEmail;
}

Future<void> _reloadPage(BuildContext context) async {
  //Navigator.pop(context);
  await Navigator.of(
    context,
  ).pushNamedAndRemoveUntil('/transaction', (route) => true);
}

MyAlert(BuildContext context, message) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.pushNamed(context, '/transaction');
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Checker"),
    content: Text(message),
    actions: [okButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User denied or provisionally denied permission');
    }

    // Retrieve and log the FCM token
    token = await _firebaseMessaging.getToken(); // Done already
    print("FCM Token: $token");
  } // initialize
}
