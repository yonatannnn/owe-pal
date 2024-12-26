part of 'group_bloc.dart';

@immutable
sealed class GroupState {}

final class GroupInitial extends GroupState {}

final class GroupLoading extends GroupState {}

final class GroupLoaded extends GroupState {
  List<Group> groups;
  GroupLoaded({required this.groups});
}

final class GroupError extends GroupState {
  String message;
  GroupError({required this.message});
}

final class GroupCreated extends GroupState {
  Group group;
  GroupCreated({required this.group});
}

final class GroupJoined extends GroupState {}

final class GroupLeft extends GroupState {
  Group group;
  GroupLeft({required this.group});
}
