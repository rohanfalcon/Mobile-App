import 'package:brbapp/Services/getAddress.dart';
import 'package:brbapp/assets/brbGlobals.dart';
import 'package:flutter/material.dart';

import '../Services/Auth.dart';

class DriveWay extends StatefulWidget {
  const DriveWay({Key? key, required this.drivewayUsers}) : super(key: key);
  final dynamic drivewayUsers;
  @override
  _DriveWayState createState() => _DriveWayState();
}

class _DriveWayState extends State<DriveWay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffff9900),
        leading: InkWell(
          onTap: () {
            // Navigator.pushNamed(context, '/transaction');
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.white54),
        ),
        title: const Text(
          'Driveway Info',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    offset: const Offset(4, 4),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                          fit: FlexFit.loose,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: FadeInImage(
                              height: 5,
                              image: NetworkImage(
                                widget.drivewayUsers.fileName,
                              ),
                              placeholder: const AssetImage(
                                'lib/assets/rainbow.gif',
                              ), // This should be spinning
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white54,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                /*child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, top: 8, bottom: 8), */
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                      "Parking Address",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22,
                                      ),
                                    ),
                                    Row(
                                      // Was row
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            "${widget.drivewayUsers.address}",
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black45.withOpacity(
                                                1,
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 8),
                                      ],
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                        right: 16,
                                        top: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Dates",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Next row
                                    Row(
                                      children: [
                                        Text(
                                          "Start ${fixDate(brbuser.userStartDate)}",
                                          // fixDate(brbuser.startDate),//-${brbuser.startDate.month}-${brbuser.startDate.day} ${brbuser.startDate.hour}: ${brbuser.startDate.minute}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black45.withOpacity(
                                              1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "End   ${fixDate(brbuser.userEndDate)}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black45.withOpacity(
                                              1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              'Driver is responsible for any risk associated \nwith the use of the host\'s driveway',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    //  ***************
                                  ],
                                ),
                                //),
                              ),
                            ],
                          ),
                        ),

                        // adding row
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16, top: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    'Hourly rate \$${widget.drivewayUsers.rate}',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.black45,
                                    ),
                                  ),

                                  /*Text(
                                    '/per Day',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color:
                                        Colors.grey.withOpacity(0.8)),
                                  ),*/
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'Processing Fee 5%',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // button row
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 50),
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Book'),
                              onPressed: () async {
                                if (!await checkBooking()) {
                                  brbuser.address =
                                      widget.drivewayUsers.address;
                                  brbuser.ownerEmail = widget
                                      .drivewayUsers
                                      .ownerEmail; // assignment globl matters here
                                  brbuser.rate = widget.drivewayUsers.rate;
                                  brbuser.ownerPhone =
                                      widget.drivewayUsers.ownerPhone;
                                  setState(() {
                                    // Disable the button when pressed
                                    null;
                                  });
                                  if (context.mounted) {
                                    Navigator.pushNamed(context, '/vehicle');
                                  }
                                } else {
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text(
                                          'Temporary Limitation',
                                        ),
                                        content: const Text(
                                          'Double booking or guest access not allowed',
                                        ),
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
                              },
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            ElevatedButton(
                              child: const Text(
                                'sign out',
                                style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                ),
                              ),
                              onPressed: () async {
                                await AuthService().signOut();
                                login = false;
                                guestAccess = false;
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/',
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                      // adding row
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            /*child: Icon(
                                Icons.favorite_border,
                                color: Colors.orange,
                              ),*/
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  } // widget

  // two functions

  // two functions
}

// get file
