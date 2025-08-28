import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../assets/brbGlobals.dart';

class PayPalLoginPage extends StatefulWidget {
  const PayPalLoginPage({super.key});

  @override
  State<PayPalLoginPage> createState() => _PayPalLoginPageState();
}

class _PayPalLoginPageState extends State<PayPalLoginPage> {
  final clientId = username;
  final clientSecret = password;
  final redirectUri = "brbapp://auth"; // <-- must match your PayPal settings
  final sandbox = false;

  Future<String?> _showPayPalLoginDialog(BuildContext context) async {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
          "https://www.paypal.com/signin/authorize?" // switch to live later
          "response_type=code"
          "&client_id=$clientId"
          "&redirect_uri=$redirectUri"
          "&scope=openid email",
        ),
      );

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 500,
            child: WebViewWidget(
              controller: controller
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onNavigationRequest: (request) {
                      if (request.url.startsWith(redirectUri)) {
                        final uri = Uri.parse(request.url);
                        final code = uri.queryParameters["code"];
                        Navigator.of(context).pop(code);
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    },
                  ),
                ),
            ),
          ),
        );
      },
    );
  }

  Future<String?> _getPayPalAccessToken(String code) async {
    final baseUrl = sandbox
        ? "https://api-m.sandbox.paypal.com"
        : "https://api-m.paypal.com";

    final auth = base64Encode(utf8.encode("$clientId:$clientSecret"));

    final response = await http.post(
      Uri.parse("$baseUrl/v1/oauth2/token"),
      headers: {
        "Authorization": "Basic $auth",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri": redirectUri,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["access_token"];
    } else {
      debugPrint("❌ Token error: ${response.body}");
      return null;
    }
  }

  Future<Map<String, dynamic>?> _getPayPalUserInfo(String accessToken) async {
    final baseUrl = sandbox
        ? "https://api-m.sandbox.paypal.com"
        : "https://api-m.paypal.com";

    final response = await http.get(
      Uri.parse("$baseUrl/v1/identity/openidconnect/userinfo?schema=openid"),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      debugPrint("❌ User info error: ${response.body}");
      return null;
    }
  }

  Future<void> _handleLogin(BuildContext context) async {
    final code = await _showPayPalLoginDialog(context);
    if (code == null) return;

    final token = await _getPayPalAccessToken(code);
    if (token == null) return;

    final user = await _getPayPalUserInfo(token);
    if (user == null) return;
    userEmail = user["email"];
    if (context.mounted) {
      Navigator.pop(context);
    }
    if (!mounted) return;

    /*Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(email: user["email"] ?? "Unknown"),
      ),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login with PayPal")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handleLogin(context),
          child: const Text("Login with PayPal"),
        ),
      ),
    );
  }
}
