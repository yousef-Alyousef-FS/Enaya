import 'package:easy_localization/easy_localization.dart';

abstract class Failure {
  final String message;
  final int? code;

  Failure(this.message, {this.code});
}

class ServerFailure extends Failure {
  ServerFailure(super.message, {super.code});
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure() : super("no_internet_connection".tr());
}
