import 'package:brbapp/Services/addaddress.dart';
import '../assets/brbGlobals.dart';

class BrbUser {
  late String uid;
  String? firstName;
  String? lastName;
  String? address;
  String? placeID;
  String? availability = 'true';
  double? latitude;
  double? longtitude;
  DateTime startDate = DateTime.now(); // Initialization
  DateTime endDate = DateTime.now().add(const Duration(hours: 1));
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(const Duration(hours: 1));
  DateTime userEndDate = DateTime.now().add(const Duration(hours: 1));
  DateTime userStartDate = DateTime.now();
  String? dateStart;
  String? dateEnd;
  String? timeStart =
      '${DateTime.now().hour}:${DateTime.now().minute}';
  String? timeEnd =
      '${DateTime.now().hour}:${DateTime.now().minute}';
  String? rate;
  String? ownerPhone;
  String? phone;
  //String?  ready='true';
  String? fileName;
  String? vehicleMake;
  String? vehicleModel;
  String? plateNumber;
  String? email;
  String? ownerEmail;
  double Due = 0;
  String? emailConfirm;
  String? userFirstName;
  String? userLastName;
  String? landlordHascard =
      token; // user and landlord has device token but they get initialized differently

  save(
    BrbUser landlord,
    String mode,
  ) // If we append we have to first pull the old values.
  {
    brbuser = landlord;

    if (mode == "new") {
      addaddress(brbuser);
    }
    if (mode == "update") {
      updateDriveway(landlord);
    }
  }
}
