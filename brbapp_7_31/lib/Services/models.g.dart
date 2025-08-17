// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Users _$UsersFromJson(Map<String, dynamic> json) => Users(
      uid: json['uid'] as String? ?? '',
      address: json['address'] as String? ?? '',
      placeID: json['placeID'] as String? ?? 'initial place',
      latitude: json['latitude'] as double? ?? 0,
      longtitude: json['longtitude'] as double? ?? 0,
      availability: json['availability'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      firstName: json['firstName'] as String ? ?? '',
      userFirstName: json['userFirstName'] as String ? ?? '',
      userLastName: json['userLastName'] as String ? ?? '',
      ownerPhone: json['ownerPhone'] as String ? ?? '',
      phone: json['phone'] as String ? ?? '',
      rate: json['rate']  as String ? ?? '',
      //rate: json['rate'] as num ? ?? 0,
      startDate: json['startDate'] ,
      endDate: json['endDate']  ,
      userStartDate: json['userStartDate'],
      userEndDate: json['userEndDate'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      dateStart: json['dateStart'],
      dateEnd: json['dateEnd'],
      timeStart: json['timeStart'],
      timeEnd: json['timeEnd'],
      fileName: json['fileName'],
      vehicleMake: json['vehicleMake'],
      vehicleModel: json['vehicleModel'],
      plateNumber: json['plateNumber'],
      email: json['email'],
      Due: json['Due'],
      ownerEmail: json['ownerEmail'],
    landlordHascard: json['landlordHascard'],
    );

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
      'uid': instance.uid,
      'address': instance.address,
      'placeID': instance.placeID,
      'latitude' : instance.latitude,
      'longtitude' : instance.longtitude,
      'availability': instance.availability,
      'lastName': instance.lastName,
      'firstName': instance.firstName,
      'userFirstName': instance.userFirstName,
      'userLastName': instance.userLastName,
      'rate': instance.rate,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'dateStart':instance.dateStart,
      'dateEnd':instance.dateEnd,
      'timeStart':instance.timeStart,
      'timeEnd':instance.timeEnd,
      'fileName':instance.fileName,
      'vehicleMake': instance.vehicleMake,
      'vehicleModel': instance.vehicleModel,
      'plateNumber' : instance.plateNumber,
      'email' : instance.email,
      'ownerEmail': instance.ownerEmail,
      'ownerPhone': instance.ownerPhone,
      'phone' : instance.phone,
      'userEndDate': instance.userEndDate,
      'userStartDate' : instance.userStartDate,
      'Due': instance.Due,
      'landlordHascard': instance.landlordHascard,
    };

Cards _$CardsFromJson(Map<String, dynamic> json) => Cards(
      Number: json['Number'] as String? ?? '',
      cardHolderName: json['cardHolderName'] as String? ?? '',
      cvvCode: json['cvvCode'] as String? ?? '',
      expiryDate: json['expiryDate'] as String? ?? '',
      userUid: json['userUid'] as String? ?? '',
    );


Map<String, dynamic> _$CardsToJson(Cards instance) => <String, dynamic>{
      'Number': instance.Number,
      'cardHolderName': instance.cardHolderName,
      'cvvCode': instance.cvvCode,
      'expiryDate': instance.expiryDate,
      'userUid' : instance.userUid,

    };

Orders _$OrdersFromJson(Map<String, dynamic> json) => Orders(
      captureID: json['captureID'] as String? ?? '',
      placeID:  json['placeID'] as String? ?? '',
      userUid: json['userUid'] as String? ?? '',
      status:  json['status'] as String? ?? '',
      token:   json['token']  as String? ?? '',
);

Map<String, dynamic> _$OrdersToJson(Orders instance) => <String, dynamic> {
      'captureID': instance.captureID,
      'placeID': instance.placeID,
      'userUid': instance.userUid,
      'status' : instance.status,
      'token'   : instance.token,
};

////
       _$PaypalFromJson(Map<String, dynamic> json) => Paypal(
      paypalemail: json['paypalemail'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
     );



Map<String, dynamic> _$PaypalToJson(Paypal instance) => <String, dynamic> {
      'paypalemail': instance.paypalemail,
      'placeID': instance.uid,
};
