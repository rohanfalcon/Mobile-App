import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brbapp/User/user.dart';
//import 'package:flutter_credit_card/extension.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import '../CreateOrder/createOrder.dart';
import '../Services/addaddress.dart';
import '../Services/models.dart';
import '../assets/brbGlobals.dart';
//import 'address.dart';

//  This module should just simply call table and handle the calculation on what was selected.

class CheckOut extends StatefulWidget {
  const CheckOut({Key? key}) : super(key: key);

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State {
  final _formKey = GlobalKey<FormState>(); // added list of formstate
  final TextEditingController _textEditingController = TextEditingController();
  final _user = BrbUser();
  bool onTime = false;
  var snapshot;
  late double landlord, balance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffff9900),
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/transaction');
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.black54),
        ),
        title: const Text('Host Checkout'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Was the driveway cleared on time?"),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    showLoaderDialog(context);
                    setState(() {
                      onTime = false;
                    });
                    // Check for early checkout and adjust end time variable
                    // Take the money first before changing availability
                    snapshot = await FirebaseFirestore.instance
                        .collection('Users')
                        .limit(10)
                        .where('docpath', isEqualTo: docPath)
                        .get();
                    doRate(onTime);
                    // snapshot.docs.first.reference.update({'availability': 'true'});
                  },
                  child: const Text("Yes"),
                ),
                // Take us to the checkout confirmation page.
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      onTime = true;
                    });

                    snapshot = await FirebaseFirestore.instance
                        .collection('Users')
                        .limit(10)
                        .where('docpath', isEqualTo: docPath)
                        .get();
                    // snapshot.docs.first.reference.update({'availability': 'true'});
                    // This was left out
                  },
                  child: const Text("No"),
                ),
              ],
            ),

            Row(
              children: [
                Visibility(
                  maintainSize: onTime,
                  maintainAnimation: onTime,
                  maintainState: onTime,
                  visible: onTime,
                  child: TextButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        onChanged: (date) {
                          //print('date with to local ${date.toLocal().toString()}' );
                        },
                        onConfirm: (date) {
                          setState(
                            () {
                              String formattedDate = DateFormat(
                                'EEE, M/d/y-kk:mm',
                              ).format(date);
                              _user.userEndDate = date;
                              _user.dateStart = formattedDate;
                              doRate(onTime);
                              //onTime = false; // Reset
                            }, //setState
                          );
                        },
                      ); //(2008, 12, 31, 23, 12, 34));
                    },
                    child: Text(
                      'Select Checkout date ${fixDate(_user.startDate)}',
                      style: const TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ),
              ],
            ),
            // my visibility
          ], // Container Children
        ),
      ),
    );
  }

  Future<void> doRate(bool timely) async {
    // if ontime only pay the landlord his cut. because this is already paid
    // in full by the user else charge the additional cost and take our cut
    var data = snapshot.docs.map((s) => s.data());
    var guys = data.map((d) => Users.fromJson(d));
    var fee = guys.first.Due * .05; // this was taken earlier
    balance = guys.first.Due - fee;
    print('this is balance $balance');
    landlord =
        (balance -
        (balance *
            .10)); // positive integer in cents fix the other case too for land lord
    double amount = 0;
    Timestamp end2;

    //First get the landlord's card

    /* FirebaseAuth auth = FirebaseAuth.instance;
     String uid = auth.currentUser!.uid.toString();
     var renter = await FirebaseFirestore.instance.collection('Cards')
         .limit(10)
         .where('userUid', isEqualTo:uid)    // Now all landlords have to save their cards from the get go
         .get();
     var data0 = renter.docs.map((s)=> s.data());
     var cardData = data0.map((d) => Cards.fromJson(d));
     //print('this is guys ${cardData.first.cardHolderName}'); // Assuming he has one credit card
     // if not then ask for it. else go to table */

    //***************************************
    /*var _month = cardData.first.expiryDate.split('/');
      var card =   cardData.first.Number.split(' ');
      var _cardNumber= card.join(''); */

    if (!timely) {
      amount = double.parse(landlord.toStringAsFixed(2)); //.round();
      // Take off our service charge
      print('This is due $balance');
      print('landord portion $landlord');
      //Pay landlord
    } else {
      end2 = Timestamp.fromDate(
        _user.userEndDate,
      ); // should be greater than start

      Timestamp end1 = guys.first.userEndDate; // added time conversion
      final DateTime end = DateTime.fromMicrosecondsSinceEpoch(
        end2.microsecondsSinceEpoch,
      );
      final DateTime start = DateTime.fromMicrosecondsSinceEpoch(
        end1.microsecondsSinceEpoch,
      );

      Duration total = end.difference(start); // * rate
      double Shours = double.parse((total.inMinutes / 60).toString());
      double hours = double.parse(Shours.toStringAsFixed(1));
      print('This rate ${guys.first.rate}');
      double Scharge = hours * double.parse(guys.first.rate);
      double charge = double.parse(Scharge.toStringAsFixed(2));
      double cut = (balance + charge) * .10; // 10% cut is ours
      // Dont forget to take our cut.
      // only process the difference between database end date and user entered
      landlord = (balance + charge) - cut; // S charge done in the begining
      amount = double.parse(landlord.toStringAsFixed(2)); //.round();
      //amount = amount * 100;   // some systems takes 100 cents for a dollar
      print('late landlord $amount and charge $charge');
      print('This is our cut $cut');
    }

    var uid = FirebaseAuth.instance.currentUser!.uid;
    // mail the balacne to the landlord
    //Landlord Paid
    var renter = await FirebaseFirestore.instance
        .collection('paypal')
        .limit(10)
        .where(
          'uid',
          isEqualTo: uid,
        ) // Now all landlords have to save their cards from the get go
        .get();

    var data2 = renter.docs.map((s) => s.data());
    var cardData = data2.map((d) => Paypal.fromJson(d));

    var paypalEmail = cardData.first.paypalemail;
    if (cardData.isNotEmpty) {
      final TOKEN = await GetToken();
      print("We have the TOKEN $TOKEN");
      final response = await paypalPayment(TOKEN, amount, paypalEmail);

      /*final response = await
      http.post(
         Uri.parse('https://api.payarc.net/v1/refunds/wo_reference'),
         headers: <String, String>{
           'Accept': 'application/json',
           'Content-Type': 'application/json; charset=UTF-8',
           'Authorization': 'Bearer $Access_Token_Payarc',
         },
         body: jsonEncode(<String, String>{
           'title': 'Payout',
           'exp_year' : '${_month.last}',
           'exp_month' : '${_month.first}',
           'amount' : '$amount',
           'currency' : 'usd',
           'statement_description' : 'Landlord Payment',
           'email' : '${brbuser.ownerEmail}',
           'phone_number' : '${brbuser.ownerPhone}',
           'card_number' : '$_cardNumber',
           'cvv' : '${cardData.first.cvvCode}',
           'card_holder_name' : '${brbuser.firstName} ${brbuser.lastName}',
           'metadata' : '{"FullCustomerName" : "${brbuser.firstName} ${brbuser.lastName}"} '
         })
     ); */

      if (response == 201) {
        if (context.mounted) {
          snapshot.docs.first.reference.update({'availability': 'true'});
          //Landlord should get a payment notice email We should change the order status to close in orders
          // database but get the capture id associated with the current user.
          var customer = await FirebaseFirestore.instance
              .collection('orders')
              .limit(10)
              .where('userUid', isEqualTo: guys.first.userUid)
              .where(
                'status',
                isEqualTo: 'new',
              ) // Now all landlords have to save their cards from the get go
              .get();
          print('This is uid comparison ${guys.first.userUid}');
          //var data2 = customer.docs.map((s)=> s.data());
          //var cardData= data2.map((d) => Paypal.fromJson(d));
          customer.docs.first.reference.update({'status': 'closed'});

          Navigator.pushNamed(context, '/confirmation');
        }

        //return Album.fromJson(jsonDecode(response.body));
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Payment Data'),
              content: const Text(
                'Payment failed. Please re-enter paypal data and start over.',
              ),
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
          //   Re Enter Card
          {
            //
            TextEditingController textFieldController = TextEditingController();
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Paypal Email Address'),
                    content: TextField(
                      controller: textFieldController,
                      decoration: const InputDecoration(
                        hintText: "Please enter",
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Submit'),
                        onPressed: () {
                          final CollectionReference paypalCollection =
                              FirebaseFirestore.instance.collection('paypal');
                          paypalCollection.add({
                            'uid': uid,
                            'paypalemail': textFieldController.text,
                          });

                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                      ),
                      // cancel
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          }
          ///////////////////////////////////////////
        }
        print(
          'This is response ${response.body} and status ${response.statusCode} ',
        );
        return;
      }
    } else {
      if (context.mounted) {
        MyAlert(context, "Paypal email not valid");
      }
    }
  } // do Rate
} // End class
