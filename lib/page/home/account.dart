import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patroleum_app/bloc/auth.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FilledButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
            child: const Text('Logout')));
  }
}
