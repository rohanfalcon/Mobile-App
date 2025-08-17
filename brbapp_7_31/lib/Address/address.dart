import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:uuid/uuid.dart';
//import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:brbapp/Services/getAddress.dart';
import '../Services/markers.dart';
import '../Services/models.dart';
import '../assets/brbGlobals.dart';

const kGoogleApiKey = 'AIzaSyCEsFnhcgkNy4uokoJSFPf1LiDRjHxrTUo';

class AddressScreen extends StatefulWidget {
  //final dynamic userType;
  const AddressScreen({Key? key, required this.userType}) : super(key: key);
  final dynamic userType;

  @override
  AddressScreenState createState() => AddressScreenState();
}

class AddressScreenState extends State<AddressScreen> {
  final Mode _mode = Mode.fullscreen;
  Future<void>? callAsyncFetch() =>
      Future.delayed(const Duration(seconds: 1), () => _handlePressButton());
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(widget.userType);
    }
    return FutureBuilder<void>(
      future: callAsyncFetch(),
      builder: (context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xffff9900),
              leading: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/transaction');
                },
                child: const Icon(Icons.arrow_back_ios, color: Colors.black54),
              ),
              title: const Text('Done'),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<String> _handlePressButton() async {
    void onError(PlacesAutocompleteResponse response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.errorMessage ?? 'Unknown error')),
      );
    }
    // show input autocomplete with selected mode
    // then get the Prediction selected

    final p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      // _mode   I am hard coding this
      language: 'us',
      components: [const Component(Component.country, 'us')],
    ); // show dialog

    if (context.mounted) {
      await displayPrediction(
        p,
        ScaffoldMessenger.of(context),
        context,
        widget.userType,
      );
    }
    return p.toString();
  }
} // End State

//************************ Added

//  ****************** Added Stuff******************************************
Future<Text> displayPrediction(
  Prediction? p,
  ScaffoldMessengerState messengerState,
  BuildContext context,
  String userType,
) async {
  //Context: context;
  if (p == null) {
    return const Text('P is Null', selectionColor: Colors.red);
  }
  final places = GoogleMapsPlaces(
    apiKey: kGoogleApiKey,
    apiHeaders: await const GoogleApiHeaders().getHeaders(),
  );

  final detail = await places.getDetailsByPlaceId(
    p.placeId!,
  ); // api id call for client's location
  final geometry = detail.result.geometry!;
  final place = p.placeId;
  if (userType == 'client') {
    print('building array now');
    List<Users> addresses = (await FirestoreService().getAddress());
    List<Users> driveway = [];
    for (var i in addresses) {
      final lat = geometry.location.lat; // from Searcher
      final lng = geometry.location.lng;
      final lat2 = i.latitude; // should be ones available
      final lon2 = i.longtitude;
      // This shows the selected335
      double calculateDistance(lat1, lon1, lat2, lon2) {
        var p = 0.017453292519943295;
        var a =
            0.5 -
            cos((lat2 - lat1) * p) / 2 +
            cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
        return 12742 * asin(sqrt(a));
      }

      Timestamp eDate = i.endDate;
      Timestamp sDate = i.startDate;
      if ((calculateDistance(lat, lng, lat2, lon2) < 15 &&
              eDate.toDate().isAfter(DateTime.now()) &&
              i.availability == 'true') &&
          ((sDate.toDate().isBefore(brbuser.userStartDate) ||
                  sDate.toDate().isAtSameMomentAs(
                    brbuser.userStartDate,
                  )) && // null means enver used and can be deleated will set to True after used once.
              (eDate.toDate().isAfter(brbuser.userEndDate) ||
                  eDate.toDate().isAtSameMomentAs(
                    brbuser.userEndDate,
                  ))) // And clause 1
          ) {
        //isAfter(DateTime.now())
        // add to markers
        driveway.add(i);
        // I was printing the driveay map here before
      }
      // else was here
    } // end for
    if (driveway.isEmpty) {
      //if (context.mounted)

      // {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Parking not available'),
            content: const Text('Check dates and location'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressScreen(userType: userType),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      //}
    } else {
      // moved showing the map to here
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Home(driveways: driveway),
          ),
        );
      }
      //);
      // end push
      //}
    } // If Empty
    // Get more information from the user before showing the map *************************************************************************************

    return const Text('Client finished');
  } // End If
  //****************************************RENTER SECTION      ******************************************************************************//
  else if (userType == 'renter') {
    final addressInfo =
        brbuser; // Add the data to the database if we are a rentor
    addressInfo.placeID = place;
    addressInfo.address = p.description;
    addressInfo.latitude = geometry.location.lat;
    addressInfo.longtitude = geometry.location.lng;
    addressInfo.save(addressInfo, "new"); // Check the file upload thing
    // MyAlert(context, 'Collection Info ${UserCollection.firestore.app.hashCode.toString()}');
    MyAlert(context, 'UserInfo ${Fireuser.toString()}');
    messengerState.showSnackBar(
      SnackBar(
        content: Text(
          '${p.description} ',
          selectionColor: CupertinoColors.activeGreen,
        ),
      ),
    );

    if (context.mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/confirmation', (route) => true);
    }
  } // End else
  return const Text("None of the above");
}

// custom scaffold that handle search
// basically your widget need to extends [GooglePlacesAutocompleteWidget]
// and your state [GooglePlacesAutocompleteState]
class CustomSearchScaffold extends PlacesAutocompleteWidget {
  final dynamic userType;
  CustomSearchScaffold({Key? key, this.userType})
    : super(
        key: key,
        apiKey: kGoogleApiKey,
        sessionToken: const Uuid().v4(),
        language: 'en',
        components: [const Component(Component.country, 'us')],
      );

  @override
  CustomSearchScaffoldState createState() => CustomSearchScaffoldState();
}

// Holding widget for future

class CustomSearchScaffoldState extends PlacesAutocompleteState {
  String? get userType => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarPlacesAutoCompleteTextField(
          textStyle: null,
          textDecoration: null,
          cursorColor: null,
        ),
      ),
      body: PlacesAutocompleteResult(
        onTap: (p) => {
          displayPrediction(
            p,
            ScaffoldMessenger.of(context),
            context,
            userType!,
          ),
        },
        logo: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [FlutterLogo()],
        ),
      ),
    );
  }

  @override
  void onResponseError(PlacesAutocompleteResponse res) {
    super.onResponseError(res);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res.errorMessage ?? 'Unknown error')),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse res) {
    super.onResponse(res);

    if (res.predictions.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Got answer')));
    }
  }
}
