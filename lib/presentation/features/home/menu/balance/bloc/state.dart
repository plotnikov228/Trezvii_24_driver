import 'package:trezvii_24_driver/presentation/utils/status_enum.dart';

class BalanceState {
  final double balance;
  final Status status;
  final String? message;

  BalanceState({this.balance = 0, this.message, this.status = Status.Success});
}