part of 'group_bloc.dart';

@immutable
sealed class GroupEvent {}

final class CreateGroupInitiatedEvent extends GroupEvent {
  Group group;
  User user;
  CreateGroupInitiatedEvent({required this.user, required this.group});
}

final class JoinGroupEvent extends GroupEvent {
  User user;
  String groupId;
  JoinGroupEvent({required this.user, required this.groupId});
}

final class LeaveGroupEvent extends GroupEvent {
  User user;
  LeaveGroupEvent({required this.user});
}

final class GetGroupsEvent extends GroupEvent {
  final String userId;
  GetGroupsEvent({required this.userId});
}
