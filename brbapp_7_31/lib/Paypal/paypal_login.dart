import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

import '../assets/brbGlobals.dart';

void main() {
  runApp(const PayPalLoginApp());
}

class PayPalLoginApp extends StatelessWidget {
  const PayPalLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayPal Login',
      home: Scaffold(
        appBar: AppBar(title: const Text('PayPal Login')),
        body: const Center(child: PayPalLoginButton()),
      ),
    );
  }
}

class PayPalLoginButton extends StatefulWidget {
  const PayPalLoginButton({super.key});

  @override
  State<PayPalLoginButton> createState() => _PayPalLoginButtonState();
}

class _PayPalLoginButtonState extends State<PayPalLoginButton> {
  String? accessToken;

  Future<void> initiatePayPalLogin() async {
    const clientId =
        'AevJ4ZoI7uKpAreL_FnWzJH_5KuOcTrPwTVsa9JAVwyUs-t6EUkYuQjHJpQPuj4swO_9iOPmXZOyJW7A';
    const secret =
        'EDBnNEbMlqShenpSWfBAhPzlG21yDiw4jSnJn0heylM0yrp2oGukASn071Tt220mSgvbskP_P0YJjohs';
    const redirectUri = 'https://www.nativexo/paypalpay';
    const scope = 'openid profile email';

    try {
      // Step 1: Open PayPal login page
      final authUrl = Uri.https('www.paypal.com', '/signin/authorize', {
        'client_id': clientId,
        'response_type': 'code',
        'scope': scope,
        'redirect_uri': redirectUri,
      });

      final result = await FlutterWebAuth2.authenticate(
        url: authUrl.toString(),
        callbackUrlScheme: 'myapp',
      );

      // Step 2: Extract authorization code
      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) throw Exception('No code returned from PayPal');

      // Step 3: Exchange code for token
      final tokenResponse = await http.post(
        Uri.https('api.paypal.com', '/v1/oauth2/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$clientId:$secret'))}',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
        },
      );

      final tokenData = jsonDecode(tokenResponse.body);
      setState(() {
        accessToken = tokenData['access_token'];
      });
    } catch (e) {
      setState(() {
        accessToken = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: initiatePayPalLogin,
          child: const Text('Login with PayPal'),
        ),
        const SizedBox(height: 20),
        Text(accessToken ?? 'Not logged in'),
      ],
    );
  }
}
