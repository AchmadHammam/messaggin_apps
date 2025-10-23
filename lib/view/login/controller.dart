import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:messaging_application/constant/api_service.dart';
import 'package:messaging_application/helper/helper.dart';
import 'package:messaging_application/model/login.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  final storage = FlutterSecureStorage();

  Future<bool> login({required String email, required String password}) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    var url = Uri.parse('${APIService.baseUrl}/auth/login');
    try {
      EasyLoading.showInfo('Loading...');
      final secureRandom = FortunaRandom();
      final random = Random.secure();
      final seeds = List.generate(32, (_) => random.nextInt(255));
      secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

      final keyGen = RSAKeyGenerator()
        ..init(
          ParametersWithRandom(
            RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
            secureRandom,
          ),
        );
      final pair = keyGen.generateKeyPair();
      final publicKey = pair.publicKey;
      final privateKey = pair.privateKey;
      // Convert ke base64 agar mudah disimpan
      final pubKeyPem = encodePublicKeyToPem(publicKey);
      final privKeyPem = encodePrivateKeyToPem(privateKey);

      // Simpan ke secure storage
      await storage.write(key: 'publicKey', value: pubKeyPem);
      await storage.write(key: 'privateKey', value: privKeyPem);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password, 'public_key': pubKeyPem}),
      );
      final json = jsonDecode(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = LoginResponse.fromJson(json);
        print(data.data.user.id);
        prefs.setString('token', data.data.token);
        prefs.setInt('userId', data.data.user.id);
        return true;
      } else {
        EasyLoading.showError(json['message']);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }
}
