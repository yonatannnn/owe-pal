part of 'amount_bloc.dart';

@immutable
sealed class AmountEvent {}

final class GetAmountsEvent extends AmountEvent {
  final String groupId;
  GetAmountsEvent({required this.groupId});
}

final class AddAmountEvent extends AmountEvent {
  final Amount amount;
  AddAmountEvent({required this.amount});
}

final class UpdateAmountEvent extends AmountEvent {
  final Amount amount;
  String reason;
  int difference;
  UpdateAmountEvent(
      {required this.amount, required this.reason, required this.difference});
}
