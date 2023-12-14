import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:oauth2/src/client.dart';
import 'package:patroleum_app/bloc/auth.dart';
import 'package:patroleum_app/bloc/devices_cubit.dart';
import 'package:patroleum_app/bloc/home_cubit.dart';
import 'package:patroleum_app/model/model.dart';
import 'package:patroleum_app/page/home/player.dart';
import 'package:patroleum_app/repository/repository.dart';
import 'package:patroleum_app/bloc/status.dart';
import 'package:logging/logging.dart';
import 'package:patroleum_lib/patroleum_lib.dart';
import 'package:patroleum_lib/Device.dart';

class Devices extends StatefulWidget {
  const Devices({super.key});

  @override
  State<StatefulWidget> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  final _logger = Logger('AuthCubit');
  ERPClient client = ERPClient();
  List<Device> devices = List<Device>.empty();
  bool isLoading = true;
  String? error = null;

  _DevicesState() {
    client.getDevices().then((value) {
      devices = value;
      setState(() {
        isLoading = false;
      });
    }, onError: (e) {
      _showToast(context, "error: $e");
      print(e);
      setState(() {
        isLoading = false;
        error = e.toString();
      });
    });
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return const Center(child: LinearProgressIndicator());

    // return RepositoryProvider(
    //   //TODO provide repository before hand
    //   create: (context) {
    //     return ERPClient();
    //     // AuthState n = context.read<AuthCubit>().state;
    //     // if (n.client != null) return DevicesRepository(n.client!);
    //     // return DevicesRepository(__client as Client);
    //   },
    //   child:
    // return BlocProvider(
    //   create: (context) => DevicesCubit(context.read()),
    //   child: BlocBuilder<DevicesCubit, DevicesState>(builder: (context, state) {

    //     if (state.status == Status.loading) {
    //       /* move this to lib */
    //       return const Center(child: CircularProgressIndicator());
    //     } else {
    print('$devices, $isLoading');

    return Stack(children: [
      if (error != null)
        Container(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$error"),
        )),
      if (error == null)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final item = devices[index];
                return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                        onTap: () async {
                          final channel = await showDialog<Channel?>(
                              context: context,
                              builder: (context) => AlertDialog(
                                  title: const Text('Select channel'),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Cancel'))
                                  ],
                                  content: SingleChildScrollView(
                                      child: Column(
                                          children: item.channels
                                              .map((c) => ListTile(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pop(c);
                                                  },
                                                  title: Text(c.name)))
                                              .toList(growable: false)))));
                          if (channel != null) {
                            print('channel $channel');
                            print('navigator ${Navigator.of(context)}');
                            if (!context.mounted) return;

                            // Navigator.of(context).pop();
                            Navigator.push(context, Player.route(channel));
                          }
                        },
                        title: Text(item.name),
                        subtitle: Text('${item.channels.length} channel(s)')));
              }),
        ),
      if (isLoading)
        const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black)),
      if (isLoading)
        const Center(
          child: CircularProgressIndicator(),
        )
    ]);
    //       }
    //     }),
    //   );
    //   // );
  }
}
