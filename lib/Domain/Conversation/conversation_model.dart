import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class ConversationModel {
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final String name;
  ConversationModel({
    this.title,
    required this.name,
  });

  ConversationModel copyWidth(String? title) =>
      ConversationModel(title: title ?? this.title, name: name);

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(name: json['name'], title: json['title']);
}
