//import 'dart:ffi';
//import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paypal_login/paypal_login.dart';
import '../Paypal/paypal_login.dart';
import '../Services/Auth.dart';
import '../Services/addaddress.dart';
import '../Services/getAddress.dart';
import '../Services/models.dart';
import '../Services/services.dart';
import '../assets/brbGlobals.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}
//@override
//_TransactionScreenState createState() => _TransactionScreenState();

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    late String userType;
    // TODO: implement build
    //const TransactionScreen();   // Give the Client screen
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        leadingWidth: 18,
        backgroundColor: const Color(0xffff9900),
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/login');
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.black54),
        ),

        title: const Text(
          'Transactions',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ), //Column(mainAxisAlignment: MainAxisAlignment.start,
        //children : [ const Text('Choose a Transaction',style: TextStyle(color: Colors.white,fontSize: 20)),
        actions: [
          //Expanded(child:
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Visibility(
                maintainSize: login,
                maintainAnimation: login,
                maintainState: login,
                visible: login,
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.account_circle),
                  onSelected: (String result) async {
                    switch (result) {
                      case 'filter3':
                        if (await checkCard() == false) {
                          if (context.mounted) {
                            Navigator.pushNamed(context, '/landLordCard');
                          }
                        } else {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Existing Card'),
                                content: const Text(
                                  'Only one card allowed for now',
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                        break;
                      case 'filter1':
                        if (await checkCard()) {
                          // ask them if they are sure
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Confirmation'),
                                content: const Text('A Dat yu wah do?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      deletePaypal(context);
                                      Navigator.pushNamed(
                                        context,
                                        '/confirmation',
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Card Confirmation'),
                                content: const Text('No Paypal info entered'),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                        break;

                      case 'filter2':
                        // ask them if they are sure
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Confirmation'),
                            content: const Text(
                              'All non rented locations will be lost',
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  deleteLocations(context);
                                  Navigator.pushNamed(context, '/confirmation');
                                },
                              ),
                            ],
                          ),
                        );
                        break;
                      case 'clearFilters':
                        break;
                      default:
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        /*const PopupMenuItem<String>(
                           value: 'filter1',
                           child: Text('Add Card'),
                           ), */
                        const PopupMenuItem<String>(
                          value: 'filter1',
                          child: Text('Delete Paypal Info'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'filter2',
                          child: Text('Delete Profile'),
                        ),
                      ],
                ),
              ),

              //  Row(  children: [
              Visibility(
                maintainSize: login,
                maintainAnimation: login,
                maintainState: login,
                visible: login,
                child: Text(
                  fireuserEmail,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                //child: Text(AuthService().authFire, style: const TextStyle(color: Colors.white,fontSize: 12))
              ),
            ],
            // ),

            //  ),
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/shea.jpg"),
            fit: BoxFit.cover, //cover
          ),
        ),
        padding: const EdgeInsets.fromLTRB(100, 5, 60, 0),

        // padding: const EdgeInsets.fromLTRB(120,20,81,50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Image.asset(
                    'lib/assets/brblogo.png',
                    fit: BoxFit.contain,
                    height: 90,
                    width: 100,
                  ),

                  Visibility(
                    maintainSize: !login,
                    maintainAnimation: !login,
                    maintainState: !login,
                    visible: !login,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                      child: ListBox(),
                    ),
                  ),

                  //),

                  // We can have the buttons under the list box in a row too
                  Visibility(
                    maintainSize: login,
                    maintainAnimation: login,
                    maintainState: login,
                    visible: login,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 0,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(180, 50),
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text('Find Parking'),
                        onPressed: () async {
                          userType = 'client';
                          Navigator.pushNamed(context, '/clientSearch');
                        }, // on pressed
                      ),
                    ),
                    //  ]
                    //  ),
                  ),

                  Visibility(
                    maintainSize: guestAccess,
                    maintainAnimation: guestAccess,
                    maintainState: guestAccess,
                    visible: guestAccess,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 0,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(110, 50),
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text('Host Post Parking'),
                        onPressed: () async {
                          // userType = 'renter';
                          Navigator.pushNamed(context, '/driveWayInfo');
                        },
                      ),
                    ),
                  ),

                  Visibility(
                    maintainSize: guestAccess,
                    maintainAnimation: guestAccess,
                    maintainState: guestAccess,
                    visible: guestAccess,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 0,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(110, 50),
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text('Host Cancel Listing'),
                        onPressed: () async {
                          final snapshot = await FirebaseFirestore.instance
                              .collection('paypal')
                              .limit(10)
                              .where(
                                'uid',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid,
                              )
                              .get();

                          if (snapshot.docs.isNotEmpty) {
                            if (context.mounted) {
                              Navigator.pushNamed(context, '/cancelPost');
                            }
                          } // end if
                          else {
                            if (context.mounted) {
                              if (await getEmail(context, Fireuser) == true) {
                                if (context.mounted) {
                                  Navigator.pushNamed(context, '/cancelPost');
                                }
                              }
                            }

                            //////////////////////////////////////////
                          }
                        },
                      ),
                    ),
                  ),

                  //cancel rental
                  Visibility(
                    maintainSize: guestAccess,
                    maintainAnimation: guestAccess,
                    maintainState: guestAccess,
                    visible: guestAccess,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 0,
                      ),

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(110, 50),
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text('Guest Cancel Rent Request'),
                        onPressed: () async {
                          /////
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Cancel Confirmation'),
                              content: const Text(
                                'cancel rental? '
                                'A transaction fee of \$3 will be charged',
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () async {
                                    //showLoaderDialog(context);
                                    /*if (await checkCard()) {
                                      if (context.mounted) {
                                        cancelRental(context);
                                      }
                                    } */ // else {
                                    //if (context.mounted) {
                                    // if (await getEmail(context, Fireuser) ==
                                    // true) {
                                    if (context.mounted) {
                                      cancelRental(context);
                                    }
                                    // }
                                    // }
                                  },
                                  //},
                                ),
                              ],
                            ),
                          );

                          ///////
                        },
                      ),
                    ),
                  ),

                  Visibility(
                    maintainSize: guestAccess,
                    maintainAnimation: guestAccess,
                    maintainState: guestAccess,
                    visible: guestAccess,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 0,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(110, 50),
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text('Host checkout Guest'),
                        onPressed: () async {
                          // Check if landlord card is in database first. hascard would be true then retrieve the card
                          // according to uid
                          String uid = FirebaseAuth.instance.currentUser!.uid;
                          /*var renter = await FirebaseFirestore.instance.collection('Cards')
                                          .limit(10)
                                          .where('userUid', isEqualTo:uid)    // Now all landlords have to save their cards from the get go
                                          .get(); */
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
                            // Remove this edit and just simply as them to login. Take the Url return info and store it.
                            if (context.mounted) {
                              if (await getEmail(context, Fireuser) == true) {
                                if (context.mounted) {
                                  Navigator.pushNamed(context, '/table');
                                }
                              }
                            }
                          } else {
                            print('The paypal data may be available');
                            if (context.mounted) {
                              Navigator.pushNamed(context, '/table');
                            } // '/checkout'
                          }
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    maintainSize: login,
                    maintainAnimation: login,
                    maintainState: login,
                    visible: login,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          Color.fromARGB(200, 114, 101, 252),
                        ),
                      ),
                      child: const Text(
                        'Sign out',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        await AuthService().signOut();
                        login = false;
                        guestAccess = false;
                        if (context.mounted) {
                          Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil('/', (route) => false);
                        }
                      },
                    ),
                  ),
                ],
                //),
                //)
                //  ]
              ),
              //******************************************************************************************
              //]
            ),
          ],
        ),
      ),
    );
    //);
  }
} // class ends

// profileList

class profileListBox extends StatefulWidget {
  const profileListBox({Key? key}) : super(key: key);
  @override
  _MyAppState2 createState() => _MyAppState2();
}

class _MyAppState2 extends State<profileListBox> {
  //late String userType;
  final List<String> items = [
    //'Add/Delete Card'
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: false,
            hint: const Row(
              children: [
                Icon(Icons.list, size: 8, color: Colors.yellow),
                SizedBox(width: 2),
                Expanded(
                  child: Text(
                    'Select Item',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: items
                .map(
                  (String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
            },
          ),
        ),
      ),
    );
  }
}

//***********
class ListBox extends StatefulWidget {
  const ListBox({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ListBox> {
  //late String userType;
  final List<String> items = [
    'Sign in With Google',
    'Sign in different Google user',
    'Continue as Guest',
    'Logout',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        //dropdownWidth:50,
        //selectedItemHighlightColor: const Color(0xffff9900),//Colors.orange,
        //onEnabledColor: const Color(0xFFFFFFFF),//Colors.deepOrangeAccent
        hint: const Text(
          '           Login Options',
          style: TextStyle(fontSize: 15, color: CupertinoColors.white),
        ),

        isExpanded: true,
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 16)),
              ),
            )
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          //setState( () {
          selectedValue = value as String;
          //_selectedColor = Colors.orange;  *************************************
          switch (selectedValue) {
            case 'Sign in With Google':
              {
                AuthService().googleLogin(context);
                login = true;
                guestAccess = true;
                // fireuserEmail = getemail(context);
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/transaction', (route) => true);
                break;
              }

            case 'Sign in different Google user':
              {
                AuthService().newUser(context);
                MyAlert(context, "Please Login again");
                break;
              }

            case 'Continue as Guest':
              {
                login = true;
                guestAccess = false;
                AuthService().anonLogin(context);
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/transaction', (route) => true);
                break;
              }

            case 'Logout':
              {
                AuthService().signOut();
                login = false;
                guestAccess = false;
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
                super.dispose();
                break;
              }
          } // End Switch

          // } // Set State has to go
          //);  // End set State

          // navigate was here
        }, // on changed

        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: 140,

          //itemPadding: const EdgeInsets.fromLTRB(10,10,10,150),
          decoration: BoxDecoration(
            color: Color(0xffff9900),
            //borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
