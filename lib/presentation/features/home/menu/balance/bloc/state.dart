import 'package:trezvii_24_driver/presentation/utils/status_enum.dart';

import '../../../../../../domain/payment/models/card.dart';

class BalanceState {
  final double balance;
  final Status status;
  final String? message;
  final UserCard? card;

  BalanceState( {this.card, this.balance = 0, this.message, this.status = Status.Success});
}