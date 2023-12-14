// import 'package:chewie/chewie.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patroleum_app/page/home/player.dart';
import 'package:patroleum_lib/Device.dart';
import 'package:patroleum_lib/patroleum_lib.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_menu/star_menu.dart';

class LivewallVC extends StatefulWidget {
  const LivewallVC({super.key});

  @override
  State<LivewallVC> createState() => _LivewallVCState();
}

class _LivewallVCState extends State<LivewallVC> {
  static const WALL_CONFIG = "WALL_CONFIG";
  static const DEVICE_LIST = "DEVICE_LIST";

  int selectedVideoCount = 2;
  List<String> videoAssets = [];
  bool isLoading = true;
  List<Device>? devices;
  List<VideoPlayerController> _controllers = [];
  List<String> config = [];
  VideoPlayerController? fullscrenView;
  StarMenuController starMenuController = StarMenuController();

  final List<String> editMenuItems = ['2', '4', '6', '8', '10', '12'];
  String? selectedMenuItem;

  List<Widget> chipsEntries = [
    Chip(
      avatar: CircleAvatar(child: const Text('SM')),
      label: const Text('Faces'),
    ),
    Chip(
      avatar: CircleAvatar(child: const Text('SM')),
      label: const Text('Recordings'),
    ),
    Chip(
      avatar: CircleAvatar(child: const Text('SM')),
      label: const Text('Tickets'),
    ),
    Chip(
      avatar: CircleAvatar(child: const Text('SM')),
      label: const Text('Alarms'),
    ),
    Chip(
      avatar: CircleAvatar(child: const Text('SM')),
      label: const Text('Remove'),
    ),
    Chip(
      avatar: CircleAvatar(child: const Text('SM')),
      label: const Text('Replace'),
    ),
  ];

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void addSlot() {}

  void removeSlot(int index) {
    if (index >= 0 && index < videoAssets.length) {
      setState(() {
        videoAssets.removeAt(index);
      });
    }
  }

  createControllersFromList(List<dynamic> assets) {
    List<VideoPlayerController> savedcontrollers = <VideoPlayerController>[];
    print('createControllersFromList: ${assets}');
    Map<String, Map<String, dynamic>> objs = {
      "yes": {"no": 123}
    };

    List<String> test = [r"1000003$1$0$0", r"1000003$1$0$0"];

    ERPClient().getVideoUrlFromList(test).then((value) {
      value.retainWhere((e) => e != null);
      List<VideoPlayerController> controllers = [for (int i = 0; i != value.length; i++) VideoPlayerController.networkUrl(value[i] as Uri)];

      print(controllers);
    });

    // assets.forEach((c) async {
    //   Map<String, dynamic> d = c;
    //   print(d);

    //   if (d.containsKey('cc')) {
    //     print('flag ${d}');
    //     Uri? uri = await ERPClient().getVideoUrl(d['cc']);
    //     d['uri'] = uri;
    //     objs[d['cc']] = d;
    //     objs['qweqwe'] = {'wtf': 123};
    //     if (uri != null) {
    //       String url = uri.toString();
    //       print('assets $url');
    //       VideoPlayerController vpc = VideoPlayerController.networkUrl(uri);
    //       await vpc.initialize();
    //       savedcontrollers.add(vpc);
    //     }
    //   } else {
    //     print("saved config has no cc property");
    //   }
    // });

    print("omg");
    print(objs);
  }

  void loadConfig() {
    SharedPreferences.getInstance().then((p) {
      Map _configuration = {"selectedVideoCount": selectedVideoCount, "devices": devices, "config": config};
      String s = jsonEncode(_configuration);
      Map configuration = jsonDecode(s);
      // Map configuration = jsonDecode((p.getString(WALL_CONFIG) ?? "{}"));

      // print(configuration);
    });
  }

  void saveConfig() {
    print('save config');
    SharedPreferences.getInstance().then((p) {
      // print("saving config");
      // print("selectedVideoCount $selectedVideoCount");
      // print("videoAssets $videoAssets");
      // print("devices $devices");
      // print("config $config");

      Map configuration = {"selectedVideoCount": selectedVideoCount, "devices": devices, "config": config};
      // print(jsonEncode(configuration));
      loadConfig();
      // p.setString(WALL_CONFIG, jsonEncode(config));
    });
  }

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((p) {
      List<String> savedconfig = p.getStringList(WALL_CONFIG) ?? [];
      print("config:");
      List<dynamic> config = savedconfig.map((e) => jsonDecode(e)).toList();
      // print(config);

      String jsonlist = p.getString(DEVICE_LIST) ?? '';
      var devicelist = Device.fromJson(jsonDecode(jsonlist));
      print(devicelist);

      // createControllersFromList(config);
      return;

      try {
        List<String> savedconfig = p.getStringList(WALL_CONFIG) ?? [];
        print(savedconfig);

        String jsonlist = p.getString(DEVICE_LIST) ?? '';
        var devicelist = Device.fromJson(jsonDecode(jsonlist));
        print('parsed $jsonlist');

        if (savedconfig.length > 0) {
          List<Channel> channels = <Channel>[];
          savedconfig.forEach((str) => channels.add(Channel.fromJson(jsonDecode(str))));
          print('saved $channels');

          List<String> assets = <String>[];
          List<VideoPlayerController> savedcontrollers = <VideoPlayerController>[];

          channels.forEach((c) async {
            Uri? uri = await ERPClient().getVideoUrl(c.code);
            if (uri != null) {
              assets.add(uri.toString());
              print('assets $assets');
              VideoPlayerController vpc = VideoPlayerController.networkUrl(uri);
              await vpc.initialize();
              savedcontrollers.add(vpc);
            }
          });

          setState(() {
            selectedVideoCount = channels.length + (channels.length % 2); //make even
            print(selectedVideoCount);
            videoAssets = assets;
            _controllers = savedcontrollers;
            config = savedconfig;
            isLoading = false;
          });
        } else {
          setState(() {
            devices = devicelist;
            isLoading = false;
          });
        }
      } catch (e) {
        print('error getting WALL_CONFIG ${e}');
        p.setStringList(WALL_CONFIG, []);
      }
    });

    ERPClient().getDevices().then(
        (value) => SharedPreferences.getInstance().then((p) {
              // p.setString(DEVICE_LIST, value.toString());
              // print('set devicelist "$value"');
              try {
                String encoded = jsonEncode(value);
                p.setString(DEVICE_LIST, encoded);
                print('encoded $encoded');
              } catch (e) {
                print("error $e");
                _showToast(context, "error $e");
              }
              setState(() {
                /** test the new device list and saved device list are different */
                devices = value;
                isLoading = false;
              });
            }), onError: (e) {
      print(e);
      _showToast(context, "error $e");
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      print("got my error :) ${e}");
      _showToast(context, "error $e");
    });

    /* TODO: read from prefs if possible */
    for (int i = 0; i < videoAssets.length; i++) {
      if (videoAssets[i].isEmpty) print('videoAssets $i is empty');

      final videoController = VideoPlayerController.asset(videoAssets[i])
        ..initialize().then((_) {
          setState(() {});
        });

      _controllers.add(videoController);
      videoController.play();
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    for (var videoController in _controllers) {
      videoController.dispose();
    }
    super.dispose();
  }

  void handleMenuItemSelected(String value) {
    setState(() {
      selectedMenuItem = value;
      selectedVideoCount = int.parse(value);
      videoAssets = List<String>.filled(selectedVideoCount, "");
      // videoAssets.expand((element) => '');
    });
  }

  void videoSelected(channel, index) {
    setState(() {
      isLoading = true;
    });

    print("callback selected: $channel $index");
    print("channel then ${channel.runtimeType}");

    if (channel != null) {
      ERPClient().getVideoUrl(channel.code).then((uri) {
        if (uri == null) return "error";

        print('got uri ${uri.toString()}');
        videoAssets.insert(index, uri.toString());
        final videoController = VideoPlayerController.networkUrl(uri, videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true, mixWithOthers: true))
          ..initialize().then((_) {
            setState(() {
              isLoading = false;
            });

            _controllers[index].play();
          }).catchError((error) {
            setState(() {
              print('got error $error');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Error on video: $error"),
              ));

              isLoading = false;
              _controllers.removeAt(index);
              videoAssets.removeAt(index);
            });
          });

        _controllers.insert(index, videoController);
      });
    }

    print('channel for $index is $channel');
  }

  starMenuItemTapped(index, controller) {
    Chip c = chipsEntries[index] as Chip;
    print("starmenu item $index tapped with ${c.label}");
    String? s = (c.label as Text).data;
    if (s == null) return;

    switch (s) {
      case 'Faces':
        print('Faces');
        break;
      case 'Recordings':
        print('Recordings');
        break;
      case 'Tickets':
        print('Tickets');
        break;
      case 'Alarms':
        print('Alarms');
        break;
      case 'Remove':
        print('Remove');
        break;
      case 'Replace':
        print('Replace');
        break;
      default:
        print('no match for ${s}');
    }
  }

  void addPlayableStream() {
    dynamic value = 'lol';
    int index = 0;

    SharedPreferences.getInstance().then((p) {
      String strChannel = jsonEncode(value);
      print('clicked adding ${strChannel}');
      print(p.getStringList(WALL_CONFIG));
      config.add(strChannel);

      p.setStringList(WALL_CONFIG, config);
    }).catchError((e) {
      print('could not save config, $e');
    });

    ERPClient().getVideoUrl(value.code).then((uri) {
      if (uri == null) return "error";

      print('got uri ${uri.toString()}');
      videoAssets.insert(index, uri.toString());

      final videoController = VideoPlayerController.networkUrl(uri, videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true, mixWithOthers: true))
        ..initialize().then((_) {
          setState(() {
            isLoading = false;
          });
        }).catchError((error) {
          setState(() {
            print('got error $error');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Error on video: $error"),
            ));

            _controllers.removeAt(index);
            videoAssets.removeAt(index);
            isLoading = false;
          });
        });
      _controllers.insert(index, videoController);
    });

    isLoading = true;
    print('channel for $index is $value');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // (await SharedPreferences.getInstance())
    //     .setString(_kPrefKeyCredentials, client.credentials.toJson());

    return Stack(children: [
      Scaffold(
          backgroundColor: Colors.grey.shade900,
          appBar: AppBar(
            backgroundColor: Colors.white,
            // leading: Icon(Icons.menu, color: Colors.grey.shade200, size: 24),
            title: Center(child: Text('LiveWall')),
            actions: <Widget>[
              Row(
                children: [
                  // Text("rggg ${devices?.length ?? 'null'} bb"),
                  PopupMenuButton<String>(
                    onSelected: handleMenuItemSelected,
                    itemBuilder: (BuildContext context) {
                      return editMenuItems.map((String item) {
                        return PopupMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
            ],
          ),
          body: fullscrenView != null
              ? Container(
                  child: StarMenu(
                      params: StarMenuParameters(useLongPress: true),
                      controller: starMenuController,
                      onStateChanged: (state) => print('State changed: $state'),
                      onItemTapped: starMenuItemTapped,
                      items: chipsEntries,
                      child: VideoThumbnail(
                        onDoubleTap: () {
                          setState(() {
                            fullscrenView = null;
                          });
                        },
                        onLongPress: () {
                          print("lomgpresn");
                        },
                        controller: fullscrenView as VideoPlayerController,
                        isPlaying: fullscrenView!.value.isPlaying,
                        onPlayPause: () {
                          setState(() {
                            if (fullscrenView!.value.isPlaying) {
                              fullscrenView!.pause();
                            } else {
                              fullscrenView!.play();
                            }
                          });
                        },
                      )))
              : ThumbGrid(
                  selectedVideoCount: selectedVideoCount,
                  config: config,
                  videoAssets: videoAssets,
                  saveConfig: saveConfig,
                  thumbs: _controllers
                      .map((e) => StarMenu(
                          params: StarMenuParameters(useLongPress: true, longPressDuration: Duration(milliseconds: 500)),
                          controller: starMenuController,
                          onStateChanged: (state) => print('State changed: $state'),
                          onItemTapped: starMenuItemTapped,
                          items: chipsEntries,
                          child: VideoThumbnail(
                            onDoubleTap: () {
                              print('videoThumbnail callback doubletap');
                              setState(() {
                                fullscrenView = e; //_controllers[index];
                              });
                            },
                            onLongPress: () {
                              print("mylomgpresn");
                              /* */
                              // starMenuController.openMenu!();
                            },
                            controller: e, //_controllers[index],
                            isPlaying: e.value.isPlaying, //_controllers[index].value.isPlaying,
                            onPlayPause: () {
                              setState(() {
                                if (e.value.isPlaying) {
                                  e.pause();
                                } else {
                                  e.play();
                                }
                              });
                            },
                          )))
                      .toList(),
                  controllers: _controllers,
                  devices: this.devices ?? [],
                  fullscreenView: this.fullscrenView,
                  videoSelected: videoSelected,
                )),
      if (isLoading) const Opacity(opacity: 0.8, child: ModalBarrier(dismissible: false, color: Colors.black)),
      if (isLoading)
        const Center(
          child: CircularProgressIndicator(),
        ),
    ]);
  }
}

class VideoThumbnail extends StatelessWidget {
  final VideoPlayerController controller;
  bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onDoubleTap;
  final VoidCallback onLongPress;

  VideoThumbnail({
    required this.controller,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onDoubleTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // final chewieController = ChewieController(
    //   videoPlayerController: controller,
    //   aspectRatio: 16 / 9,
    //   autoPlay: false,
    //   looping: false,
    //   showControls: true,
    //   allowFullScreen: true,
    //   allowMuting: false,
    //   allowedScreenSleep: true,
    //   allowPlaybackSpeedChanging: true,
    //   materialProgressColors: ChewieProgressColors(
    //     playedColor: Colors.red,
    //     handleColor: Colors.red,
    //     bufferedColor: Colors.grey,
    //     backgroundColor: Colors.grey,
    //   ),
    //   deviceOrientationsAfterFullScreen: [
    //     DeviceOrientation.landscapeRight,
    //     DeviceOrientation.landscapeLeft,
    //     DeviceOrientation.portraitUp,
    //     DeviceOrientation.portraitDown,
    //   ],
    // );

    return GestureDetector(
        onDoubleTap: onDoubleTap,
        onTap: onPlayPause,
        onLongPress: onLongPress,
        child: Stack(
          children: [
            VideoPlayer(controller),
            SizedBox.expand(
              child: AnimatedContainer(
                  // key: ValueKey(controller.value.isPlaying),
                  duration: Duration(milliseconds: 350),
                  child: FittedBox(
                      fit: BoxFit.fill,
                      child: (this.isPlaying == true
                          ? AnimatedOpacity(onEnd: () => print("\n\nend $isPlaying"), opacity: isPlaying == false ? 1.0 : 0.0, duration: const Duration(milliseconds: 300), child: const Icon(Icons.pause, color: Colors.white54))
                          : AnimatedOpacity(opacity: isPlaying == false ? 1.0 : 0.0, duration: const Duration(milliseconds: 300), child: const Icon(Icons.play_arrow, color: Colors.white54))))),
            )
          ],
        )

        // child: Chewie(controller: chewieController),
        );
  }
}

class ThumbGrid extends StatelessWidget {
  final selectedVideoCount;
  final List<dynamic> config;
  final List<String> videoAssets;
  final List<Widget> thumbs;
  final List<VideoPlayerController> controllers;
  List<Device> devices = [];
  dynamic fullscreenView = null;
  StarMenuController starMenuController = StarMenuController();

  VoidCallback saveConfig;
  final Function(Channel, int) videoSelected;

  ThumbGrid({required this.selectedVideoCount, required this.config, required this.videoAssets, required this.saveConfig, required this.thumbs, required this.controllers, required this.devices, required this.fullscreenView, required this.videoSelected});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: selectedVideoCount,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: _itemBuilder,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemBuilder(context, index) {
    print('index $index $thumbs');
    print('videoAssets ${videoAssets} is ${videoAssets.isEmpty ? 'empty' : 'ok'}');
    saveConfig();

    if (index < thumbs.length && thumbs[index] != null) {
      print('itemBuilder true');
      final videoController = controllers[index];
      return thumbs[index];
    } else {
      print('itemBuilder false');
      return GestureDetector(
          onTap: () async {
            print('tapped');

            final channel = Future.delayed(
                Duration.zero,
                () => showDialog<Channel?>(
                    context: context,
                    builder: (context) => AlertDialog(
                        title: const Text('Select channel'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'))
                        ],
                        content: SingleChildScrollView(
                            child: Column(
                                children: devices.length == 0
                                    ? [Text('Could not get list of devices :<')]
                                    : devices[0]
                                        .channels
                                        .map((c) => ListTile(
                                            onTap: () {
                                              Navigator.of(context).pop(c);
                                            },
                                            title: Text(c.name)))
                                        .toList(growable: false))))));
            channel.then((value) {
              print("in thumb $value");
              if (value != null) videoSelected(value, index);
            });
          },
          child: Container(
              color: Colors.black38,
              // child: Text(
              //   'hi ${devices.length}',
              //   style: TextStyle(background: Paint()..color = Colors.white),
              // )
              child: Column(
                children: [
                  Text(
                    'helo',
                    style: TextStyle(background: Paint()..color = Colors.white),
                  ),
                  Icon(Icons.add, color: Colors.grey.shade200, size: 24),
                ],
              )));
    }
  }
}
