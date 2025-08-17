import 'dart:developer';
//import 'dart:js_interop';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_pay/flutter_paypal_pay.dart';
import '../Services/models.dart';
import '../assets/brbGlobals.dart';

class PaypalPaymentDemo extends StatefulWidget {
  //const PaypalPaymentDemo({super.key, required this.amount});

  const PaypalPaymentDemo({
    Key? key,
    required this.amount,
    required this.myContext,
  }) : super(key: key);
  final dynamic amount;
  final dynamic myContext;

  @override
  PaypalPaymentDemoState createState() => PaypalPaymentDemoState();
}

class PaypalPaymentDemoState extends State<PaypalPaymentDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Card or Paypal Payment"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                try {
                  Navigator.of(widget.myContext).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => PaypalPay(
                        /// sandboxMode true for testing purposes
                        sandboxMode: false,

                        /// you will find the client Id after login to paypal developer account .
                        clientId:
                            // 'ARMCFU9AHMEPcEvJAbTkJAdPeoitl4C5gZfHTK94b5FeVtpmcUqu13BGS_hz3R7Kw2vn962L1V8QzEKN', // Sandbox Default
                            'AevJ4ZoI7uKpAreL_FnWzJH_5KuOcTrPwTVsa9JAVwyUs-t6EUkYuQjHJpQPuj4swO_9iOPmXZOyJW7A', // live
                        ///you will find the secret key after login to paypal developer account .
                        secretKey:
                            // 'EEUmyDHy6F8_04bu6uS0MKb0rhqxxDJab2yTiV8lLg85Z7kT7wKtPd6LrPRJKLMCBuywKTCxCjyIZc6X',  // Sandbox default
                            'EDBnNEbMlqShenpSWfBAhPzlG21yDiw4jSnJn0heylM0yrp2oGukASn071Tt220mSgvbskP_P0YJjohs', // Secret
                        returnURL: 'https://test.com/return',
                        cancelURL: 'https://test.com/cancel',
                        purchaseUnits: [
                          {
                            'amount': {
                              'value': widget
                                  .amount, // MAKE SURE PAYPAL IS NOT GIVING PARTIAL PAYMENTS !!!!
                              'currency_code': 'USD',
                            },
                            // This is a payment to BRB for parking services
                            'shipping': const {
                              'address': {
                                // Add your shipping address details here
                                'recipient_name': 'Brb Parking LLC',
                                'line1': '117-58 142ST Q1',
                                'line2': '',
                                'city': 'Queens',
                                'country_code': 'US',
                                'postal_code': '11436',
                                'phone': '6312232729',
                                'state': 'NY',
                                'admin_area_2':
                                    'City Name', // Replace 'City Name' with the actual city or locality name
                                'admin_area_1':
                                    'New York', // Replace 'State/Province' with the actual state or province name
                              },
                            },
                          },
                        ],
                        note: 'Contact us for any questions on your order.',

                        // We need to save the account id and the capture number for refunds.
                        onSuccess: (Map params) async {
                          // Get the uid and the place id to put in the orders database !!
                          //for view the response
                          String currentUid =
                              FirebaseAuth.instance.currentUser!.uid;
                          final snapshot = await FirebaseFirestore.instance
                              .collection('Users')
                              .limit(10)
                              //.where('userUid', isEqualTo: currentUid)
                              .where('availability', isEqualTo: 'true')
                              .where(
                                'placeID',
                                isEqualTo: brbuser.placeID,
                              ) // initialized to true.
                              .get();

                          var data = snapshot.docs.map((s) => s.data());
                          var userData = data.map((d) => Users.fromJson(d));

                          if (userData.isNotEmpty) {
                            DocumentSnapshot document = snapshot.docs.first;
                            var placeID = document['placeID'];
                            String resp = params['data'].toString();
                            const start = "captures: [{id: ";
                            const end = ",";
                            final startIndex = resp.indexOf(start);
                            final endIndex = resp.indexOf(
                              end,
                              startIndex + start.length,
                            );
                            final CollectionReference ordersCollection =
                                FirebaseFirestore.instance.collection('orders');

                            String captureID = resp.substring(
                              startIndex + start.length,
                              endIndex,
                            );
                            // var payerID= params['payerID'];
                            transmit = true;

                            // Get the user's id and add it with sale id so we can refund him. This really is an append or else the database will need purging
                            // auth.currentUser!.uid.toString();
                            ordersCollection.add({
                              'captureID': captureID,
                              'userUid': currentUid,
                              'placeID': placeID,
                              'status': 'new',
                            });
                          } else {
                            print('Data is empty from query');
                          }
                          Navigator.pop(widget.myContext);
                        },
                        onError: (error) {
                          //for view the response and send something bad
                          // to the charge function.
                          log('onEEEEError: $error');
                          transmit = false;
                        },
                        onCancel: (params) {
                          //for view the response
                          log('cancelled: $params');
                        },
                      ),
                    ),
                  );
                } catch (e, s) {
                  print(s);
                }
              },
              child: const Text('Pay with Paypal'),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  Color.fromARGB(200, 114, 101, 252),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/transaction');
              },
            ),
          ],
        ),
      ),
    );
  }
}
