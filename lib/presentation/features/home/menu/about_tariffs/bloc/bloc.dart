import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trezvii_24_driver/domain/payment/models/tariff.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/about_tariffs/bloc/state.dart';

import '../../../../../../data/firebase/firestore/repository.dart';
import '../../../../../../domain/firebase/firestore/usecases/get_collection_data.dart';
import 'event.dart';

class AboutTariffsBloc extends Bloc<AboutTariffsEvent, AboutTariffsState> {
  AboutTariffsBloc(super.initialState) {
    List<Tariff> _tariffs = [];

    on<InitAboutTariffsEvent>((event, emit) async {
        _tariffs = (await GetCollectionData(FirebaseFirestoreRepositoryImpl()).call('Tariffs')).map((e) => Tariff.fromJson(e)).toList();
        emit(AboutTariffsState(tariffs: _tariffs));
    });
  }
}

