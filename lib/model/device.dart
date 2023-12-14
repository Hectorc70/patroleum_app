import 'package:equatable/equatable.dart';
import 'package:patroleum_lib/Device.dart';

class oldDevice extends Equatable {
  const oldDevice(this.name, this.channels);

  final String name;
  final List<Channel> channels;

  @override
  List<Object?> get props => [name, channels];
}

class oldChannel extends Equatable {
  const oldChannel(this.name, this.code);

  final String name;
  final String code;

  @override
  List<Object?> get props => [name, code];
}
