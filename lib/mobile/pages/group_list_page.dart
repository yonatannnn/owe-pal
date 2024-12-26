import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:owe_pal/bloc/auth/auth_bloc.dart';
import 'package:owe_pal/bloc/group/group_bloc.dart';
import 'package:owe_pal/mobile/pages/entry_page.dart';
import 'package:owe_pal/widgets/group_widget.dart';

class GroupListPage extends StatelessWidget {
  const GroupListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Current Groups',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.add),
        color: Colors.white,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EntryPage()),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthSuccess) {
            final userId = authState.user.uid;
            context.read<GroupBloc>().add(GetGroupsEvent(userId: userId));

            return BlocBuilder<GroupBloc, GroupState>(
              builder: (context, groupState) {
                if (groupState is GroupLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (groupState is GroupLoaded) {
                  final groups = groupState.groups;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GroupWidget(group: groups[index]),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  );
                } else if (groupState is GroupError) {
                  return Center(
                    child: Text(
                      'Failed to load groups: ${groupState.message}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No groups available',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              },
            );
          } else {
            return const Center(
              child: Text(
                'User not authenticated. Please log in again.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }
}
