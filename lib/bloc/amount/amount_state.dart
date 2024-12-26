part of 'amount_bloc.dart';

@immutable
sealed class AmountState {}

final class AmountInitial extends AmountState {}

final class AmountLoading extends AmountState {}

final class AmountLoaded extends AmountState {
  final List<Amount> amounts;
  AmountLoaded({required this.amounts});
}

final class AmountError extends AmountState {
  final String message;
  AmountError({required this.message});
}

final class AmountAdded extends AmountState {
  final Amount amount;
  AmountAdded({required this.amount});
}

final class AmountUpdated extends AmountState {
  final Amount amount;
  final Amount differnce;
  AmountUpdated({required this.amount, required this.differnce});
}
