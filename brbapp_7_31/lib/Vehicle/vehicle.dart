// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brbapp/services/Auth.dart';
import 'package:flutter/services.dart';
import '../assets/brbGlobals.dart';

class VehicleInfo extends StatefulWidget {
  //  final dynamic user; //drivewayUsers;

  const VehicleInfo({Key? key}) : super(key: key);
  //const VehicleInfo({ Key? key,required this.user}) : super(key: key);

  @override
  _VehicleInfoState createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State {
  final _formKey = GlobalKey<FormState>(); // added list of formstate
  final TextEditingController _textEditingController = TextEditingController();
  final _user = brbuser; //BrbUser();
  String? owner;
  String? confirm;
  bool _isButtonEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffff9900),
        leading: InkWell(
          onTap: () {
            //Navigator.pushNamed(context, '/transaction');
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.black54),
        ),
        title: const Text('Vehicle Information'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Builder(
          builder: (context) => Form(
            key: _formKey,
            child: ListView(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          floatingLabelStyle: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.orange,
                          ),
                          constraints: BoxConstraints.loose(
                            const Size(160, 80),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.orange,
                            ),
                          ),
                          labelText: 'Owner First Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Owner First Name';
                          }
                          return null;
                        },
                        onSaved: (val) =>
                            setState(() => _user.userFirstName = val!),
                      ),
                      const Spacer(flex: 1),

                      TextFormField(
                        decoration: InputDecoration(
                          floatingLabelStyle: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.orange,
                          ),
                          labelStyle: WidgetStateTextStyle.resolveWith((
                            Set<WidgetState> states,
                          ) {
                            final Color color =
                                states.contains(WidgetState.error)
                                ? Theme.of(context).colorScheme.error
                                : Colors.orange;
                            return TextStyle(color: color, letterSpacing: 1.3);
                          }),
                          //*************************************
                          constraints: BoxConstraints.loose(
                            const Size(160, 80),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.orange,
                            ),
                          ),
                          labelText: 'Owner Last Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Owner Last Name';
                          }
                          return null;
                        },
                        onSaved: (val) =>
                            setState(() => _user.userLastName = val!),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                  ],
                  // Only numbers can be entered
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.orange,
                    ),
                    labelStyle: WidgetStateTextStyle.resolveWith((
                      Set<WidgetState> states,
                    ) {
                      final Color color = states.contains(WidgetState.error)
                          ? Theme.of(context).colorScheme.error
                          : Colors.orange;
                      return TextStyle(color: color, letterSpacing: 1.3);
                    }),
                    //*************************************
                    labelText: 'Phone Number (Numeric Please)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone Number';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() => _user.phone = val!),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.orange,
                    ),
                    labelStyle: WidgetStateTextStyle.resolveWith((
                      Set<WidgetState> states,
                    ) {
                      final Color color = states.contains(WidgetState.error)
                          ? Theme.of(context).colorScheme.error
                          : Colors.orange;
                      return TextStyle(color: color, letterSpacing: 1.3);
                    }),
                    //*************************************
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.orange),
                    ),
                    labelText: 'Vehicle Make',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter vehicle make';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() => _user.vehicleMake = val!),
                ),

                TextFormField(
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.orange,
                    ),
                    labelStyle: WidgetStateTextStyle.resolveWith((
                      Set<WidgetState> states,
                    ) {
                      final Color color = states.contains(WidgetState.error)
                          ? Theme.of(context).colorScheme.error
                          : Colors.orange;
                      return TextStyle(color: color, letterSpacing: 1.3);
                    }),
                    //*************************************
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.orange),
                    ),
                    labelText: 'Model',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Model';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() => _user.vehicleModel = val!),
                ),
                //),

                //Flexible(
                /*child: */ TextFormField(
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.orange,
                    ),
                    labelStyle: WidgetStateTextStyle.resolveWith((
                      Set<WidgetState> states,
                    ) {
                      final Color color = states.contains(WidgetState.error)
                          ? Theme.of(context).colorScheme.error
                          : Colors.orange;
                      return TextStyle(color: color, letterSpacing: 1.3);
                    }),
                    //*************************************
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.orange),
                    ),
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    owner = value;
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() => _user.email = val!),
                ),

                TextFormField(
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.orange,
                    ),
                    labelStyle: WidgetStateTextStyle.resolveWith((
                      Set<WidgetState> states,
                    ) {
                      final Color color = states.contains(WidgetState.error)
                          ? Theme.of(context).colorScheme.error
                          : Colors.orange;
                      return TextStyle(color: color, letterSpacing: 1.3);
                    }),
                    //*************************************
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.orange),
                    ),
                    labelText: 'Confirm Email',
                  ),
                  validator: (value) {
                    confirm = value;
                    if (value == null || value.isEmpty || (owner != confirm)) {
                      // print('this is email confirm $owner conf $confirm');
                      return 'Please confirm email address';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() => _user.emailConfirm = val!),
                ),
                //),

                // Flexible(
                /* child: */ TextFormField(
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.orange,
                    ),
                    labelStyle: WidgetStateTextStyle.resolveWith((
                      Set<WidgetState> states,
                    ) {
                      final Color color = states.contains(WidgetState.error)
                          ? Theme.of(context).colorScheme.error
                          : Colors.orange;
                      return TextStyle(color: color, letterSpacing: 1.3);
                    }),
                    //*************************************
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.orange),
                    ),
                    labelText: 'License Plate #',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'License Plate #';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() => _user.plateNumber = val!),
                ),
                // ),
                ElevatedButton(
                  //style: ElevatedButton.styleFrom(
                  //minimumSize: const Size(100, 50)
                  onPressed: () async {
                    _isButtonEnabled ? _onButtonPressed : null;
                    final form = _formKey.currentState!;
                    if (form.validate()) {
                      showLoaderDialog(context);
                      form.save(); // Saving the form *************************************************
                      //_user.fileName=globalFileName;
                      _user.placeID = brbuser.placeID;
                      _user.ownerEmail = brbuser.ownerEmail;
                      // _user.userStartDate=brbuser.userStartDate;
                      //_user.userEndDate=brbuser.userEndDate;
                      _user.rate = brbuser.rate;
                      FirebaseAuth auth = FirebaseAuth.instance;
                      String uid = auth.currentUser!.uid.toString();
                      _user.uid = uid;
                      //print('ownder email at vehicledart ${_user.ownerEmail}');
                      // _user.availability= 'true';  // Hard coded back to true 11_16_2023
                      _user.address = brbuser.address;
                      _user.save(
                        _user,
                        "update",
                      ); // Should not save before card run ok
                      brbuser.firstName = _user.userFirstName;
                      brbuser.lastName = _user.userLastName;
                      brbuser.rate =
                          _user.rate; //seems broken after more initialization
                      //Navigator.pushNamed(context, '/confirmation');

                      /*FirebaseAuth Cardauth = FirebaseAuth
                                            .instance;
                                        String uid2 = Cardauth.currentUser!.uid
                                            .toString();
                                        var cardData = await FirebaseFirestore
                                            .instance.collection('Cards')
                                            .limit(10)
                                            .where('userUid',
                                            isEqualTo: uid2) // Now all landlords have to save their cards from the get go
                                            .get();
                                        var _data = cardData.docs.map((s) =>
                                            s.data());
                                        var myCard = _data.map((d) =>
                                            Cards.fromJson(d)); */

                      /* if (myCard.isNotEmpty) {
                                          DocumentSnapshot document = cardData
                                              .docs
                                              .first;
                                          onValidate(document, context);
                                          SnackBar(
                                              content: Text(
                                                  'Using Saved Credit Card',
                                                  style: TextStyle(
                                                      color: Colors.purple))
                                          );
                                        }  */
                      // else {
                      Navigator.pushNamed(context, '/card');
                      // }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    //minimumSize: const Size(100, 50),
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('Save'),
                ),

                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //minimumSize: const Size(100, 50),
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('sign out'),
                    onPressed: () async {
                      await AuthService().signOut();
                      if (context.mounted) {
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/', (route) => false);
                      }
                    },
                  ),
                ),
              ],
            ), //column
          ),
        ),
      ),
    );
  }

  void _onButtonPressed() {
    setState(() {
      // Disable the button when pressed
      _isButtonEnabled = false;
    });
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
}
