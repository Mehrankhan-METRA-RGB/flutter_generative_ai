// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatModelAdapter extends TypeAdapter<ChatModel> {
  @override
  final int typeId = 1;

  @override
  ChatModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatModel(
      index: fields[1] as int?,
      type: fields[2] as String?,
      content: (fields[3] as List?)?.cast<ChatContent>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.index)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatContentAdapter extends TypeAdapter<ChatContent> {
  @override
  final int typeId = 2;

  @override
  ChatContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatContent(
      contentPart: fields[1] as String?,
      data: (fields[2] as List?)?.cast<DataPart>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatContent obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.contentPart)
      ..writeByte(2)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PartDataAdapter extends TypeAdapter<PartData> {
  @override
  final int typeId = 3;

  @override
  PartData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PartData(
      text: fields[1] as String?,
      uri: fields[2] as Uri?,
      bytes: fields[3] as Uint8List?,
      mimeType: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PartData obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.uri)
      ..writeByte(3)
      ..write(obj.bytes)
      ..writeByte(4)
      ..write(obj.mimeType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
