import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trezvii_24_driver/data/db/repository/repository.dart';
import 'package:trezvii_24_driver/data/firebase/auth/repository.dart';
import 'package:trezvii_24_driver/domain/db/constants.dart';
import 'package:trezvii_24_driver/domain/db/usecases/db_delete.dart';
import 'package:trezvii_24_driver/domain/db/usecases/db_insert.dart';
import 'package:trezvii_24_driver/domain/db/usecases/db_query.dart';
import 'package:trezvii_24_driver/domain/firebase/balance/usecases/create_withdrawal_request.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/balance/bloc/event.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/balance/bloc/state.dart';
import 'package:trezvii_24_driver/presentation/utils/status_enum.dart';
import 'package:trezvii_24_driver/presentation/widgets/app_snack_bar.dart';

import '../../../../../../data/auth/repository/repository.dart';
import '../../../../../../data/firebase/balance/repository.dart';
import '../../../../../../domain/auth/usecases/get_user_id.dart';
import '../../../../../../domain/firebase/balance/usecases/get_balance.dart';
import '../../../../../../domain/firebase/balance/usecases/reset_the_balance.dart';
import '../../../../../../domain/payment/models/card.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {

  double _balance = 0;
  final _fbBalanceRepo = FirebaseBalanceRepositoryImpl();
  final _authRepo = AuthRepositoryImpl();
  final _dbRepo = DBRepositoryImpl();
  UserCard? _card;

  final cardController = TextEditingController();

  bool validateCreditCard(String cardNumber) {
    RegExp pattern = RegExp(r'^\d{4} \d{4} \d{4} \d{4}$'); // Пример формата карты: 1234 5678 9012 3456

    return pattern.hasMatch(cardNumber);
  }

  BalanceBloc(super.initialState) {
    on<InitBalanceEvent>((event, emit) async {
      emit(BalanceState(balance: _balance, status: Status.Loading));

      final cards = (await DBQuery(_dbRepo).call(DBConstants.cardsTable)).map((e) => UserCard.fromJson(e));
      if(cards.isNotEmpty) {
        _card = cards.last;
        cardController.text = _card!.number;
      }
      try {

        _balance = await GetBalance(_fbBalanceRepo).call(await GetUserId(_authRepo).call());
        emit(BalanceState(balance: _balance, card: _card));
      } catch (_) {
        emit(BalanceState(balance: _balance, status: Status.Failed, card: _card));
      }


    });

  on<WithdrawalOfFundsBalanceEvent>((event, emit) async {
    emit(BalanceState(balance: _balance, status: Status.Loading));
    try {
      if(_card == null) {
        emit(BalanceState(balance: _balance, message: 'Добавьте карту, куда будут выводится средства', card: _card));
      } else {
        _balance = await GetBalance(_fbBalanceRepo).call(
            await GetUserId(_authRepo).call());
        await CreateWithdrawalRequest(_fbBalanceRepo).call(card: _card!);
        emit(BalanceState(balance: _balance, message: 'Запрос на вывод средств был отправлен и будет обработан в ближайшее время!', card: _card));

      }


    } catch (_) {
      emit(BalanceState(balance: _balance, status: Status.Failed, card: _card));
    }

  });
  on<SaveCardBalanceEvent>((event, emit) async {
    _card = UserCard(number: event.card);
    if(_card != null) {
     await DBDelete(_dbRepo).call(DBConstants.cardsTable, _card!.toJson(), 'number');
    }
    await DBInsert(_dbRepo).call(DBConstants.cardsTable, _card!.toJson());
    AppSnackBar.showSnackBar(event.context, content: 'Вы успешно добавили карту');
    emit(BalanceState(balance: _balance, card: _card));

  });



  }
}