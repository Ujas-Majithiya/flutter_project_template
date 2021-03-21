import 'dart:async';

import 'package:dio/dio.dart';

import '../utils/network_utils.dart';
import '../utils/shared_preferences_helper.dart';

// ignore_for_file: omit_local_variable_types
class HeaderInterceptor extends Interceptor {
  final bool showLogs;

  HeaderInterceptor({this.showLogs = true});

  @override
  Future<dynamic> onRequest(RequestOptions options) async {
    var internet = await NetworkUtils().checkIsInternet();
    if (internet != null && internet) {
      final token = await checkToken();
      if (token != null && token.isNotEmpty) {
        options.headers.putIfAbsent('Authorization', () => '$token');
      }
      return options;
    } else {
      ///TODO:- Show no internet dialog or toast here.
      return null;
    }
  }

  @override
  Future<dynamic> onResponse(Response options) async {
    if (options.statusCode == 401) {
      ///TODO:- Handle token expired
      return options;
    }
    return options;
  }

  @override
  Future<DioError> onError(DioError dioError) {
    return dioError.error;
  }

  Future<String> checkToken() async {
    return await SharedPreferencesHelper.instance.getAuthToken();
  }
}
