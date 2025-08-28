import 'dart:convert';
import 'package:brbapp/assets/brbGlobals.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

class PayPalAuthService {
  String clientId;
  String clientSecret;
  String redirectUri;
  final bool sandbox;

  PayPalAuthService({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUri,
    this.sandbox = false,
  });

  String get _baseAuthUrl =>
      sandbox ? "https://www.sandbox.paypal.com" : "https://www.paypal.com";

  String get _baseApiUrl =>
      sandbox ? "https://api.sandbox.paypal.com" : "https://api-m.paypal.com";

  /// Step 1: Authenticate the user via PayPal login
  Future<String?> authenticate() async {
    final authUrl = Uri.parse(
      "$_baseAuthUrl/signin/authorize"
      "?response_type=code"
      "&client_id=$clientId"
      "&scope=openid email"
      "&redirect_uri=$redirectUri",
    );

    final result = await FlutterWebAuth2.authenticate(
      url: authUrl.toString(),
      callbackUrlScheme: Uri.parse(redirectUri).scheme,
    );
    final code = Uri.parse(result).queryParameters['code'];
    return code;
  }

  /// Step 2: Exchange authorization code for access token
  Future<String?> getAccessToken(String code) async {
    final credentials = base64Encode(utf8.encode("$clientId:$clientSecret"));

    final response = await http.post(
      Uri.parse("$_baseApiUrl/v1/oauth2/token"),
      headers: {
        "Authorization": "Basic $credentials",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri": redirectUri,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["access_token"];
    } else {
      throw Exception("Failed to get access token: ${response.body}");
    }
  }

  /// Step 3: Fetch user info (including email)
  Future<Map<String, dynamic>> getUserInfo(String accessToken) async {
    final response = await http.get(
      Uri.parse(
        "$_baseApiUrl/v1/identity/openidconnect/userinfo/?schema=openid",
      ),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch user info: ${response.body}");
    }
  }

  /// Complete login flow
  Future<String?> loginAndGetEmail() async {
    final code = await authenticate();
    if (code == null) throw Exception("No authorization code received");

    final accessToken = await getAccessToken(code);
    if (accessToken == null) throw Exception("No access token received");

    final userInfo = await getUserInfo(accessToken);
    userEmail = userInfo["email"];
    SystemNavigator.pop();

    return userInfo["email"];
  }
}
