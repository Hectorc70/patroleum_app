import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
// import 'package:patroleum_app/repository/repository.dart';
import 'package:patroleum_lib/patroleum_lib.dart';
import 'package:patroleum_lib/Device.dart';
import 'status.dart';

part 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  // PlayerCubit(this._channelCode, this._repository,
  PlayerCubit(this._channelCode, // List<Device> devices,
      {PlayerState initialState = const PlayerState.initial()})
      : super(initialState) {
    // _devices = devices;
    getVideoUrl();
  }

  final String _channelCode;
  // List<Device> _devices = List.empty();

  final Logger _logger = Logger('PlayerCubit');

  Future<void> getVideoUrl() async {
    emit(state.copy(status: Status.loading));
    try {
      final uri = await ERPClient().getVideoUrl(_channelCode);
      if (uri != null) {
        _logger.info(uri.toString());
        emit(PlayerState.success(uri));
      } else {
        emit(state.copy(
            status: Status.error, message: 'Failed to get video url'));
      }
    } catch (e, s) {
      _logger.severe(
          e is HttpException ? e.message : 'Error in getVideoUrl', e, s);
      emit(
          state.copy(status: Status.error, message: 'Failed to get video url'));
    }
  }
}
