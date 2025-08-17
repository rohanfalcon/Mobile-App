import 'package:flutter/material.dart';
import 'package:brbapp/services/Auth.dart';
import 'package:brbapp/User/user.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import '../assets/brbGlobals.dart';
import 'address.dart';

class DriveWayInfo extends StatefulWidget {
  const DriveWayInfo({Key? key}) : super(key: key);

  @override
  DriveWayInfoState createState() => DriveWayInfoState();
}

class DriveWayInfoState extends State {
  final _formKey = GlobalKey<FormState>(); // added list of formstate
  final TextEditingController _textEditingController = TextEditingController();
  final _user = BrbUser();
  late String? owner;
  late String? confirm;
  bool dateCheck = false;

  @override
  Widget build(BuildContext context) {
    double doubleVar;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text(
          'Driveway Information',
          style: TextStyle(color: Colors.white),
        ),
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
                // Flexible(
                //flex: 1,
                /* child: */ TextFormField(
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.orange,
                    ),
                    //************************ Color change
                    // border: const OutlineInputBorder(),
                    labelStyle: WidgetStateTextStyle.resolveWith((
                      Set<WidgetState> states,
                    ) {
                      final Color color =
                          states.contains(WidgetState.selected)
                          ? Colors.orange
                          : Colors.orange;
                      return TextStyle(color: color, letterSpacing: 1.3);
                    }),
                    //*************************************
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: themeColor),
                    ),
                    labelText: 'First name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name.';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() => _user.firstName = val!),
                ),
                // ),
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
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.blueAccent,
                      ),
                    ),
                    labelText: 'Last name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Last name.';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() => _user.lastName = val!),
                ),
                //),
                // Phone
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
                  onSaved: (val) => setState(() => _user.ownerPhone = val!),
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
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: themeColor),
                    ),
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    owner = value;
                    if (value == null || value.isEmpty) {
                      // owner = value;
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() => _user.ownerEmail = val!),
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
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: themeColor),
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

                // Flexible(
                /* child: */ TextFormField(
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
                    labelText: 'Hourly Rate (Numeric Please)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Hourly Rate';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() => _user.rate = val!),
                ),
                // ),

                // ****************************************first Row
                Row(
                  children: [
                    Flexible(
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
                                  _user.startDate = date;
                                  _user.dateStart = formattedDate;
                                }, //setState
                              );
                              // Adding startdate check
                            }, // On confirmed
                          ); //(2008, 12, 31, 23, 12, 34));
                        },
                        child: Text(
                          'Select Start Date ${fixDate(_user.startDate)}',
                          style: TextStyle(color: themeColor),
                        ),
                      ),
                    ),

                    // ***************  *****************************************************//
                  ],
                ),

                // This is End Date *******************************************************************************************************//
                Row(
                  children: [
                    Flexible(
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
                                  _user.endDate = date;
                                  _user.dateEnd = formattedDate;
                                }, //setState
                              );
                              // Start comparison
                              if (_user.endDate.isBefore(_user.startDate) ||
                                  (_user.endDate.isBefore(DateTime.now()))) {
                                // ******************************************************
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Time Error'),
                                    content: const Text(
                                      'End Time must be after start time and current Time',
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            _user.endDate = DateTime.now();
                                          });
                                        },
                                      ),
                                    ],
                                    // },
                                  ),
                                );
                                // comparison ends here
                              }
                            },
                          ); //(2008, 12, 31, 23, 12, 34));
                        },
                        child: Text(
                          'Select End Date ${fixDate(_user.endDate)}',
                          style: TextStyle(color: themeColor),
                        ),
                      ),
                    ),
                  ],
                ),

                // camera button
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      themeColor,
                    ),
                  ),
                  onPressed: () {
                    // final form = _formKey.currentState!;
                    Navigator.pushNamed(context, "/imagePicker");
                  },
                  child: const Text(
                    'Upload Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      themeColor,
                    ),
                  ),
                  onPressed: () async {
                    print(
                      'This is email ${_user.ownerEmail} and conf ${_user.emailConfirm}',
                    );

                    if (_user.ownerEmail != _user.emailConfirm) {
                      setState(() {
                        _user.emailConfirm = null;
                      });
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Email Error'),
                          content: const Text(
                            'Confirmation and email not the same',
                          ),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {},
                            ),
                          ],
                          // },
                        ),
                      );
                      //end show dialog
                    }
                    final form = _formKey.currentState!;
                    if (_user.startDate.isAfter(_user.endDate) ||
                        (_user.startDate.isBefore(
                          DateTime.now().subtract(const Duration(seconds: 120)),
                        ))) {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Time Error'),
                          content: const Text(
                            'Start time must be after current time and before end date.',
                          ),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  _user.endDate = DateTime.now();
                                });
                              },
                            ),
                          ],
                          // },
                        ),
                      );
                      dateCheck = false;
                    } else {
                      dateCheck = true;
                    }
                    // ** End check date
                    if (form.validate() && dateCheck) {
                      form.save(); // Saving the form *************************************************
                      _user.fileName = globalFileName;
                      _user.save(_user, "append");
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const AddressScreen(userType: "renter"),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        themeColor,
                      ),
                    ),
                    child: const Text(
                      'sign out',
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
            ), //column
          ),
        ),
      ),
    );
  }
}
