import 'package:brbapp/assets/brbGlobals.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../DriveWay/driveway.dart';
import 'models.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.driveways}) : super(key: key);
  final List<Users> driveways;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late GoogleMapController? mapController; //controller for Google map
  final Set<Marker> markers = {};
  //static const LatLng showLocation = LatLng(27.7089427, 85.3086209); //location to show in map
  //showLocation = LatLng(widget.driveways.first.latitude, widget.driveways.first.longtitude); //location to show in map
  late Users drivewayUser;

  @override
  Widget build(BuildContext context) {
    LatLng showLocation = LatLng(
      widget.driveways.first.latitude,
      widget.driveways.first.longtitude,
    ); //location to show in map
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffff9900),
        leading: InkWell(
          onTap: () {
            // Navigator.pushNamed(context,'/transaction');
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.black54),
        ),
        title: const Text('Available Parking Locations'),
      ),
      body: GoogleMap(
        //Map widget from google_maps_flutter package
        zoomGesturesEnabled: true, //enable Zoom in, out on map
        initialCameraPosition: CameraPosition(
          //innital position in map
          target: showLocation, //initial position
          zoom: 12.0, //initial zoom level was 15
        ),
        markers: getmarkers(), //markers to show on mapflu
        mapType: MapType.normal, //map type
        onMapCreated: (controller) {
          //method called when map is created
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }

  Set<Marker> getmarkers() {
    //markers to place on map
    final mover = widget.driveways.iterator;
    mover.moveNext();
    // driveway was here
    setState(() {
      drivewayUser = mover.current;
      var showLocation = LatLng(
        widget.driveways.first.latitude,
        widget.driveways.first.longtitude,
      ); // why 2 declarations??
      markers.add(
        Marker(
          //add first marker
          markerId: MarkerId(showLocation.toString()),
          position: showLocation, //position of marker
          infoWindow: InfoWindow(
            //popup info
            title: drivewayUser.address, //mover.current.address,
            snippet: 'CLICK TO SELECT',
            //style: TextStyle(color: Colors.blue),
            onTap: () {
              //print('first address ${drivewayUser.address}');
              brbuser.placeID = drivewayUser.placeID;
              brbuser.availability = 'false';
              //Navigator.pushNamed(context, '/driveway');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DriveWay(drivewayUsers: drivewayUser),
                ),
              );
            }, // on tap
          ),
          icon: BitmapDescriptor.defaultMarker, //Icon for Marker
        ),
      );

      while (mover.moveNext()) {
        //GlobalState().drivewayUser= mover.current;
        final dUser = mover.current;
        //setState ( ( ){ drivewayUsers = dUser;});
        markers.add(
          Marker(
            //add second marker
            markerId: MarkerId(mover.current.latitude.toString()),
            position: LatLng(
              mover.current.latitude,
              mover.current.longtitude,
            ), //position of marker
            infoWindow: InfoWindow(
              //popup info
              title: dUser.address, //mover.current.address,
              snippet: 'CLICK TO SELECT',
              onTap: () {
                //GlobalState().drivewayUser = mover.current;
                brbuser.placeID = dUser.placeID;
                brbuser.availability = 'false';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DriveWay(drivewayUsers: dUser),
                  ),
                );
              },
            ),
            icon: BitmapDescriptor.defaultMarker, //Icon for Marker
          ),
        );
        //add more markers here
      } // end while
    });

    return markers;
  }

  //select()
  // {Navigator.pushNamed(context, '/driveway');}
}
