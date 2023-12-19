import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patroleum_app/bloc/auth.dart';
import 'package:pulsator/pulsator.dart';

import 'page.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthCubit(repository: context.read()),
        child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
          if (state.getIsLoadingSplash!) {
            print('STATUSSSS: ${state.getIsLoadingSplash}');
            return Container(
              color: Theme.of(context).colorScheme.background,
              child: Center(
                  child: Pulsator(
                style: PulseStyle(color: Colors.grey.shade400),
                count: 5,
                duration: const Duration(seconds: 4),
                repeat: 0,
                startFromScratch: false,
                autoStart: true,
                fit: PulseFit.contain,
                child: Image.asset(
                  'assets/images/icon.png',
                  width: 40.0,
                ),
              )),
            );
          }
          return state.isFinished ? const Home() : const Login();
        }));
  }
}
