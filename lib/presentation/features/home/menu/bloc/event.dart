
import 'package:flutter/cupertino.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/bloc/state.dart';

abstract class MenuEvent {}

class InitMenuEvent extends MenuEvent {

}

class GoToProfileMenuEvent extends MenuEvent {
    final BuildContext context;

  GoToProfileMenuEvent(this.context);
}

class GoMenuEvent extends MenuEvent {
  final MenuState newState;

  GoMenuEvent({required this.newState});
}