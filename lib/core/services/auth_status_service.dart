import 'package:flutter/material.dart';

enum AuthStatus { authenticated, unauthenticated, initial }

class AuthStatusService extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  String? _sessionExpiredMessage;

  AuthStatus get status => _status;
  String? get sessionExpiredMessage => _sessionExpiredMessage;

  void setAuthenticated() {
    _status = AuthStatus.authenticated;
    _sessionExpiredMessage = null;
    notifyListeners();
  }

  void setUnauthenticated({String? message}) {
    _status = AuthStatus.unauthenticated;
    _sessionExpiredMessage = message;
    notifyListeners();
  }
}
