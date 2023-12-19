part of 'auth_cubit.dart';

class AuthState extends Equatable {
  const AuthState._(
      {this.grant,
      this.authUri,
      this.client,
      this.usr,
      this.pwd,
      this.isLoadingSplash});
  const AuthState.initial(oauth2.AuthorizationCodeGrant grant, String? usr,
      String? pwd, bool? isLoadingSplash)
      : this._(
          grant: grant,
          usr: usr,
          pwd: pwd,
          isLoadingSplash: true, // Establecer el valor predeterminado aquí
        );

  // const AuthState.initial(
  //     oauth2.AuthorizationCodeGrant grant, String? usr, String? pwd)
  //     : this._(grant: grant, usr: usr, pwd: pwd);

  const AuthState.loading(oauth2.AuthorizationCodeGrant grant, Uri authUri)
      : this._(grant: grant, authUri: authUri);

  const AuthState.finished(oauth2.Client client) : this._(client: client);

  const AuthState.setCredential(String? usr, String? pwd, bool? isLoading)
      : this._(usr: usr, pwd: pwd, isLoadingSplash: isLoading);
  const AuthState.setLoadingSplash(bool isLoadingSplash)
      : this._(isLoadingSplash: isLoadingSplash);
  final oauth2.AuthorizationCodeGrant? grant;
  final Uri? authUri;
  final oauth2.Client? client;

  final String? usr;
  final String? pwd;
  final bool? isLoadingSplash;

  get isInitial => grant != null && authUri == null;

  get isLoading => authUri != null && authUri != null;
  get getIsLoadingSplash => isLoadingSplash ?? false;

  get isFinished => (client != null) || (usr != null && pwd != null);

  @override
  List<Object?> get props => [grant, authUri, client, usr, pwd, isLoadingSplash];
}
