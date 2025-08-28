//import 'package:example/app_colors.dart';

import 'package:mailer/mailer.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_credit_card/credit_card_brand.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brbapp/assets/brbGlobals.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';
import '../CreateOrder/createOrder.dart';
import '../Paypal/paypal.dart';
import '../Services/models.dart';
import '../Transaction/Transaction.dart';
//import 'firebase_options.dart';
// FlutterFire's Firebase Cloud Messaging plugin

class Card extends StatefulWidget {
  const Card({Key? key}) : super(key: key);

  @override
  State<Card> createState() => CardState();
}

class CardState extends State<Card> {
  late num charge;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _onValidate(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // While waiting for the future
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          //return Text('Key: ${snapshot.data!['key']}'); // Access 'key' from data
          return const Text("done");
        } else {
          return const Text('Thank you');
        }
      },
    );
  }

  Future<void> _onValidate(context) async {
    charge = getRate();
    await Future.delayed(const Duration(seconds: 2));
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PaypalPaymentDemo(amount: charge, myContext: context),
      ),
    );
    // We should do a navigator pop here

    if (context.mounted) {
      takeMoney("Parking fee", context);
      // Take Money  then do the confirmation page. This page should display the amount of money and booking information nicely.
      // use a new dart file in the conformation folder.
    }
    //return {'key': 'value'};
  }

  void sendEmail() async {
    // Note that using a username and password for gmail only works if
    // you have two-factor authentication enabled and created an App password.
    // Search for "gmail app password 2fa"
    // The alternative is to use oauth.
    String username = 'rohanfalcon111';
    String password = 'frnfdygqxnajseem';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    //final smtpServer = SmtpServer('smtp.gmail.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = const Address(
        'brb.parking@outlook.com',
        'brb.parking@outlook.com',
      )
      ..recipients.add(brbuser.email)
      //..ccRecipients.addAll(['', ''])
      ..bccRecipients.add('${brbuser.ownerEmail}') // bcc not working
      ..subject = 'Your driveway rental'
      // **********************************************************************************************************************************************
      ..html =
          '<p> Hi ${brbuser.firstName} <br> Your driveway rental for ${brbuser.address}  Starting ${fixDate(brbuser.userStartDate)}<br>'
          'and ending ${fixDate(brbuser.userEndDate)} has been processed.'
          'You Card wil be charged \$ $charge <br>'
          'We may contact you at your number ${brbuser.phone} if we have any questions<br>'
          ' Thank you for your business <br> <br> </p>'
          'Landlord info <br>'
          'Phone ${brbuser.ownerPhone}<br>'
          'Email ${brbuser.ownerEmail}<br>'
          '<h1>BrB Parking LLC</h1>'
          "<img src='data:image/png;base64,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' width='50' height='50' alt='Company Logo'>";

    // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    // Add the user's times
    CollectionReference user = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String userUid = auth.currentUser!.uid.toString();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .limit(10)
        .where(
          'placeID',
          isEqualTo: brbuser.placeID,
        ) // This assume one tennant per place Id
        .get();
    var docID = querySnapshot.docs.first.id;

    user.doc(docID).update({
      'userStartDate': brbuser.userStartDate,
      'userEndDate': brbuser.userEndDate,
      'userUid': userUid,
    });

    // ********************************************
    try {
      final sendReport = await send(
        message,
        smtpServer,
        timeout: const Duration(seconds: 15),
      );
      print('Message sent: ${sendReport.toString()}');
    } on MailerException catch (e) {
      print('Message not sent. Owner email ${brbuser.ownerEmail}');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      // At this point we will have the card data if it is good
      // we can just send them back to the Vehicle screen for email
    }
    // DONE
  }

  num getRate() {
    Timestamp end2;
    end2 = Timestamp.fromDate(brbuser.userEndDate);
    Timestamp end1 = Timestamp.fromDate(brbuser.userStartDate);
    final DateTime end = DateTime.fromMicrosecondsSinceEpoch(
      end2.microsecondsSinceEpoch,
    );
    final DateTime start = DateTime.fromMicrosecondsSinceEpoch(
      end1.microsecondsSinceEpoch,
    );

    Duration total = end.difference(start); // * rate
    double Shours = double.parse((total.inMinutes / 60).toString());
    double hours = double.parse(Shours.toStringAsFixed(1));
    print('This end date ${brbuser.userEndDate}');
    double myfee = (hours * double.parse('${brbuser.rate}')) * .05;
    double Scharge =
        hours * double.parse('${brbuser.rate}') + myfee; // + service charge
    double charge = double.parse(Scharge.toStringAsFixed(2));
    //double cut = charge * .10; // 10% cut is ours but at checkout

    print(
      'this is totalhours $hours Charge \$ $charge Total $total',
    ); // Charge should be saved for checkout payment to landlord
    /* if(context.mounted) {
      Navigator.pushNamed(context, '/confirmation');
      // We might want to confirm the information here
      //or send out an email again.
    } */
    return charge;
  } //  End get rate

  // This function takes money right off a credit or debit card
  Future<void> takeMoney(String title, context) async {
    // Creates a keyed charge
    print('This is transmit at Takemoney $transmit');
    if (transmit) // was 201
    //if (response.statusCode == 403)
    {
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .limit(10)
          .where('placeID', isEqualTo: brbuser.placeID)
          .get();

      var data = snapshot.docs.map((s) => s.data());
      var tokendata = data.map((d) => Users.fromJson(d));

      snapshot.docs.first.reference.update({
        'availability': 'false',
        'Due': charge,
      });
      sendEmail();
      await sendNotification(
        'Your property',
        'You have a new tennant',
        tokendata.first.landlordHascard,
      );
      print('We tried a notification');
      Navigator.pushNamed(context, '/confirmation');
      //return Album.fromJson(jsonDecode(response.body));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment data'),
          content: const Text('Payment Transfer failed'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/transaction');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // @override
  //dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  //}   // Class ends
}

charge(String amount, BuildContext context, DocumentSnapshot document) async {
  // Get the card of anyone
  await Future.delayed(const Duration(seconds: 2));
  if (context.mounted) {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (
              context,
            ) => // yeah but this is paying for a property not for a charge.   !!!
                PaypalPaymentDemo(amount: amount, myContext: context),
      ),
    );
  }
  /* var renter = await FirebaseFirestore.instance.collection('Cards')
        .limit(10)
        .where('userUid',
        isEqualTo: uid) // Now all landlords have to save their cards from the get go
        .get();
    var _data = renter.docs.m ap((s) => s.data());
    var cardData = _data.map((d) => Cards.fromJson(d));
    // Take Payment

    var _amount = (double.parse(amount) * 100).round();
    var _month = cardData.first.expiryDate.split('/');
    var card = cardData.first.Number.split(' ');
    var _cardNumber = card.join(''); */
  //final response = await
  /* http.post(
        Uri.parse('https://api.payarc.net/v1/charges'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $Access_Token_Payarc',
        },
        body: jsonEncode(<String, String>{
          'title': 'Charge for Cancel',
          'exp_year': '${_month.last}',
          'exp_month': '${_month.first}',
          'amount': '$_amount',
          'currency': 'usd',
          'statement_description': 'Brb Rental Payment',
          'email': document['email'],
          'phone_number': document['phone'], //'${brbuser.ownerPhone}',
          'card_number': '$_cardNumber',
          'cvv': '${cardData.first.cvvCode}',
          'card_holder_name': '${document['firstName']} ${document['lastName']}',
          'metadata': '{"FullCustomerName" : "${document['firstName']} ${document['lastName']}"} '
        }) */

  if (transmit) //testing
  //if (response.statusCode == 403)
  {
    //print('This is response 201 ${response.body} and status ${response.statusCode}  ');
    if (context.mounted) {
      // no need for a query we already have the document
      /*final snapshot = await FirebaseFirestore.instance
            .collection('Users')
            .limit(10)
            .where('placeID', isEqualTo: document['placeID'])  //brbuser.placeID)
            .get();   */

      // var _data = snapshot.docs.map((s)=> s.data());
      //var tokendata = _data.map((d) => Users.fromJson(d));
      // Tell the landlord his place is rented   RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
      // It requests a registration token for sending messages to users from your App server or other trusted server environment.
      if (context.mounted) {
        globalContext = context;
        await sendNotification(
          'Payment',
          'Your Payment of $amount was successful',
          document['landlordHascard'],
        );
      }
      // time for messaging
      print('We just hit the charge function');
      Navigator.pushNamed(context, '/confirmation'); // notify the landlord
    }
  } else {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Data'),
          content: const Text('Invalid Payment Data'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    //print('This is response ${response.body} and status ${response.statusCode}  ');
    return;
  }
}

// This is the landlord refunding the customer from his card.
Future<int> refundCustomer(
  String amount,
  BuildContext context,
  DocumentSnapshot document,
) async {
  int status = 0;
  // FirebaseAuth auth = FirebaseAuth.instance;
  String userUid = document['userUid'];

  var renter = await FirebaseFirestore.instance
      .collection('orders')
      .limit(10)
      .where(
        'userUid',
        isEqualTo: userUid,
      ) // Now all landlords have to save their cards from the get go
      .where(
        'placeID',
        isEqualTo: document['placeID'],
      ) // check for place id mix up
      .where('status', isEqualTo: 'new')
      .get();
  var data = renter.docs.map((s) => s.data());
  var cardData = data.map((d) => Orders.fromJson(d));
  // var _amount = (double.parse('$amount') * 100).round(); // no round up for paypal API
  String amount0 = (double.parse(amount) * 1).toStringAsFixed(2);

  if (renter.docs.isEmpty) {
    MyAlert(context, "No orders found");
    Navigator.pop(context);
    Navigator.pop(context);
    return 0; // procss should stop here
  }

  await refund(cardData.first.captureID, amount0);

  print('This is CaptureID ${cardData.first.captureID}');
  print('this is processed amount $amount0');

  if (transmit) {
    // was 201
    if (context.mounted) {
      status = 201;
      Navigator.pushNamed(context, '/confirmation');
    }
  } else {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Card Data'),
          content: const Text('Invalid financial Data'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransactionScreen(),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      status = 500;
    }
  }

  // Here we will call a paypal post instead with email and the amount and check
  // for a response
  /* http.post(
        Uri.parse('https://api.payarc.net/v1/refunds/wo_reference'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $Access_Token_Payarc',
        },
        body: jsonEncode(<String, String>{
          'title': 'Payout',
          'exp_year': '${_month.last}',
          'exp_month': '${_month.first}',
          'amount': '$_amount',
          'currency': 'usd',
          'statement_description': 'Brb Rental refund',
          'email': '${document['ownerEmail']}',
          'phone_number': '${document['ownerPhone']}',
          'card_number': '$_cardNumber',
          'cvv': '${cardData.first.cvvCode}',
          'card_holder_name': '${document['userFirstName']} ${document['userLastName']}',
          'metadata': '{"FullCustomerName" : "${document['userFirstName']} ${document['userLastName']}"} '
        })
    );  */

  /* if (response.statusCode == 201) {
      if (context.mounted) {
        Navigator.pushNamed(context, '/confirmation');
      }

      //return Album.fromJson(jsonDecode(response.body));
    } */

  /*else {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: const Text('Card Data'),
                content: const Text(
                    'Invalid Card Data'
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              )
      );
      print('This is response ${response.body} and status ${response
          .statusCode}  ');
    }  */

  return status;
}
