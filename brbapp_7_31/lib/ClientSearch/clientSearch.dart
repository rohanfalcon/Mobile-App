
import 'package:brbapp/assets/brbGlobals.dart';
import 'package:flutter/material.dart';
import 'package:brbapp/services/Auth.dart';
import 'package:brbapp/User/user.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import '../Address/address.dart';

class ClientSearch extends StatefulWidget {
  const ClientSearch({Key? key}) : super(key: key);

  @override
  State<ClientSearch> createState() => _ClientSearchState();
}

class _ClientSearchState extends State<ClientSearch> {
  final _formKey = GlobalKey<FormState>(); //
  final TextEditingController _textEditingController = TextEditingController();
  final _user = BrbUser();
  bool timeCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            login = true;
            Navigator.pushNamed(context, '/transaction');
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.black54),
        ),
        title: const Text('Driveway Search'),
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
                                  _user.userStartDate = date;
                                  _user.dateStart = formattedDate;
                                }, //setState
                              );
                            },
                          ); //(2008, 12, 31, 23, 12, 34));
                        },
                        child: Text(
                          'Select Start Date ${fixDate(_user.userStartDate)}',
                          style: const TextStyle(color: Colors.blue),
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
                                  _user.userEndDate = date;
                                  _user.dateEnd = formattedDate;
                                }, //setState
                              );
                              // Start comparison
                              if (_user.userEndDate.isBefore(
                                    _user.userStartDate,
                                  ) ||
                                  (_user.userEndDate.isBefore(
                                    DateTime.now(),
                                  ))) {
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
                                            _user.userEndDate = DateTime.now();
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
                          'Select End Date ${fixDate(_user.userEndDate)}',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),

                ElevatedButton(
                  onPressed: () async {
                    final form = _formKey.currentState!;
                    if (_user.userStartDate.isAfter(_user.userEndDate) ||
                        (_user.userStartDate.isBefore(
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
                                timeCheck = false;
                              },
                            ),
                          ],
                          // },
                        ),
                      );
                      print('this is startdate ${_user.userStartDate}');
                    } else {
                      timeCheck = true;
                    }
                    // **** Validation
                    if (form.validate() && timeCheck) {
                      form.save(); // Saving the form *************************************************
                      _user.save(_user, "update");
                      // This was not saving before and it went with defaults.
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const AddressScreen(userType: "client"),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Search'),
                ),

                Center(
                  child: ElevatedButton(
                    child: const Text('sign out'),
                    onPressed: () async {
                      await AuthService().signOut();
                      login = false;
                      guestAccess = false;
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/', (route) => false);
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
