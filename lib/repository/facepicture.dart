import 'dart:convert';

import 'package:oauth2/oauth2.dart';

import 'package:patroleum_app/model/model.dart';
import 'package:patroleum_app/repository/repository.dart';
import 'package:patroleum_lib/Device.dart';
import 'package:patroleum_lib/patroleum_lib.dart';

const _kDssSettingsPath =
    '$kBaseUrl/api/method/patroleum_dss.patroleum_dss.doctype.dss_settings.dss_settings';

class DevicesRepository {
  const DevicesRepository(this._client);

  final Client _client;

  Future<List<Device>> getDevices() async {
    final response =
        await _client.get(Uri.parse('$_kDssSettingsPath.get_dss_devices'));
    final json = ((jsonDecode(response.body)
        as Map<String, dynamic>?)?['message'] as Map<String, dynamic>?);
    if (json == null || json['code'] != 1000 || !json.containsKey('data')) {
      return const [];
    }

    return ((json['data'] as Map<String, dynamic>)['devices'] as List<dynamic>?)
            ?.where((d) => d != null && d is Map<String, dynamic>)
            .map((d) {
          final device = d as Map<String, dynamic>;
          return Device(
              (device['name'] as String?) ?? '',
              (device['units'] as List<dynamic>?)
                      ?.where((u) =>
                          u != null &&
                          u is Map<String, dynamic> &&
                          u['unitType'] == '1') //1 = Coding unit (encoder)
                      .expand((u) {
                    final unit = u as Map<String, dynamic>;
                    return (unit['channels'] as List<dynamic>?)
                            ?.where(
                                (c) => c != null && c is Map<String, dynamic>)
                            .map((c) {
                          final channel = c as Map<String, dynamic>;
                          return Channel(
                              (channel['channelName'] as String?) ?? '',
                              (channel['channelCode'] as String?) ?? '');
                        }).toList(growable: false) ??
                        const <Channel>[];
                  }).toList(growable: false) ??
                  const []);
        }).toList(growable: false) ??
        const [];
  }

  Future<Uri?> getVideoUrl(String channelCode) async {
    final response = await _client.get(
        Uri.parse('$_kDssSettingsPath.get_video_url')
            .replace(queryParameters: {'channelId': channelCode}));
    final json = ((jsonDecode(response.body)
        as Map<String, dynamic>?)?['message'] as Map<String, dynamic>?);
    if (json == null || json['code'] != 1000 || !json.containsKey('data')) {
      return null;
    }

    final data = json['data'] as Map<String, dynamic>?;
    if (data == null) return null;

    final url = data['url'] as String?;
    final token = data['token'] as String?;
    if (url == null || url == '' || token == null || token == '') {
      return null;
    }
    return Uri.parse(url).replace(queryParameters: {'token': token});
  }
}
