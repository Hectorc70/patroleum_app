import 'package:equatable/equatable.dart';

class LoginFormData extends Equatable {
  final String usr;
  final String pwd;

  const LoginFormData({required this.usr, required this.pwd});

  @override
  List<Object?> get props => [usr, pwd];
}
