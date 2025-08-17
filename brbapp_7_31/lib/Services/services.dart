import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class Services extends StatelessWidget {
  const Services({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Services();
  }
}

Future<void> loginWithPayPal(authUrl) async {
  try {
    final result = await FlutterWebAuth.authenticate(
      url: authUrl,
      callbackUrlScheme: 'app', // must match the URI scheme
    );

    // Extract the code from the redirect URL
    final code = Uri.parse(result).queryParameters['code'];
    if (code != null) {
      print('Auth code: $code');
      // Now send this code to your backend to exchange for access token
    }
  } catch (e) {
    print('Login failed: $e');
  }
}
