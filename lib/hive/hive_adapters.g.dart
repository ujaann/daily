// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class ExpenseEntityAdapter extends TypeAdapter<ExpenseEntity> {
  @override
  final typeId = 0;

  @override
  ExpenseEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseEntity(
      amount: (fields[1] as num).toDouble(),
      category: fields[2] as String,
      date: fields[3] as DateTime,
      type: fields[0] as ExpenseType,
      userId: fields[4] as String,
      note: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(6)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExpenseTypeAdapter extends TypeAdapter<ExpenseType> {
  @override
  final typeId = 2;

  @override
  ExpenseType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExpenseType.expense;
      case 1:
        return ExpenseType.income;
      default:
        return ExpenseType.expense;
    }
  }

  @override
  void write(BinaryWriter writer, ExpenseType obj) {
    switch (obj) {
      case ExpenseType.expense:
        writer.writeByte(0);
      case ExpenseType.income:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventEntityAdapter extends TypeAdapter<EventEntity> {
  @override
  final typeId = 3;

  @override
  EventEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventEntity(
      description: fields[6] as String,
      repeatFrequency: fields[8] as RepeatFrequency?,
      occurrences: (fields[9] as num?)?.toInt(),
      endDate: fields[10] as DateTime?,
      title: fields[2] as String,
      date: fields[3] as DateTime,
      startTime: fields[4] as DateTime,
      endTime: fields[5] as DateTime,
      userId: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EventEntity obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.endTime)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.repeatFrequency)
      ..writeByte(9)
      ..write(obj.occurrences)
      ..writeByte(10)
      ..write(obj.endDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserEntityAdapter extends TypeAdapter<UserEntity> {
  @override
  final typeId = 7;

  @override
  UserEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserEntity(
      username: fields[0] as String,
      email: fields[1] as String,
      password: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AuthEntityAdapter extends TypeAdapter<AuthEntity> {
  @override
  final typeId = 8;

  @override
  AuthEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthEntity(
      username: fields[0] as String,
      rememberMe: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AuthEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.rememberMe);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RepeatFrequencyAdapter extends TypeAdapter<RepeatFrequency> {
  @override
  final typeId = 6;

  @override
  RepeatFrequency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RepeatFrequency.doNotRepeat;
      case 1:
        return RepeatFrequency.daily;
      case 2:
        return RepeatFrequency.weekly;
      case 3:
        return RepeatFrequency.monthly;
      case 4:
        return RepeatFrequency.yearly;
      default:
        return RepeatFrequency.doNotRepeat;
    }
  }

  @override
  void write(BinaryWriter writer, RepeatFrequency obj) {
    switch (obj) {
      case RepeatFrequency.doNotRepeat:
        writer.writeByte(0);
      case RepeatFrequency.daily:
        writer.writeByte(1);
      case RepeatFrequency.weekly:
        writer.writeByte(2);
      case RepeatFrequency.monthly:
        writer.writeByte(3);
      case RepeatFrequency.yearly:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepeatFrequencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
