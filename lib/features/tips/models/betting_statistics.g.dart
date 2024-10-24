// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'betting_statistics.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BettingStatisticsAdapter extends TypeAdapter<BettingStatistics> {
  @override
  final int typeId = 12;

  @override
  BettingStatistics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BettingStatistics(
      balance: fields[0] as double,
      totalBets: fields[1] as int,
      wonBets: fields[2] as int,
      lostBets: fields[3] as int,
      pendingBets: fields[4] as int,
      returnedBets: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BettingStatistics obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.balance)
      ..writeByte(1)
      ..write(obj.totalBets)
      ..writeByte(2)
      ..write(obj.wonBets)
      ..writeByte(3)
      ..write(obj.lostBets)
      ..writeByte(4)
      ..write(obj.pendingBets)
      ..writeByte(5)
      ..write(obj.returnedBets);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BettingStatisticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
