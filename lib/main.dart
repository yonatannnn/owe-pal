import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:owe_pal/bloc/amount/amount_bloc.dart';
import 'package:owe_pal/bloc/auth/auth_bloc.dart';
import 'package:owe_pal/bloc/group/group_bloc.dart';
import 'package:owe_pal/firebase_options.dart';
import 'package:owe_pal/mobile/pages/entry_page.dart';
import 'package:owe_pal/mobile/pages/group_list_page.dart';
import 'package:owe_pal/mobile/pages/login_page.dart';
import 'package:owe_pal/mobile/pages/user_list_page.dart';
import 'package:owe_pal/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(),
        ),
        BlocProvider<AmountBloc>(
          create: (BuildContext context) => AmountBloc(),
        ),
        BlocProvider<GroupBloc>(
          create: (BuildContext context) => GroupBloc(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'owe pal',
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      return null;
    } else {
      return '/';
    }
  },
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          (context.read<AuthBloc>().state is AuthSuccess)
              ? GroupListPage()
              : LoginScreen(),
      routes: [
        GoRoute(
          path: 'entryPage',
          builder: (context, state) {
            return EntryPage();
          },
        ),
        GoRoute(
          path: 'groupListPage',
          builder: (context, state) {
            return GroupListPage();
          },
          
        ),
        GoRoute(
          path: 'userListPage',
          builder: (context, state) {
            final groupId = state.extra.toString();
            return UserListPage(
              groupId: groupId,
            );
          },
        ),
      ],
    ),
  ],
);
