import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patroleum_app/bloc/player_cubit.dart';
import 'package:patroleum_app/bloc/status.dart';
import 'package:patroleum_app/model/model.dart';
import 'package:patroleum_lib/patroleum_lib.dart';
import 'package:patroleum_lib/Device.dart';
// import 'package:patroleum_app/repository/devices.dart';
import 'package:video_player/video_player.dart';

class Player extends StatelessWidget {
  static route(Channel channel) => MaterialPageRoute(
      builder: (context) => RepositoryProvider.value(
          value: channel,
          child: BlocProvider(
              create: (context) =>
                  PlayerCubit(channel.code), //, context.read()),
              child: Player(channel))));

  const Player(this.channel, {super.key});

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    print('flag');
    return Scaffold(
      body: BlocBuilder<PlayerCubit, PlayerState>(
          builder: (context, state) => state.status == Status.success
              ? VideoUrlPlayer(state.uri!)
              : state.status == Status.error
                  ? Center(child: Text(state.message ?? ''))
                  : const Center(child: CircularProgressIndicator())),
    );
  }
}

class VideoUrlPlayer extends StatefulWidget {
  const VideoUrlPlayer(this.uri, {super.key});

  final Uri uri;

  @override
  State<VideoUrlPlayer> createState() => _VideoUrlPlayerState();
}

class _VideoUrlPlayerState extends State<VideoUrlPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _controller = VideoPlayerController.networkUrl(widget.uri)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? SizedBox.expand(
            child: VideoPlayer(_controller),
          )
        : const ColoredBox(color: Colors.black);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([]);
  }
}
