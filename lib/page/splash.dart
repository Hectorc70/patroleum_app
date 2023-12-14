import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patroleum_app/bloc/auth.dart';

import 'page.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthCubit(repository: context.read()),
        child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) =>
                state.isFinished ? const Home() : const Login()));
  }
}
