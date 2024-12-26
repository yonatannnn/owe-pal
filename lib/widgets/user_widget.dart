import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:owe_pal/bloc/amount/amount_bloc.dart';
import 'package:owe_pal/bloc/auth/auth_bloc.dart';
import 'package:owe_pal/models/amount.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserWidget extends StatefulWidget {
  final Amount amount;
  const UserWidget({super.key, required this.amount});

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

Future<String?> _loadUid() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('uid');
}

class _UserWidgetState extends State<UserWidget> {
  bool _isExpanded = false;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Retrieve the current user from AuthBloc
    final currentUser = context.read<AuthBloc>().state is AuthSuccess
        ? (context.read<AuthBloc>().state as AuthSuccess).user
        : null;

    // Determine which name to display as the other user
    final otherUserName =
        (currentUser != null && currentUser.name == widget.amount.user1.name)
            ? widget.amount.user2.name
            : widget.amount.user1.name;

    final thisUserId =
        (currentUser != null && currentUser.name == widget.amount.user1.name)
            ? widget.amount.user1.uid
            : widget.amount.user2.uid;

    final String amountId = widget.amount.id;
    final String userId = thisUserId;
    final String otherUserId = amountId.split('_')[0];
    var netAmount = 0.0;
    if (userId == amountId.split('_')[0]) {
      netAmount = widget.amount.netAmount.toDouble();
    } else {
      netAmount = -widget.amount.netAmount.toDouble();
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    otherUserName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _getNameColor(netAmount),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    _formatNetAmount(netAmount),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: netAmount >= 0
                          ? Colors.greenAccent
                          : Colors.redAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Enter amount",
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  hintText: "Enter reason",
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  final enteredAmount = _amountController.text;
                  final enteredReason = _reasonController.text;
                  context.read<AmountBloc>().add(
                        UpdateAmountEvent(
                            amount: widget.amount,
                            reason: enteredReason,
                            difference: int.parse(enteredAmount)),
                      );
                  _amountController.clear();
                  _reasonController.clear();
                  setState(() {
                    _isExpanded = false;
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text("Add"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  String _formatNetAmount(double netAmount) {
    if (netAmount > 0) {
      return "+${netAmount.toStringAsFixed(2)}";
    } else if (netAmount < 0) {
      return netAmount.toStringAsFixed(2);
    }
    return "0.00";
  }

  Color _getNameColor(double netAmount) {
    if (netAmount > 0) {
      return Colors.greenAccent;
    } else if (netAmount < 0) {
      return Colors.redAccent;
    }
    return Colors.white;
  }
}
