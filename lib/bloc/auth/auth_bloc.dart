import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:owe_pal/models/user.dart';
import 'package:owe_pal/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository = UserRepository();
  AuthBloc() : super(AuthInitial()) {
    on<SaveName>((event, emit) async {
      var name = event.name;
      var uid = DateTime.now().millisecondsSinceEpoch.toString();
      try {
        emit(AuthLoading());
        User user = User(name: name, uid: uid, groupIds: []);
        try {
          _userRepository.addUser(user);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final userJson = json.encode(user.toJson());
          prefs.setString('user', userJson);
          prefs.setString('uid', uid);
          emit(AuthSuccess(user));
        } catch (e) {
          emit(AuthFailure('Failed to save the user.'));
        }
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
