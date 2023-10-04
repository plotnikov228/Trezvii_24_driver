import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trezvii_24_driver/data/firebase/auth/repository.dart';
import 'package:trezvii_24_driver/domain/firebase/balance/usecases/create_withdrawal_request.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/balance/bloc/event.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/balance/bloc/state.dart';
import 'package:trezvii_24_driver/presentation/utils/status_enum.dart';

import '../../../../../../data/auth/repository/repository.dart';
import '../../../../../../data/firebase/balance/repository.dart';
import '../../../../../../domain/auth/usecases/get_user_id.dart';
import '../../../../../../domain/firebase/balance/usecases/get_balance.dart';
import '../../../../../../domain/firebase/balance/usecases/reset_the_balance.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {

  double _balance = 0;
  final _fbBalanceRepo = FirebaseBalanceRepositoryImpl();
  final _authRepo = AuthRepositoryImpl();
  BalanceBloc(super.initialState) {
    on<InitBalanceEvent>((event, emit) async {
      emit(BalanceState(balance: _balance, status: Status.Loading));

      try {
        _balance = await GetBalance(_fbBalanceRepo).call(await GetUserId(_authRepo).call());
        emit(BalanceState(balance: _balance));
      } catch (_) {
        emit(BalanceState(balance: _balance, status: Status.Failed));
      }

    });

  on<WithdrawalOfFundsBalanceEvent>((event, emit) async {
    emit(BalanceState(balance: _balance, status: Status.Loading));
    try {
      _balance = await GetBalance(_fbBalanceRepo).call(
        await GetUserId(_authRepo).call());
      CreateWithdrawalRequest(_fbBalanceRepo).call().then((value) async {
        emit(BalanceState(balance: _balance, message: 'Запрос на вывод средств был отправлен'));
      });
    } catch (_) {
      emit(BalanceState(balance: _balance, status: Status.Failed));
    }

  });

  }
}