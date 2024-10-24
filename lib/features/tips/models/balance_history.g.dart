// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BalanceHistoryAdapter extends TypeAdapter<BalanceHistory> {
  @override
  final int typeId = 13;

  @override
  BalanceHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BalanceHistory(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      amount: fields[2] as double,
      description: fields[3] as String,
      type: fields[4] as BalanceHistoryType,
    );
  }

  @override
  void write(BinaryWriter writer, BalanceHistory obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalanceHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BalanceHistoryTypeAdapter extends TypeAdapter<BalanceHistoryType> {
  @override
  final int typeId = 14;

  @override
  BalanceHistoryType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BalanceHistoryType.initial;
      case 1:
        return BalanceHistoryType.topUp;
      case 2:
        return BalanceHistoryType.betBought;
      case 3:
        return BalanceHistoryType.betWon;
      case 4:
        return BalanceHistoryType.betReturn;
      default:
        return BalanceHistoryType.initial;
    }
  }

  @override
  void write(BinaryWriter writer, BalanceHistoryType obj) {
    switch (obj) {
      case BalanceHistoryType.initial:
        writer.writeByte(0);
        break;
      case BalanceHistoryType.topUp:
        writer.writeByte(1);
        break;
      case BalanceHistoryType.betBought:
        writer.writeByte(2);
        break;
      case BalanceHistoryType.betWon:
        writer.writeByte(3);
        break;
      case BalanceHistoryType.betReturn:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalanceHistoryTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
