import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:updater/utils/constants.dart';
import '../assets/brbGlobals.dart';


Null token_var;


refund(final captureID,final amount)

 async {
   final TOKEN = await GetToken();
   final response = await

   http.post(
       Uri.parse(
           'https://$env/v2/payments/captures/$captureID/refund'),
       headers: <String, String>{
         'Authorization': 'Bearer $TOKEN',
         "Content-Type": 'application/json',
       },
       body: jsonEncode({
         "amount": { "value": "$amount", "currency_code": "USD"},
         "invoice_id": "INVOICE-$captureID",
         "note_to_payer": "Defective product"
       })
   );
   print("This is TOKEN $TOKEN");
   print("This is response >> ${response.body}");
   // Check results update transmit
   if (response.statusCode == 201) // was 201
       {
     transmit = true;

     final snapshot = await FirebaseFirestore.instance
         .collection('orders')
         .limit(10)
         .where('captureID', isEqualTo: captureID)
         .get();
     snapshot.docs.first.reference.update
       (
         {'status': 'refunded'
         }
     );
   }
   else {
     transmit = false;
   }
 }

Future<String> GetToken()

 async {

  // Combine username and password and encode to base64
  const credentials = '$username:$password';
  final encodedCredentials = base64Encode(utf8.encode(credentials));
      final tokenResponse = await
      http.post(
        Uri.parse('https://$env/v1/oauth2/token'),
        headers: <String, String>{
         'Authorization': 'Basic $encodedCredentials',
          "Content-Type":"application/x-www-form-urlencoded",
          },
     body: {
             "grant_type":"client_credentials",
            }
      );
    String resp = tokenResponse.body;
    Map<String, dynamic> orderInfo = jsonDecode(resp);
    String token = orderInfo['access_token'];
    return Future.value(token);
}

CreateOrder(var TOKEN,var card)
 async {
  // Dart version
  final response = await
 http.post(
      Uri.parse('https://$env/v2/checkout/orders'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'PayPal-Request-Id': '7b92603e-77ed-4896-8e78-5dea2050476a',
        'Authorization': 'Bearer $TOKEN'  // expired

      },
      body: jsonEncode({
        "intent": "CAPTURE",
        "purchase_units": [
              {
              "reference_id": "d9f80740-38f0-11e8-b467-0ed5f89f718b",
              "amount": {
              "currency_code": "USD",
              "value": "100.00"
              }
              }
              ],
              "payment_source"
                 "card" : "$card"

                  } )

        );
  String resp = response.body;
  Map<String, dynamic> orderInfo = jsonDecode(resp);
  var id = orderInfo['id'];
  print("This is Create order response >> ${response.body}");
  return Future.value(id);

}

Confirm(var TOKEN,var orderID,var card)

   async{
     final response = await
     http.get(
         Uri.parse('https://$env/checkoutnow?token=$orderID'),
         headers: <String, String>{
         'Content-Type': 'application/json',
         'Authorization': 'Bearer $TOKEN'
         },
         /*body: jsonEncode(
             {
               "payment_source" :
                   {"card": "$card"}

             }
             )*/
     );

     print("This is confirm >> ${response.body}");

  }

  Authorize(var card,var TOKEN,var orderId)
  async {
    final response = await
    http.post(
        Uri.parse('https://$env/v2/checkout/orders/$orderId/authorize'),
     headers: <String, String>{
        'Content-Type': 'application/json',
          //"Content-Type":"application/x-www-form-urlencoded",
          'PayPal-Request-Id': '7b92603e-77ed-4896-8e78-5dea2050476a',
        'Authorization': 'Bearer $TOKEN'  // expired
        },
        body: jsonEncode(
            {
              "payment_source"
                  "card" : "$card"
            } )
    );
    String resp = response.body;
    //Map<String, dynamic> orderInfo = jsonDecode(resp);
   // var id = orderInfo['id'];
    print("This is Authorize >> ${response.body}");
    //return Future.value(id);

  }


CreateCard()
async {

var card =[      // Not working
        {"name" : "TestCard"},
        {"number": "4032031318560611"},
        {"expiry": "12-2026"},
        {"security_code": "493"},
        {"billing_address":
        [
          {"address_line_1": "21 Lebkamp ave"},
          {"address_line_2": "Huntington NY "},
          {"postal_code": "11743"},
          {"country_code": "US"}
        ]
        }
      ];
//final order_id = await CreateOrder(TOKEN,card);
//await Confirm(TOKEN,order_id,card);
//Authorize(card,TOKEN,order_id);

}


paypalPayment(var TOKEN, double amount,String paypalEmail)
async {
  // Dart version
  const ran = getRandomString;
  final response = await

  http.post(
      Uri.parse('https://$env/v1/payments/payouts'),
      headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $TOKEN'  // expired

      },
      body: jsonEncode(

          {
            "sender_batch_header": {
              "sender_batch_id": "Payouts_ $ran $TOKEN",
              "email_subject": "You have a payout!",
              "email_message": "You have received a payout! Thanks for using our service!"
            },
            "items": [
              {
                "recipient_type": "EMAIL",
                "amount": {
                  "value": amount,
                  "currency": "USD"
                },
                "note": "Thanks for your patronage!",
                "sender_item_id": "201403140001",
                "receiver": paypalEmail,
                "alternate_notification_method": {
                  "phone": {
                    "country_code": "91",
                    "national_number": "9999988888"
                  }
                },
                "notification_language": "fr-FR"
              }
            ]
          }
      )

  );

 // var resp = response.statusCode;
  //Map<String, dynamic> orderInfo = jsonDecode(resp);
  // var id = orderInfo['id'];
  print("This is Payment Info >> ${response.body} $paypalEmail");

 return response.statusCode;
}
