// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fake_bet.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FakeBetAdapter extends TypeAdapter<FakeBet> {
  @override
  final int typeId = 11;

  @override
  FakeBet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FakeBet(
      id: fields[0] as String,
      uid: fields[1] as String,
      bets: (fields[2] as List).cast<Tip>(),
      odds: fields[3] as double,
      stake: fields[4] as double,
      date: fields[5] as DateTime,
      status: fields[6] as String,
      returnAmount: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, FakeBet obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uid)
      ..writeByte(2)
      ..write(obj.bets)
      ..writeByte(3)
      ..write(obj.odds)
      ..writeByte(4)
      ..write(obj.stake)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.returnAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FakeBetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
