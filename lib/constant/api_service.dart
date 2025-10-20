import 'package:flutter/foundation.dart';

class APIService {
  static String baseUrl = kDebugMode
      ? 'http://172.25.0.133:3000/api'
      : (kProfileMode ? 'prod' : 'prod');
  static String socketUrl = kDebugMode
      ? 'http://172.25.0.133:3000/'
      : (kProfileMode ? 'prod' : 'prod');
}
