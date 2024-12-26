import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:owe_pal/models/amount.dart';
import 'package:owe_pal/repository/amount_repository.dart';
import 'package:owe_pal/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'amount_event.dart';
part 'amount_state.dart';

class AmountBloc extends Bloc<AmountEvent, AmountState> {
  final AmountRepository _amountRepository = AmountRepository();
  final UserRepository _userRepository = UserRepository();
  AmountBloc() : super(AmountInitial()) {
    on<GetAmountsEvent>((event, emit) async {
      emit(AmountLoading());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = await prefs.getString('uid');
      var amounts =
          await _amountRepository.getAmountsByGroupId(event.groupId, userId!);
      emit(AmountLoaded(amounts: amounts));
    });

    on<UpdateAmountEvent>(
      (event, emit) async {
        emit(AmountLoading());

        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? userId = await prefs.getString('uid');
          var amount = event.amount;
          if (amount.id.split('_')[0] == userId) {
            amount.netAmount = amount.netAmount + event.difference;
            await _amountRepository.updateAmount(amount);
            var amounts = await _amountRepository.getAmountsByGroupId(
                amount.groupId, userId!);
            emit(AmountLoaded(amounts: amounts));
          } else if (amount.id.split('_')[1] == userId) {
            amount.netAmount = amount.netAmount - event.difference;
            await _amountRepository.updateAmount(amount);
            var amounts = await _amountRepository.getAmountsByGroupId(
                amount.groupId, userId!);
            emit(AmountLoaded(amounts: amounts));
          } else {
            emit(AmountError(message: 'Failed to update the amount.'));
          }
        } catch (e) {
          emit(AmountError(message: 'Failed to update the amount.'));
        }
      },
    );
  }
}
