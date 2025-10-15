import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/asn1/primitives/asn1_bit_string.dart';
import 'package:pointycastle/asn1/primitives/asn1_integer.dart';
import 'package:pointycastle/asn1/primitives/asn1_null.dart';
import 'package:pointycastle/asn1/primitives/asn1_object_identifier.dart';
import 'package:pointycastle/asn1/primitives/asn1_sequence.dart';
import 'package:pointycastle/asymmetric/api.dart';

String encodePublicKeyToPem(RSAPublicKey publicKey) {
  final algorithmSeq = ASN1Sequence()
    ..add(ASN1ObjectIdentifier.fromName('rsaEncryption'))
    ..add(ASN1Null());

  final publicKeySeq = ASN1Sequence()
    ..add(ASN1Integer(publicKey.modulus!))
    ..add(ASN1Integer(publicKey.exponent!));

  final publicKeyBitString = ASN1BitString(
    stringValues: Uint8List.fromList(publicKeySeq.encode()),
  );

  final topLevelSeq = ASN1Sequence()
    ..add(algorithmSeq)
    ..add(publicKeyBitString);

  final base64PubKey = base64Encode(topLevelSeq.encode());
  return '-----BEGIN PUBLIC KEY-----\n$base64PubKey\n-----END PUBLIC KEY-----';
}

String encodePrivateKeyToPem(RSAPrivateKey privateKey) {
  final version = ASN1Integer(BigInt.from(0));
  final modulus = ASN1Integer(privateKey.n!);
  final publicExponent = ASN1Integer(BigInt.parse('65537'));
  final privateExponent = ASN1Integer(privateKey.exponent!);
  final p = ASN1Integer(privateKey.p!);
  final q = ASN1Integer(privateKey.q!);
  final dP = ASN1Integer(privateKey.exponent! % (privateKey.p! - BigInt.one));
  final dQ = ASN1Integer(privateKey.exponent! % (privateKey.q! - BigInt.one));
  final qInv = ASN1Integer(privateKey.q!.modInverse(privateKey.p!));

  final seq = ASN1Sequence()
    ..add(version)
    ..add(modulus)
    ..add(publicExponent)
    ..add(privateExponent)
    ..add(p)
    ..add(q)
    ..add(dP)
    ..add(dQ)
    ..add(qInv);

  final base64PrivKey = base64Encode(seq.encode());
  return '-----BEGIN PRIVATE KEY-----\n$base64PrivKey\n-----END PRIVATE KEY-----';
}
