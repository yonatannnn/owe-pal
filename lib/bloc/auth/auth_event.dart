part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthStarted extends AuthEvent {}

final class SaveName extends AuthEvent {
  final String name;
  SaveName(this.name);
}
