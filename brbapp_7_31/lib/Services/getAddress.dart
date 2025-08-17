import 'dart:async';
// import 'dart:js';
// import 'dart:js_interop_unsafe';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brbapp/Services/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../CancelPost/cancelPost.dart';
import '../Card/card.dart';
import '../assets/brbGlobals.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<List<Users>> getAddress() async {
    var ref = _db.collection('Users');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var guys = data.map((d) => Users.fromJson(d));
    //print('this is guys ${guys.first.timeStart}');
    return guys.toList();
  }
}

Future<bool> checkCard() async {
  bool status;
  String uid = FirebaseAuth
      .instance
      .currentUser!
      .uid; // auth.currentUser!.uid.toString();

  /*var renter = await FirebaseFirestore.instance.collection('Cards')  this is for credit card paybacks */
  var renter = await FirebaseFirestore.instance
      .collection('paypal')
      .limit(10)
      .where(
        'uid',
        isEqualTo: uid,
      ) // Now all landlords have to save their cards from the get go
      .get();
  var data = renter.docs.map((s) => s.data());
  var cardData = data.map((d) => Paypal.fromJson(d));

  if (cardData.isEmpty) {
    status = false;
  } else {
    status = true;
  }
  return status;
}

Future<bool> checkBooking() async {
  bool status;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  var renter = await FirebaseFirestore.instance
      .collection('Users')
      .limit(10)
      .where('userUid', isEqualTo: uid)
      .where(
        'availability',
        isEqualTo: 'false',
      ) // This for now prevents double booking on any property we can allow it later but to different location ID
      .get();
  var data = renter.docs.map((s) => s.data());
  var userData = data.map((d) => Users.fromJson(d));

  if (userData.isEmpty) {
    print("Booking we are false");
    status = false;
  } else {
    status = true;
    print('this is true booking uid $uid');
  }
  return status;
}

cancelRental(context) async {
  // Currently your post is your profile
  int status;
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid.toString();
  var data = await FirebaseFirestore.instance
      .collection('Users')
      .limit(10)
      .where('userUid', isEqualTo: uid)
      .where('availability', isEqualTo: 'false')
      /// just change this to true then give back the money check the time frame and charge transaction fee
      .get();
  var data0 = data.docs.map((s) => s.data());
  var userData = data0.map((d) => Users.fromJson(d));
  if (userData.isNotEmpty) {
    DocumentSnapshot document = data.docs.first;
    double refund = document['Due'] - 3.00; // Take our fee

    status = await refundCustomer(
      '$refund',
      context,
      document,
    ); //refund customer
    print('This is refund $refund  and status $status');
    if (status == 201) {
      document.reference.update({
        'availability': 'true',
        // 'Due': '$refund',
        'userUid': '',
      });
      // get the updated document
      var data = await FirebaseFirestore.instance
          .collection('Users')
          .limit(10)
          .where('placeID', isEqualTo: document['placeID'])
          .where('availability', isEqualTo: 'true')
          /// just change this to true then give back the money check the time frame and charge transaction fee
          .get();
      //var _data = data.docs.map((s)=> s.data());
      //var userData = _data.map((d) => Users.fromJson(d));

      DocumentSnapshot document2 = data.docs.first;
      cancelEmail(document2, context);
      print(document['landlordHascard']);
      await sendNotification(
        "Tenant Canceled",
        "Your Tenant just cancelled",
        document['landlordHascard'],
      );
    }
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Rent requested'),
        content: const Text('You never booked anything'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pushNamed(context, '/transaction');
            },
          ),
        ],
      ),
    );
  }
}

deleteCard() async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  var renter = await FirebaseFirestore.instance
      .collection('Cards')
      .limit(10)
      .where('userUid', isEqualTo: uid)
      //.where('availability', isNotEqualTo: 'false')// Now all landlords have to save their cards from the get go
      .get();

  var data = renter.docs.map((s) => s.data());
  var userData = data.map((d) => Users.fromJson(d));
  if (userData.isNotEmpty) {
    renter.docs.first.reference.delete();
  }

  // this assumes the user only have one card which is all we currently allow
}

deletePaypal(
  BuildContext context,
) // This will delete all driveways that are available only
async {
  // Currently your post is your profile
  FirebaseFirestore db = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  var data = await FirebaseFirestore.instance
      .collection('paypal')
      .where('uid', isEqualTo: uid)
      .get();
  var data0 = data.docs.map((s) => s.data());
  var userData = data0.map((d) => Paypal.fromJson(d));

  if (userData.isNotEmpty) {
    var mover = data.docs.iterator;
    //mover.moveNext();
    while (mover.moveNext()) // Get all his post
    {
      var docID = mover.current.id;
      var docRef = db.collection('paypal').doc(docID);
      print("Deleting paypal $docID");
      docRef.delete();
    }
  } else {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Paypal status'),
          content: const Text('No existing Paypal account'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }
}

deleteLocations(BuildContext context) async {
  // Currently your post is your profile
  FirebaseFirestore db = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  var data = await FirebaseFirestore.instance
      .collection('Users')
      .where('uid', isEqualTo: uid)
      .where('availability', isNotEqualTo: 'false')
      .get();
  var data0 = data.docs.map((s) => s.data());
  var userData = data0.map((d) => Users.fromJson(d));
  if (userData.isNotEmpty) {
    var mover = data.docs.iterator;
    //mover.moveNext();
    while (mover.moveNext()) // Get all his post
    {
      var docID = mover.current.id;
      var docRef = db.collection('Users').doc(docID);
      print("This is doc $docID");
      docRef.delete();
      //data.docs.first.reference.delete(); // if
    }
  } else {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('No Profile created'),
          content: const Text('You have never posted'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  if (context.mounted) {
    deletePaypal(context);
  }
}
