import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class RecordingVC extends StatefulWidget {
  const RecordingVC({super.key});

  @override
  State<RecordingVC> createState() => _RecordingVCState();
}

class _RecordingVCState extends State<RecordingVC> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  double _positionCircleLeft = 0.0;
  int tapCount = 0;
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  int selectedItemIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
        'assets/videos/Tom_And_Jerry_-_Polka_Dot_Puss_Part_1-590329.mp4')
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.addListener(() {
      setState(() {
        _isPlaying = !_controller.value.isPlaying;
        final videoDuration = _controller.value.duration.inMilliseconds;
        final videoPosition = _controller.value.position.inMilliseconds;
        _positionCircleLeft = (videoPosition / videoDuration) * 100.0;
      });
      // selectedStartDate = _getCurrentFormattedDate();
      // selectedEndDate = _getCurrentFormattedDate();
    });
  }
  // String _getCurrentFormattedDate() {
  //   final now = DateTime.now();
  //   final formattedDate = '${now.day}/${now.month}/${now.year}';
  //   return formattedDate;
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      _isPlaying = !_controller.value.isPlaying;
    });
  }

  void _seek(bool forward) {
    final currentPosition = _controller.value.position;
    int seekDurationInSeconds = 20;
    if (tapCount == 1) {
      seekDurationInSeconds = 10;
    } else if (tapCount == 2) {
      // seekDurationInSeconds = 40;
    }

    final seekDuration = Duration(seconds: seekDurationInSeconds);
    tapCount = 0;

    final newPosition = forward
        ? currentPosition + seekDuration
        : currentPosition - seekDuration;
    _controller.seekTo(newPosition);
  }

  DateTime currentTime = DateTime.now();
  int startMinuteCount = 0;
  int endMinuteCount = 0;

  void increaseStartMinuteCount() {
    setState(() {
      startMinuteCount++;
    });
  }

  void decreaseStartMinuteCount() {
    setState(() {
      startMinuteCount--;
    });
  }

  void increaseEndMinuteCount() {
    setState(() {
      endMinuteCount++;
    });
  }

  void decreaseEndMinuteCount() {
    setState(() {
      endMinuteCount--;
    });
  }

  String selectedStartDate = '';
  String selectedEndDate = '';
  int startDayIndex = -1;
  int endDayIndex = -1;

  @override
  Widget build(BuildContext context) {
    DateTime updatedStartTime =
        currentTime.add(Duration(minutes: startMinuteCount));
    String formattedStartTime =
        '${updatedStartTime.hour}:${updatedStartTime.minute.toString().padLeft(2, '0')}';

    DateTime updatedEndTime =
        currentTime.add(Duration(minutes: endMinuteCount));
    String formattedEndTime =
        '${updatedEndTime.hour}:${updatedEndTime.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_left_outlined,
                    color: Colors.grey,
                    size: 40,
                  ),
                  Text(
                    'Back',
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              child: Center(
                child: _controller.value.isInitialized
                    ? Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: _playPause,
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    tapCount = (tapCount + 1) % 3;
                                    _seek(false);
                                  },
                                  onDoubleTap: () {
                                    tapCount = 0;
                                    _seek(false);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                            Icons
                                                .keyboard_double_arrow_left_outlined,
                                            size: 14),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'x2 x4 x8',
                                          style: TextStyle(fontSize: 8),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    tapCount = (tapCount + 1) % 3;
                                    _seek(true);
                                  },
                                  onDoubleTap: () {
                                    tapCount = 0;
                                    _seek(true);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                            Icons
                                                .keyboard_double_arrow_right_outlined,
                                            size: 14),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'x2 x4 x8',
                                          style: TextStyle(fontSize: 8),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 40,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.skip_next_outlined,
                                            size: 14),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'next frame',
                                          style: TextStyle(fontSize: 8),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 40,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.skip_previous_outlined,
                                            size: 14),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'prev frame',
                                          style: TextStyle(fontSize: 8),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                  ),
                                  child: IconButton(
                                    icon: Icon(_isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow),
                                    onPressed: _playPause,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              Container(
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: VideoProgressIndicator(
                                    _controller,
                                    allowScrubbing: true,
                                    colors: VideoProgressColors(
                                      playedColor: Colors.red,
                                      bufferedColor: Colors.grey.shade400,
                                      backgroundColor: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      _controller.value.position
                                          .toString()
                                          .split('.')
                                          .first,
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        _controller.value.position
                                            .toString()
                                            .split('.')
                                            .first,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Text(
                                        _controller.value.duration
                                            .toString()
                                            .split('.')
                                            .first,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30, left: 30, right: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Start of Video',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                    Text('Date: $selectedStartDate',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                    Text('Time: $formattedStartTime',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('End of Video',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                    Text('Date: $selectedEndDate',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                    Text('Time: $formattedEndTime',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.shade400,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: List.generate(365, (day) {
                                          int month = (day ~/ 31) + 1;
                                          int date = (day % 31) + 1;
                                          String monthName = '';
                                          String monthint = '';
                                          String year = '2023';
                                          switch (month) {
                                            case 1:
                                              monthName = 'January';
                                              monthint = '01';
                                              break;
                                            case 2:
                                              monthName = 'February';
                                              monthint = '02';
                                              break;
                                            case 3:
                                              monthName = 'March';
                                              monthint = '03';
                                              break;
                                            case 4:
                                              monthName = 'April';
                                              monthint = '04';
                                              break;
                                            case 5:
                                              monthName = 'May';
                                              monthint = '05';
                                              break;
                                            case 6:
                                              monthName = 'June';
                                              monthint = '06';
                                              break;
                                            case 7:
                                              monthName = 'July';
                                              monthint = '07';
                                              break;
                                            case 8:
                                              monthName = 'August';
                                              monthint = '08';
                                              break;
                                            case 9:
                                              monthName = 'September';
                                              monthint = '09';
                                              break;
                                            case 10:
                                              monthName = 'October';
                                              monthint = '10';
                                              break;
                                            case 11:
                                              monthName = 'November';
                                              monthint = '11';
                                              break;
                                            case 12:
                                              monthName = 'December';
                                              monthint = '12';
                                              break;
                                          }
                                          return Stack(
                                            children: [
                                              Container(
                                                height: 73,
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          if (selectedItemIndex ==
                                                              day) {
                                                            // Deselect the selected item
                                                            selectedItemIndex =
                                                                -1;
                                                            selectedStartDate =
                                                                '';
                                                            selectedEndDate =
                                                                '';
                                                          } else if (startDayIndex ==
                                                              -1) {
                                                            startDayIndex = day;
                                                            selectedStartDate =
                                                                '$date/ $monthint/ $year';
                                                          } else if (endDayIndex ==
                                                              -1) {
                                                            endDayIndex = day;
                                                            selectedEndDate =
                                                                '$date/ $monthint/ $year';
                                                          } else {
                                                            startDayIndex = day;
                                                            endDayIndex = -1;
                                                            selectedStartDate =
                                                                '$date/ $monthint/ $year';
                                                            selectedEndDate =
                                                                '$date/ $monthint/ $year';
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: selectedStartDate ==
                                                                  '$date/ $monthint/ $year'
                                                              ? Colors.green
                                                                  .shade400
                                                              : (selectedEndDate ==
                                                                      '$date/ $monthint/ $year'
                                                                  ? Colors.green
                                                                      .shade400
                                                                  : Colors
                                                                      .white),
                                                        ),
                                                        child: Center(
                                                            child: Text('$date'
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0'))),
                                                      ),
                                                    ),
                                                    SizedBox(width: 15),
                                                  ],
                                                ),
                                              ),
                                              if (date == 1)
                                                Positioned(
                                                    top: 0,
                                                    child: Text(monthName,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ))),
                                            ],
                                          );
                                        }),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Text('Start Time'),
                                        )),
                                        SizedBox(width: 35),
                                        Expanded(
                                            child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Text('End Time'),
                                        )),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 42,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15),
                                                  child:
                                                      Text(formattedStartTime),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () =>
                                                            increaseStartMinuteCount(),
                                                        child: Icon(
                                                            Icons.arrow_drop_up,
                                                            size: 20),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () =>
                                                            decreaseStartMinuteCount(),
                                                        child: Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            size: 20),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 45),
                                        Expanded(
                                          child: Container(
                                            height: 42,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15),
                                                  child: Text(formattedEndTime),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () =>
                                                            increaseEndMinuteCount(),
                                                        child: Icon(
                                                            Icons.arrow_drop_up,
                                                            size: 20),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () =>
                                                            decreaseEndMinuteCount(),
                                                        child: Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            size: 20),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
