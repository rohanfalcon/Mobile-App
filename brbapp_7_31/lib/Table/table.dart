import 'dart:core';
import 'package:brbapp/assets/brbGlobals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Flutter code sample for [DataTable].

class Table extends StatefulWidget {
  const Table({super.key});

  @override
  State<Table> createState() => _TableState();
}

class _TableState extends State<Table> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Listing'),
        backgroundColor: const Color(0xffff9900),
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/transaction');
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.black54),
        ),
      ),
      body: _buildBody(context),
    );
  }
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: createStream(),
    builder: (context, AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
        return const Center(child: Text('You have no Guests'));
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 400,
          child: DataTable(
            columnSpacing: 17,
            columns: const [
              DataColumn(label: Expanded(child: Text('Address'))),
              DataColumn(label: Text('First')),
              DataColumn(label: Text('Last')),
              DataColumn(label: Text('Checkout')),
            ],
            rows: snapshot.data.docs.map<DataRow>((DocumentSnapshot document) {
              return DataRow(
                cells: [
                  DataCell(Text(document['address'], maxLines: 2)),
                  DataCell(Text(document['userFirstName'])),
                  DataCell(Text(document['userLastName'])),
                  DataCell(
                    // PUT BUTTON
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: () {
                        //document.reference.update({'availability': 'true'}); // then do cash transaction.
                        docPath = document.reference.path;
                        document.reference.update({'docpath': docPath});
                        Navigator.pushNamed(context, '/checkout');
                      },
                      child: const Text("Click"),
                    ), // BUTTON
                    onTap: () {
                      // We are not using the cell Gestures.
                    },
                  ),
                  //DataCell(Text(document['firstName'])),
                ],
              );
            }).toList(), // dont call to list build it with mapping
          ),
        ),
      );
    },
  );
}

Stream<QuerySnapshot<Object?>>
createStream() // Checking should be done in a separate function not streamed.
{
  String uid = FirebaseAuth.instance.currentUser!.uid;
  var data = FirebaseFirestore.instance
      .collection('Users')
      .limit(10)
      .where('uid', isEqualTo: uid)
      //.where('placeID', isEqualTo: 'Eh4xNSBDZWRhciBSb2FkLCBJbndvb2QsIE5ZLCBVU0EiMBIuChQKEgk9PXHWCGbCiREFJYRTFqQQmhAPKhQKEgkvIGdICWbCiRFt7ImctQ7Ybw')
      .where('availability', isEqualTo: 'false')
      .get();
  return data.asStream();
}
