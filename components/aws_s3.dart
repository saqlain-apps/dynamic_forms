import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AWSS3 {
  const AWSS3({
    required this.accessKey,
    required this.secretKey,
    required this.region,
    required this.endPoint,
    required this.bucket,
  });

  final String accessKey;
  final String secretKey;
  final String region;
  final String endPoint;
  final String bucket;

  Future<String?> upload(Uint8List data, String name) async {
    var fileName = checkFileName(name);
    var req = createRequest(endPoint);
    var multipartFile = createRequestData(data, fileName);
    req.files.add(multipartFile);

    var policy = generatePolicy(name, data.length);
    var signature = signingKey(policy);
    addHeaders(req, policy, signature);

    try {
      await req.send();
      return '$endPoint/$fileName';
    } catch (e) {
      rethrow;
    }
  }

  String checkFileName(String name) {
    return name.replaceAll(' ', '_');
  }

  http.MultipartRequest createRequest(String endPoint) {
    final uri = Uri.parse(endPoint);
    final req = http.MultipartRequest('POST', uri);
    return req;
  }

  http.MultipartFile createRequestData(Uint8List data, String fileName) {
    var multipartFile = http.MultipartFile(
      'file',
      http.ByteStream.fromBytes(data),
      data.length,
      filename: fileName,
    );

    return multipartFile;
  }

  Policy generatePolicy(String name, int length) {
    final policy = Policy.fromS3PresignedPost(
      key: name,
      bucket: bucket,
      accessKey: accessKey,
      expiryMinutes: 15,
      maxFileSize: length,
      region: region,
    );

    return policy;
  }

  String signingKey(Policy policy) {
    var key = SigV4.calculateSigningKey(
      secretKey,
      policy.datetime,
      region,
      's3',
    );
    var signature = SigV4.calculateSignature(key, policy.encode());

    return signature;
  }

  void addHeaders(
    http.MultipartRequest req,
    Policy policy,
    String signature,
  ) {
    req.fields['key'] = policy.key;
    req.fields['acl'] = 'public-read';
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;
  }
}

class Policy {
  String expiration;
  String region;
  String bucket;
  String key;
  String credential;
  String datetime;
  int maxFileSize;

  Policy({
    required this.key,
    required this.bucket,
    required this.datetime,
    required this.expiration,
    required this.credential,
    required this.maxFileSize,
    required this.region,
  });

  factory Policy.fromS3PresignedPost({
    required String key,
    required String bucket,
    required String accessKey,
    required int expiryMinutes,
    required int maxFileSize,
    required String region,
  }) {
    final datetime = SigV4.generateDatetime();
    final expiration = (DateTime.now())
        .add(Duration(minutes: expiryMinutes))
        .toUtc()
        .toString()
        .split(' ')
        .join('T');

    final cred =
        '$accessKey/${SigV4.buildCredentialScope(datetime, region, 's3')}';

    final p = Policy(
      key: key,
      bucket: bucket,
      datetime: datetime,
      expiration: expiration,
      credential: cred,
      maxFileSize: maxFileSize,
      region: region,
    );

    return p;
  }

  String encode() {
    final bytes = utf8.encode(toString());
    return base64.encode(bytes);
  }

  @override
  String toString() {
    return '''
{ "expiration": "$expiration",
  "conditions": [
    {"bucket": "$bucket"},
    ["starts-with", "\$key", "$key"],
    {"acl": "public-read"},
    ["content-length-range", 1, $maxFileSize],
    {"x-amz-credential": "$credential"},
    {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
    {"x-amz-date": "$datetime" }
  ]
}
''';
  }
}
