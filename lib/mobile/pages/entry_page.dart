import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:owe_pal/mobile/pages/group_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:owe_pal/bloc/auth/auth_bloc.dart';
import 'package:owe_pal/bloc/group/group_bloc.dart';
import 'package:owe_pal/models/group.dart';
import 'package:owe_pal/models/user.dart';
import 'package:owe_pal/widgets/custom_button.dart';
import 'dart:convert'; // For JSON decoding

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();

  bool showCreateGroupField = false;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserFromSharedPreferences();
  }

  Future<void> _loadUserFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      setState(() {
        currentUser = User.fromJson(jsonDecode(userJson));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                setState(() {
                  currentUser = state.user;
                });
                _saveUserToSharedPreferences(state.user);
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
          BlocListener<GroupBloc, GroupState>(
            listener: (context, state) {
              if (state is GroupCreated || state is GroupJoined) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => GroupListPage()),
                );
              } else if (state is GroupError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group,
                      size: 80,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 10),
                    Text(
                      'Do you want to join an existing group?',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Group ID',
                        labelStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.group, color: Colors.blue),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 20.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (context.watch<GroupBloc>().state is GroupLoading)
                      CircularProgressIndicator()
                    else
                      CustomButton(
                        text: 'Join',
                        function: () {
                          if (currentUser != null) {
                            context.read<GroupBloc>().add(
                                  JoinGroupEvent(
                                    user: currentUser!,
                                    groupId: nameController.text,
                                  ),
                                );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('User not available.'),
                              ),
                            );
                          }
                        },
                      ),
                    const SizedBox(height: 40),
                    Text(
                      'Or',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 40),
                    if (!showCreateGroupField)
                      CustomButton(
                        text: 'Create Group',
                        function: () {
                          setState(() {
                            showCreateGroupField = true;
                          });
                        },
                      ),
                    if (showCreateGroupField) ...[
                      TextField(
                        style: TextStyle(color: Colors.white),
                        controller: groupNameController,
                        decoration: InputDecoration(
                          labelText: 'Group Name',
                          labelStyle: TextStyle(color: Colors.white70),
                          prefixIcon: Icon(Icons.person, color: Colors.blue),
                          filled: true,
                          fillColor: Colors.grey[900],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 20.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (context.watch<GroupBloc>().state is GroupLoading)
                        CircularProgressIndicator()
                      else
                        CustomButton(
                          text: 'Create',
                          function: () {
                            if (currentUser != null) {
                              context.read<GroupBloc>().add(
                                    CreateGroupInitiatedEvent(
                                      user: currentUser!,
                                      group: Group(
                                        id: DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString(),
                                        name: groupNameController.text,
                                        usersId: [currentUser!.uid],
                                      ),
                                    ),
                                  );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('User not available.'),
                                ),
                              );
                            }
                          },
                        ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _saveUserToSharedPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentUser', jsonEncode(user.toJson()));
  }
}
