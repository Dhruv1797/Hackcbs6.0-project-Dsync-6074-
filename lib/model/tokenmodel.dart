// To parse this JSON data, do
//
//     final accessToken = accessTokenFromJson(jsonString);

import 'dart:convert';

AccessToken accessTokenFromJson(String str) =>
    AccessToken.fromJson(json.decode(str));

String accessTokenToJson(AccessToken data) => json.encode(data.toJson());

class AccessToken {
  String accessToken;

  AccessToken({
    required this.accessToken,
  });

  factory AccessToken.fromJson(Map<String, dynamic> json) => AccessToken(
        accessToken: json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
      };
}
