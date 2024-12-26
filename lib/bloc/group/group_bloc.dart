import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:owe_pal/models/amount.dart';
import 'package:owe_pal/models/group.dart';
import 'package:owe_pal/models/user.dart';
import 'package:owe_pal/repository/amount_repository.dart';
import 'package:owe_pal/repository/group_repository.dart';
import 'package:owe_pal/repository/user_repository.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc() : super(GroupInitial()) {
    GroupRepository groupRepository = GroupRepository();
    AmountRepository amountRepository = AmountRepository();
    UserRepository userRepository = UserRepository();
    on<CreateGroupInitiatedEvent>((event, emit) async {
      emit(GroupLoading());
      try {
        var group = event.group;
        var user = event.user;
        await groupRepository.createGroup(group);
        await groupRepository.addUserToGroup(group.id, user.uid);
        emit(GroupCreated(group: group));
      } catch (e) {
        emit(GroupError(message: e.toString()));
      }
    });

    on<GetGroupsEvent>((event, emit) async {
      emit(GroupLoading());
      try {
        var groups = await groupRepository.getAllGroups();
        var userGroups = groups
            .where((group) => group.usersId.contains(event.userId))
            .toList();
        emit(GroupLoaded(groups: userGroups));
      } catch (e) {
        emit(GroupError(message: e.toString()));
      }
    });
    on<JoinGroupEvent>((event, emit) async {
      emit(GroupLoading());
      try {
        var user = event.user;
        var groupId = event.groupId;
        var currentGroup = await groupRepository.getGroup(groupId);
        if (currentGroup?.usersId.contains(user.uid) ?? false) {
          emit(GroupError(message: 'User already in group'));
          return;
        }

        if (currentGroup == null) {
          emit(GroupError(message: 'Group not found'));
          return;
        }

        for (String id in currentGroup.usersId) {
          var user1 = await userRepository.getUser(id);
          if (user1 != null) {
            List<String> ids = [id, user.uid];
            ids.sort();
            String newId = ids.join('_');
            await amountRepository.addAmount(Amount(
                id: newId,
                groupId: groupId,
                user1: user1,
                user2: user,
                netAmount: 0));
          } else {
            emit(GroupError(message: 'User not found'));
            return;
          }
        }

        await groupRepository.addUserToGroup(groupId, user.uid);

        emit(GroupJoined());
      } catch (e) {
        emit(GroupError(message: e.toString()));
      }
    });
  }
}
