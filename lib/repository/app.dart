import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:patroleum_app/repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';

final _logger = Logger('auth.dart');

// const kRedirectScheme = kDebugMode ? 'patroleum' : 'https';

const _kPrefKeyCredentials = "credentials";

// const _kOAuthProfile =
//     '$kBaseUrl/api/method/frappe.integrations.oauth2.openid_profile';
// const _kOAuth2UrlMethod = '$kBaseUrl/api/method/frappe.integrations.oauth2';
// const _kAuthEndPoint = '$_kOAuth2UrlMethod.authorize';
// const _kTokenEndPoint = '$_kOAuth2UrlMethod.get_token';
// const _kRevokeTokenEndPoint = '$_kOAuth2UrlMethod.revoke_token';
// const _kRedirectUrl = '$kRedirectScheme://erp.patroleum.com/dss_oauth_redirect';
// const _kIdentifier = 'e385f56005';
// const _kSecret = '582d10ce85';

class AppRepository {
  const AppRepository();

  Future<oauth2.Client?> clientFromCredentials() async {
    final credentialsStr =
        (await SharedPreferences.getInstance()).getString(_kPrefKeyCredentials);
    _logger.severe('stored credentials is $credentialsStr');
    if (credentialsStr != null && credentialsStr.isNotEmpty == true) {
      var credentials = oauth2.Credentials.fromJson(credentialsStr);
      _logger.severe('passing stored credentials is $credentialsStr');
      return oauth2.Client(credentials);
    }
    return null;
  }

  Future<oauth2.Client> getClientFromUrl(
      oauth2.AuthorizationCodeGrant grantParam, String url) async {
    final client = await grantParam
        .handleAuthorizationResponse(Uri.parse(url).queryParameters);
    await (await SharedPreferences.getInstance())
        .setString(_kPrefKeyCredentials, client.credentials.toJson());
    _logger.severe("wtf $_kPrefKeyCredentials ${client.credentials.toJson()}");
    // _logger.severe(await client
    //     .get(_kOAuthProfile));
    /* TODO: use OAuth to get user profile data */
    return client;
  }

  // oauth2.AuthorizationCodeGrant get grant => oauth2.AuthorizationCodeGrant(
  //     _kIdentifier, Uri.parse(_kAuthEndPoint), Uri.parse(_kTokenEndPoint),
  //     secret: _kSecret, basicAuth: false);

  // Uri getAuthorizationUrl(oauth2.AuthorizationCodeGrant grant) =>
  //     grant.getAuthorizationUrl(Uri.parse(_kRedirectUrl));

  // Future<void> logout(oauth2.Client client) async {
  //   await client.post(Uri.parse(_kRevokeTokenEndPoint), body: {
  //     'token': client.credentials.refreshToken,
  //     'token_type_hint': 'refresh_token'
  //   });
  //   await (await SharedPreferences.getInstance()).remove(_kPrefKeyCredentials);
  //   client.close();
  // }
}
