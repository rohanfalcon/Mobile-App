import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brbapp/User/user.dart';
import 'package:brbapp/assets/brbGlobals.dart';
import 'package:flutter/material.dart';

Future<void> addaddress(BrbUser landlord) async {
  String uid = Fireuser.toString();

  UserCollection.add({
    'firstName': landlord.firstName,
    'lastName': landlord.lastName,
    'userFirstName': landlord.userFirstName,
    'userLastName': landlord.userLastName,
    'uid': uid, //landlord.uid,
    'address': landlord.address,
    'placeID': landlord.placeID,
    'latitude': landlord.latitude,
    'longtitude': landlord.longtitude,
    'availability': landlord.availability,
    'rate': landlord.rate,
    'Due': landlord.Due,
    'startDate': landlord.startDate,
    'endDate': landlord.endDate,
    'dateStart': landlord.dateStart,
    'userStartDate': landlord.userStartDate,
    'userEndDate': landlord.userEndDate,
    'dateEnd': landlord.dateEnd,
    'timeStart': landlord.timeStart,
    'timeEnd': landlord.timeEnd, // was timeEnd
    'fileName': landlord.fileName,
    'vehicleMake': landlord.vehicleMake,
    'vehicleModel': landlord.vehicleModel,
    'plateNumber': landlord.plateNumber,
    'email': landlord.email,
    'ownerEmail': landlord.ownerEmail,
    'ownerPhone': landlord.ownerPhone,
    'phone': landlord.phone,
    'landlordHascard': landlord.landlordHascard,
  });
  //addOwner();
  return;
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
          margin: const EdgeInsets.only(left: 7),
          child: const Text("Loading..."),
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<void> updateDriveway(BrbUser landlord) async {
  //FirebaseAuth auth = FirebaseAuth.instance;

  final querySnapshot = await FirebaseFirestore.instance
      .collection('Users')
      .limit(10)
      .where('placeID', isEqualTo: landlord.placeID)
      .where('availability', isEqualTo: 'true')
      .get();

  //
  String docID;
  if (querySnapshot.docs.isNotEmpty) {
    docID = querySnapshot.docs.first.id;

    UserCollection.doc(docID).update({
      'vehicleMake': '${landlord.vehicleMake}',
      'vehicleModel': '${landlord.vehicleModel}',
      'plateNumber': '${landlord.plateNumber}',
      'email': '${landlord.email}',
      // 'availability':'${landlord.availability}',
      // 'userStartDate': '${landlord.userStartDate}', // This shoud be timestamp
      //'userEndDate': '${landlord.userEndDate}',    // should be timestamp
      'userFirstName': '${landlord.userFirstName}',
      'userLastName': '${landlord.userLastName}',
      'phone': '${landlord.phone}',
      // might as well addd the user first and lastname too
    });
  } else {
    print("WE HAVE NO driveway");
    return;
  }
  brbuser.email = landlord.email;
  brbuser.address = landlord.address;
  brbuser.ownerEmail = landlord.ownerEmail;
  brbuser.ownerPhone = landlord.ownerPhone;
  brbuser.userStartDate = landlord.userStartDate; // This is for the email data
  brbuser.userEndDate = landlord.userEndDate;
  brbuser.phone = landlord.phone;
  brbuser.email = landlord.email;

  return;
}
