import 'package:flutter/material.dart';

enum ViewState { idle, loading, success, error }

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  String? _errorMessage;

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == ViewState.loading;
  bool get isError => _state == ViewState.error;
  bool get isSuccess => _state == ViewState.success;

  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    _state = ViewState.error;
    notifyListeners();
  }

  void resetState() {
    _state = ViewState.idle;
    _errorMessage = null;
    notifyListeners();
  }
}
