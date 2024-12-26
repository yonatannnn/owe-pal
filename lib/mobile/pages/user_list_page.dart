import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:owe_pal/bloc/amount/amount_bloc.dart';
import 'package:owe_pal/bloc/auth/auth_bloc.dart';
import 'package:owe_pal/bloc/group/group_bloc.dart';
import 'package:owe_pal/models/amount.dart';
import 'package:owe_pal/models/user.dart';
import 'package:owe_pal/repository/amount_repository.dart';
import 'package:owe_pal/widgets/user_widget.dart';
import '../../bloc/amount/amount_bloc.dart';

class UserListPage extends StatelessWidget {
  final String groupId;

  const UserListPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
      ),
      body: BlocBuilder<AmountBloc, AmountState>(
        builder: (context, state) {
          if (state is AmountLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AmountLoaded) {
            final amounts = state.amounts;
            print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
            print(amounts);
            if (amounts.isEmpty) {
              return const Center(child: Text('No users found'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: amounts.map((amount) {
                  return UserWidget(amount: amount);
                }).toList(),
              ),
            );
          } else if (state is AmountError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(
                child: Text(
              'Error loading users',
              style: TextStyle(color: Colors.white),
            ));
          }
        },
      ),
    );
  }
}
