//import 'package:brbapp/About/about.dart';
//import 'package:brbapp/profile/profile.dart';
import 'package:brbapp/Address/driveWayInfo.dart';
import 'package:brbapp/CancelPost/cancelPost.dart';
import 'package:brbapp/Card/card.dart';
import 'package:brbapp/Checkout/checkout.dart';
import 'package:brbapp/ClientSearch/clientSearch.dart';
import 'package:brbapp/Confirmation/confirmation.dart';
import 'package:brbapp/ImageUpload/ImagePicker.dart';
import 'package:brbapp/Paypal/paypal.dart';
import 'package:brbapp/Paypal/paypal_login.dart';
import 'package:brbapp/Table/table.dart';
import 'package:brbapp/Vehicle/vehicle.dart';
import 'package:brbapp/login/login.dart';
import 'package:brbapp/Transaction/Transaction.dart';
import 'package:brbapp/home/home.dart';
import 'package:brbapp/About/about.dart';
import 'package:brbapp/Address/address.dart';
import 'package:brbapp/Services/markers.dart';
import 'Card/landLordCard.dart';
import 'DriveWay/driveway.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/transaction': (context) => const TransactionScreen(),
  '/address': (context) => const AddressScreen(userType: null),
  '/about': (context) => const AboutScreen(),
  '/confirmation': (context) => const ConfirmationScreen(),
  '/markers': (context) => const Home(driveways: []),
  '/driveway': (context) => const DriveWay(drivewayUsers: null),
  '/driveWayInfo': (context) => const DriveWayInfo(),
  '/clientSearch': (context) => const ClientSearch(),
  '/imagePicker': (context) => const MyImagePicker(title: 'Chose Image'),
  '/vehicle': (context) => const VehicleInfo(),
  '/card': (context) => const Card(),
  '/checkout': (context) => const CheckOut(),
  '/table': (context) => const Table(),
  '/cancelPost': (context) => const CancelPost(),
  '/landLordCard': (context) => const landLordCard(),
  '/payment': (context) =>
      const PaypalPaymentDemo(amount: null, myContext: null),
  '/paypalLogin': (context) => const PayPalLoginApp(),
};
