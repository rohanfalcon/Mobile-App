import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class Users{
  String uid;
  String address;
  String placeID;
  double latitude;
  double longtitude;
  String availability;
  String firstName;
  String lastName;
  //String userFirstName;
  //String userLastName;
 // String email;
  String rate;
  String ownerPhone;
  //String phone;
  //double Due;

  final dynamic dateStart;
  final dynamic dateEnd;
  final dynamic  timeStart;
  final dynamic  timeEnd;
  final dynamic  startDate;
  final dynamic  endDate;
  final dynamic  startTime;
  final dynamic  endTime;
  final dynamic  userStartDate;
  final dynamic  userEndDate;
  final dynamic fileName;
  final dynamic vehicleMake;
  final dynamic vehicleModel;
  final dynamic plateNumber;
  final dynamic email;
  final dynamic ownerEmail;
  final dynamic userFirstName;
  final dynamic userLastName;
  final dynamic phone;
  final dynamic Due;
  final dynamic landlordHascard;
  final dynamic userUid;
  //final dynamic rate;
  Users (
      { this.uid ='',
        this.address = '',
        this.placeID='Initialize',
        this.latitude = 0,
        this.longtitude = 0,
        this.availability='',
        this.firstName='',
        this.lastName='',
        this.startDate,
        this.userFirstName='',
        this.userLastName='',
        this.endDate,
        this.startTime,
        this.endTime,
        this.userEndDate,
        this.userStartDate,
        this.timeStart,
        this.timeEnd,
        this.dateStart,
        this.dateEnd,
        this.fileName='',
        this.vehicleMake='',
        this.vehicleModel='',
        this.plateNumber='',
        this.email='',
        this.ownerEmail='',
        this.ownerPhone='',
        this.phone='',
        this.Due,
        this.userUid,
        this.landlordHascard,
        required this.rate,
      });
  factory Users.fromJson(Map<String,dynamic> json) =>_$UsersFromJson(json);
  Map<String, dynamic> toJson() => _$UsersToJson(this);
}


// this is like the report
@JsonSerializable()
class Cards {
  // This could be search or Post Driveway
  String Number;
  String cardHolderName;
  String cvvCode;
  String expiryDate;
  String userUid;

  Cards(
      {
  required this.Number,
  required this.cardHolderName,
  required this.cvvCode,
  required this.expiryDate,
  required this.userUid,
  });
  factory Cards.fromJson(Map<String, dynamic> json) => _$CardsFromJson(json);
  Map<String, dynamic> toJson() => _$CardsToJson(this);


}

@JsonSerializable()
class Orders {
  String captureID;
  String placeID;
  String userUid;
  String token;
  String status;
  Orders ({
    required this.captureID,
    required this.placeID,
    required this.userUid,
    required this.status,
    required this.token

    }  );
  factory Orders.fromJson(Map<String, dynamic> json) => _$OrdersFromJson(json);
   Map<String, dynamic> toJson() => _$OrdersToJson(this);

}


@JsonSerializable()
class Paypal {
  String paypalemail;
  String uid;

  Paypal ({
    required this.paypalemail,
    required this.uid,
  }  );

  factory Paypal.fromJson(Map<String, dynamic> json) => _$PaypalFromJson(json);
  Map<String, dynamic> toJson() => _$PaypalToJson(this);

}




