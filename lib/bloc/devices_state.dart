part of 'devices_cubit.dart';

class DevicesState extends Equatable {
  const DevicesState._(this.status, [this.devices = const [], this.message]);

  const DevicesState.initial() : this._(Status.initial);

  const DevicesState.success(List<Device> devices)
      : this._(Status.success, devices);

  final Status status;
  final List<Device> devices;
  final String? message;

  DevicesState copy({
    Status? status,
    List<Device>? devices,
    String? message,
  }) =>
      DevicesState._(status ?? this.status, devices ?? this.devices,
          message ?? this.message);

  @override
  List<Object?> get props => [status, devices, message];
}
