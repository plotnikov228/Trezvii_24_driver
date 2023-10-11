import 'package:flutter/material.dart';

abstract class BalanceEvent {}

class InitBalanceEvent extends BalanceEvent {

}

class WithdrawalOfFundsBalanceEvent extends BalanceEvent {

}

class SaveCardBalanceEvent extends BalanceEvent {
  final String card;
  final BuildContext context;

  SaveCardBalanceEvent(this.card, this.context);
}