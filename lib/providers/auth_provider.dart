// ignore_for_file: use_build_context_synchronously

import 'dart:developer' as dev;
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:revee/models/user.dart';

import 'package:revee/providers/feedback_provider.dart';

enum AuthStatus {
  LOGGED_OUT,
  VERIFYING_CODE,
  LOGGED_IN,
}

const iOSClientId =
    "685449083250-6bm78afiin3ubpeij8nm9et0eplhmiss.apps.googleusercontent.com";
const androidClientId =
    "685449083250-9rokh7tfsb1lb602tlgkt0m2eu1mrt0s.apps.googleusercontent.com";
const List<String> _scopes = ['email', CalendarApi.calendarEventsScope];

class AuthProvider with ChangeNotifier {
  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: Platform.isIOS ? iOSClientId : androidClientId,
    scopes: _scopes,
  );

  final clientCredentials =
      ClientId(Platform.isIOS ? iOSClientId : androidClientId, "");

  GoogleSignInAccount? _user;
  GoogleSignInAuthentication? _authentication;

  ReveeUser? user;
  List<String> _allowedDivisions = [];

  List<String> get allowedDivisions => [..._allowedDivisions];

  AuthProvider({FeedbackProvider? feedback}) {
    if (_feedback != null) _feedback = feedback;
  }

  void update(FeedbackProvider _feedback) {
    this._feedback = _feedback;
    notifyListeners();
  }

  FeedbackProvider? _feedback;

  String? _accessToken = "";
  String _verificationToken = "";
  String _phoneNumber = "";
  String _sessionInfo = "";

  AuthStatus _authStatus = AuthStatus.LOGGED_OUT;

  AuthStatus get authStatus => _authStatus;
  String? get accessToken => _accessToken;
  String get phoneNumber => _phoneNumber;

  Future<bool> tryAutoLogin() async {
    try {
      const storage = FlutterSecureStorage();

      final token = await storage.read(key: "accessToken");

      if (token != null) {
        _accessToken = token;
        return isUserAuthorized();
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isUserAuthorized() async {
    if (_accessToken == null || _accessToken == "") return false;

    final tokenValidationEndpoint =
        """https://umqsibuzzz.us-east-2.awsapprunner.com/revee/api/members/me?filter={"include":["allowedDivisions"]}&access_token=$_accessToken""";

    final response = await http.get(
      Uri.parse(tokenValidationEndpoint),
      headers: {
        "platform-identifier": "app",
      },
    );

    final body = json.decode(response.body);

    if (body["error"] != null) {
      return false;
    }

    user = ReveeUser.fromJson(body as Map<String, dynamic>);
    final fetchedAllowedDivisions = body["allowedDivisions"] as List<dynamic>;

    _allowedDivisions = [];

    for (final divisionData in fetchedAllowedDivisions) {
      final provinceShortName =
          (divisionData as Map<String, dynamic>)["division"];
      if (provinceShortName != null) {
        _allowedDivisions.add(provinceShortName as String);
      }
    }

    return true;
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    String? googleJWT;
    String? email;

    // Logging in with Google and retrieving email and JWT
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }
      _user = await _googleSignIn.signIn();
      _authentication = await _user?.authentication;
      googleJWT = _authentication?.idToken;
      email = _user?.email;
    } catch (error) {
      //dev.log(error.toString());
      _feedback?.showFailFeedback(
        context,
        "C'è stato un problema durante l'accesso con Google",
      );
    }

    // Sending email and JWT to loopback
    // Loopback will check if this email is allowed to use the app
    // If the user is allowed, he will be asked for 6-digit code
    print(googleJWT);
    if (googleJWT != null && email != null) {
      http.Response loopbackResponse;
      try {
        loopbackResponse = await http.post(
          Uri.parse(
              "https://umqsibuzzz.us-east-2.awsapprunner.com/revee/login"),
          headers: {
            "platform-identifier": "app",
          },
          body: {
            "googleJwt": googleJWT,
          },
        );
      } catch (error) {
        dev.log(error.toString());
        _feedback?.showFailFeedback(
          context,
          "Non è stato possibile contattare il server, ti invitiamo a riprovare più tardi",
        );
        return;
      }

      final loopbackBody = json.decode(loopbackResponse.body);
      final statusCode = loopbackBody["statusCode"];

      final idToken = loopbackBody["identificationToken"];
      final userPhone = loopbackBody["phoneNumber"];

      if ((statusCode != 200 && statusCode != null) ||
          userPhone == null ||
          idToken == null) {
        dev.log(loopbackBody["message"] as String);

        switch (statusCode) {
          case 400:
            _feedback?.showFailFeedback(
              context,
              "Si è verificato un errore durante la richiesta",
            );
            break;
          case 401:
            _feedback?.showFailFeedback(
              context,
              "Il tuo account non è autorizzato ad accedere all'applicazione",
            );
            break;
          case 500:
            _feedback?.showFailFeedback(
              context,
              "Il server ha riscontrato un errore durante la richiesta",
            );
            break;
          default:
            _feedback?.showFailFeedback(
              context,
              "Errore $statusCode",
            );
            break;
        }

        await _googleSignIn.signOut();
      }

      _phoneNumber = userPhone as String;
      _verificationToken = idToken as String;

      if (_phoneNumber == "") {
        _feedback?.showFailFeedback(
          context,
          "Al tuo account non è stato associato un numero di telefono. Per poter utilizzare l'applicazione devi prima contattare l'amministratore.",
        );
        return;
      }

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          final errCode = e.code;

          switch (errCode) {
            case 'invalid-phone-number':
              _feedback?.showFailFeedback(
                context,
                "Il numero di telefono associato al tuo account non è del formato corretto. Contattare l'amministratore per correggere il formato.",
              );
              break;
            default:
              _feedback?.showFailFeedback(
                context,
                e.message ?? "Errore Firebase sconosciuto: $errCode",
              );
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          _sessionInfo = verificationId;
          _authStatus = AuthStatus.VERIFYING_CODE;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );

      notifyListeners();
    }
  }

  Future<bool> verifyCode(String code) async {
    final loopbackResponse = await http.post(
      Uri.parse(
          "https://umqsibuzzz.us-east-2.awsapprunner.com/revee/api/OTPs/verify"),
      headers: {
        "platform-identifier": "app",
      },
      body: {
        "sessionInfo": _sessionInfo,
        "otp": code,
        "identificationToken": _verificationToken,
      },
    );

    final loopbackBody = json.decode(loopbackResponse.body);
    final statusCode = loopbackBody["statusCode"];

    if (statusCode != 200 && statusCode != null) {
      dev.log(jsonDecode(loopbackBody["message"] as String).toString());
      return false;
    }

    _accessToken = loopbackBody["data"]["token"]["id"] as String;

    const secureStorage = FlutterSecureStorage();

    await secureStorage.write(
      key: "accessToken",
      value: _accessToken,
    );

    _authStatus = AuthStatus.LOGGED_IN;
    notifyListeners();

    return true;
  }

  Future<bool> createCalendarEvent({
    String? title,
    String? description,
    String? location,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    _user = _googleSignIn.currentUser ?? await _googleSignIn.signInSilently();

    if (_user == null) {
      dev.log("Problema con utente Google");
      return false;
    }

    final headers = await _user!.authHeaders;

    const calendarId = "primary";

    final EventDateTime start = EventDateTime(
      dateTime: startDate,
      timeZone: "Europe/Rome",
    );

    final EventDateTime end = EventDateTime(
      dateTime: endDate,
      timeZone: "Europe/Rome",
    );

    final event = Event(
      start: start,
      end: end,
      summary: title,
      description: description,
      location: location,
      reminders: EventReminders(
        useDefault: false,
        overrides: [
          EventReminder(
            method: "popup",
            minutes: 180,
          ),
        ],
      ),
    );

    final response = await http.post(
      Uri.parse(
        "https://www.googleapis.com/calendar/v3/calendars/$calendarId/events",
      ),
      headers: headers,
      body: jsonEncode(event.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();

    const storage = FlutterSecureStorage();
    await storage.delete(key: "accessToken");

    _accessToken = "";
    _authStatus = AuthStatus.LOGGED_OUT;
    notifyListeners();
  }
}
