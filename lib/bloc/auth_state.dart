part of 'auth_cubit.dart';

class AuthState extends Equatable {
  const AuthState._(
      {this.grant, this.authUri, this.client, this.usr, this.pwd});

  const AuthState.initial(
      oauth2.AuthorizationCodeGrant grant, String? usr, String? pwd)
      : this._(grant: grant, usr: usr, pwd: pwd);

  const AuthState.loading(oauth2.AuthorizationCodeGrant grant, Uri authUri)
      : this._(grant: grant, authUri: authUri);

  const AuthState.finished(oauth2.Client client) : this._(client: client);

  const AuthState.setCredential(String? usr, String? pwd)
      : this._(usr: usr, pwd: pwd);

  final oauth2.AuthorizationCodeGrant? grant;
  final Uri? authUri;
  final oauth2.Client? client;

  final String? usr;
  final String? pwd;

  get isInitial => grant != null && authUri == null;

  get isLoading => authUri != null && authUri != null;

  get isFinished => (client != null) || (usr != null && pwd != null);

  @override
  List<Object?> get props => [grant, authUri, client, usr, pwd];
}
