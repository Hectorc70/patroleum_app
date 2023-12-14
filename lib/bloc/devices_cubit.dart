import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

// import 'package:video_player_android/model/model.dart';
// import 'package:video_player_android/repository/repository.dart';
import 'package:patroleum_lib/patroleum_lib.dart';
import 'package:patroleum_lib/Device.dart';
import 'status.dart';

part 'devices_state.dart';

class DevicesCubit extends Cubit<DevicesState> {
  DevicesCubit(this._repository,
      {DevicesState initialState = const DevicesState.initial()})
      : super(initialState) {
    getDevices();
  }

  ERPClient _repository = ERPClient();

  // final DevicesRepository _repository;

  final Logger _logger = Logger('DevicesCubit');

  Future<void> getDevices() async {
    emit(state.copy(status: Status.loading));
    try {
      emit(DevicesState.success(await _repository.getDevices()));
    } catch (e, s) {
      _logger.severe('Error in getDevices', e, s);
      emit(state.copy(
          status: Status.error,
          message: e is HttpException ? e.message : null));
    }
  }
}
