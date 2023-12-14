part of 'player_cubit.dart';

class PlayerState extends Equatable {
  const PlayerState._(this.status, [this.uri, this.message]);

  const PlayerState.initial() : this._(Status.initial);

  const PlayerState.success(Uri uri) : this._(Status.success, uri);

  final Status status;
  final Uri? uri;
  final String? message;

  PlayerState copy({
    Status? status,
    Uri? uri,
    String? message,
  }) =>
      PlayerState._(
          status ?? this.status, uri ?? this.uri, message ?? this.message);

  @override
  List<Object?> get props => [status, uri, message];
}
