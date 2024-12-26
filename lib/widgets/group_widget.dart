import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:owe_pal/bloc/amount/amount_bloc.dart';
import 'package:owe_pal/mobile/pages/user_list_page.dart';
import 'package:owe_pal/models/group.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupWidget extends StatelessWidget {
  final Group group;
  const GroupWidget({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.read<AmountBloc>().add(GetAmountsEvent(groupId: group.id));
        context.go('/userListPage');
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 33, 33, 33),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                group.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // Group ID
            Expanded(
              flex: 2,
              child: Text(
                group.id,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
