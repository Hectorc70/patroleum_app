import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patroleum_app/bloc/auth_cubit.dart';
import 'package:patroleum_app/bloc/home_cubit.dart';
import 'package:patroleum_app/page/home/home.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    debugPrint('why home');

    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(
              title: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) => Text('Welcome ${state.usr}'))),
          // body: switch (state.tab) {
          //   HomeTab.dashboard => const LivewallVC(),
          //   // HomeTab.dashboard => const Dashboard(),
          //   HomeTab.devices => const Devices(),
          //   HomeTab.account => const Account(),
          // },
          body: Builder(builder: (_) {
            if (state.tab == HomeTab.dashboard) {
              return const LivewallVC();
            } else if (state.tab == HomeTab.devices) {
              return const Devices();
            }

            return const Account();
          }),
          bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                context.read<HomeCubit>().selectTab(HomeTab.values[index]);
              },
              currentIndex: state.tab.index,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard), label: 'LiveWall'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.device_hub), label: 'Devices'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle), label: 'Account')
              ]),
        ),
      ),
    );
  }
}
