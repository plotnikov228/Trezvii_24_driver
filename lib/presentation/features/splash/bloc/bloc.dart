import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trezvii_24_driver/data/db/repository/repository.dart';
import 'package:trezvii_24_driver/domain/db/usecases/init_db.dart';
import 'package:trezvii_24_driver/presentation/features/splash/bloc/event.dart';
import 'package:trezvii_24_driver/presentation/features/splash/bloc/state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trezvii_24_driver/presentation/routes/router.dart';
import 'package:trezvii_24_driver/presentation/routes/routes.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc(super.initialState) {

    on<InitializeAppInSplashEvent>((event, emit) async {
      //initialize
      await Firebase.initializeApp();
      //await FirebaseAppCheck.instance.activate();
      await InitDB(DBRepositoryImpl()).call();
      try {
        late StreamSubscription<User?> listener;
        listener = FirebaseAuth.instance.authStateChanges().listen((user) {
          Timer(const Duration(seconds: 2),() async {
            bool authorized = true;
            if (user == null) {
              authorized = false;
            }
            event.context.pushReplacement(await AppRouter().getStartLocation(authorized));
            listener.cancel();
          });

        });
      } catch (_) {
        event.context.pushReplacementNamed(AppRoutes.auth);
      }

    });

  }

}