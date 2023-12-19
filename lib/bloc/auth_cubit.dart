import 'dart:core';

import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
// import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:equatable/equatable.dart';
import 'package:patroleum_app/common/constants.dart';
// import 'package:video_player_android/bloc/home_cubit.dart';
import 'package:patroleum_app/repository/repository.dart';

// import 'package:dio/dio.dart';
import 'package:patroleum_lib/patroleum_lib.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit._(AuthState initialState, this._repository) : super(initialState) {
    _getLoggedIn();
  }

  factory AuthCubit({AppRepository repository = const AppRepository()}) {
    return AuthCubit._(
        // AuthState.initial(repository.grant, null, null), repository);
        AuthState.initial(
            oauth2.AuthorizationCodeGrant('', Uri(), Uri()), null, null, true),
        repository);
  }

  final AppRepository _repository;
  final _logger = Logger('AuthCubit');

  Future<void> _getLoggedIn() async {
    emit(AuthState.setLoadingSplash(true));

    final client = await _repository.clientFromCredentials();
    if (client != null) {
      emit(AuthState.finished(client));
      emit(AuthState.setLoadingSplash(false));
    } else {
      String? pass;
      String? user;
      bool? isAuth;

      SharedPreferences.getInstance().then((p) async {
        isAuth = p.getBool(
          prefUserCredential,
        );
        pass = p.getString(prefUserPassCredential);
        user = p.getString(prefUserNameCredential);
        if (isAuth != null && isAuth!) {
          // emit(AuthState.setCredential(null, null, true));

          await CredentialLogin(user.toString(), pass.toString());
        } else {
          emit(AuthState.setCredential(null, null, false));
        }
      });
    }
    // print('Holaaaa');

    // emit(AuthState.setLoadingSplash(false));
  }

  Future<String> CredentialLogin(String usr, String pwd) async {
    ERPClient client = ERPClient();
    print('whatsgoinon');
    return await client.login(usr, pwd).then((value) {
      if (client.authenticated == true) {
        emit(AuthState.setCredential(usr, pwd, false));

        savePrefsAuthUser(isAuth: true, password: pwd, user: usr);
      } else {
        emit(AuthState.setLoadingSplash(false));
        print("not auth");
        savePrefsAuthUser(isAuth: false, password: '', user: '');

        // notify error in state ?
        // emit()
      }
      return value;
    });
  }

  Future<void> savePrefsAuthUser(
      {required bool isAuth,
      required String password,
      required String user}) async {
    if (isAuth) {
      SharedPreferences.getInstance().then((p) {
        p.setBool(prefUserCredential, isAuth);
        p.setString(prefUserNameCredential, user);
        p.setString(prefUserPassCredential, password);
      });
    } else {
      SharedPreferences.getInstance().then((p) {
        p.setBool(prefUserCredential, isAuth);
        p.setString(prefUserNameCredential, '');
        p.setString(prefUserPassCredential, '');
      });
    }
  }

  void setCredential(String usr, String pwd) {
    emit(AuthState.setCredential(usr, pwd, false));
  }

  Future<void> login() async {
    final state = this.state;
    Uri uri;
    oauth2.AuthorizationCodeGrant grant;
    _logger.severe('start login');

    if (state.isLoading) {
      uri = state.authUri!;
      grant = state.grant!;
    } else if (state.isInitial) {
      grant = state.grant!;
      // uri = _repository.getAuthorizationUrl(grant);
      emit(AuthState.loading(grant, Uri.parse('www.google.com')));
    } else {
      //should never happen
      throw StateError('Already logged in.');
    }

    // try {
    //   final url = await FlutterWebAuth2.authenticate(
    //       url: uri.toString(),
    //       callbackUrlScheme: kRedirectScheme,
    //       options: const FlutterWebAuth2Options(
    //           preferEphemeral: true, intentFlags: ephemeralIntentFlags));
    //   emit(AuthState.finished(await _repository.getClientFromUrl(grant, url)));
    //   _logger.severe(grant, url);
    // } on Exception catch (e, s) {
    //   _logger.severe('Error in login', e, s);
    // }
  }

  Future<void> logout() async {
    // final state = this.state;
    if (state.isFinished) {
      emit(AuthState.setCredential(null, null, false));
      savePrefsAuthUser(isAuth: false, password: '', user: '');
      // if (state.client != null) await _repository.logout(state.client!);
      // emit(AuthState.initial(_repository.grant, null, null));
    }
  }
}
