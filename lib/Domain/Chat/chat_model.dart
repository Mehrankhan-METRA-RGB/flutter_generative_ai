import 'dart:convert';
import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive/hive.dart';

part 'chat_model.g.dart';

@HiveType(typeId: 1)
class ChatModel {
  @HiveField(1)
  final int? index;
  @HiveField(2)
  final String? type;
  @HiveField(3)
  final List<ChatContent>? content;

  ChatModel({
    this.index,
    this.type,
    this.content,
  });

  ChatModel copyWith({
    int? index,
    String? type,
    List<ChatContent>? content,
  }) =>
      ChatModel(
        index: index ?? this.index,
        type: type ?? this.type,
        content: content ?? this.content,
      );

  factory ChatModel.fromRawJson(String str) =>
      ChatModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        index: json["index"],
        type: json["type"],
        content: json["content"] == null
            ? []
            : List<ChatContent>.from(
                json["content"]!.map((x) => ChatContent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "type": type,
        "content": content == null
            ? []
            : List<ChatContent>.from(content!.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 2)
class ChatContent {
  @HiveField(1)
  final String? contentPart;
  @HiveField(2)
  final List<DataPart>? data;

  ChatContent({
    this.contentPart,
    this.data,
  });

  ChatContent copyWith({
    String? contentPart,
    List<DataPart>? data,
  }) =>
      ChatContent(
        contentPart: contentPart ?? this.contentPart,
        data: data ?? this.data,
      );

  factory ChatContent.fromRawJson(String str) =>
      ChatContent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatContent.fromJson(Map<String, dynamic> json) => ChatContent(
      contentPart: json["part"],
      data: json["data"] == null
          ? List<DataPart>.from(json["data"]!.map((x) => PartData.fromJson(x)))
          : []

      // json["data"],
      );

  Map<String, dynamic> toJson() => {
        "part": contentPart,
        "data": data != null
            ? List<DataPart>.from(data!.map((x) => x.toJson()))
            : [],
      };
}

@HiveType(typeId: 3)
class PartData {
  @HiveField(1)
  final String? text;
  @HiveField(2)
  final Uri? uri;
  @HiveField(3)
  final Uint8List? bytes;
  @HiveField(4)
  final String? mimeType;

  PartData({
    this.text,
    this.uri,
    this.bytes,
    this.mimeType,
  });

  Map<String, dynamic> toJson() => {
        "text": text,
        "uri": uri?.path,
        "bytes": bytes != null ? base64Encode(bytes!) : null,
        "mimeType": mimeType
      };

  factory PartData.fromJson(Map<String, dynamic> json) => PartData(
      text: json["text"],
      uri: json["uri"] != null ? Uri.parse(json["uri"]) : null,
      bytes: json["bytes"] != null ? base64Decode(json["bytes"]) : null,
      mimeType: json["mimeType"]);

  factory PartData.fromRawJson(String str) =>
      PartData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}
