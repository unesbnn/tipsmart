// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tip_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TipAdapter extends TypeAdapter<Tip> {
  @override
  final int typeId = 10;

  @override
  Tip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tip(
      id: fields[0] as String,
      fixtureId: fields[1] as int,
      fixtureTimestamp: fields[2] as int,
      fixtureDate: fields[3] as String,
      fixtureStatus: fields[4] as String,
      createDate: fields[5] as String,
      leagueId: fields[6] as int,
      leagueName: fields[7] as String,
      homeTeamId: fields[8] as int,
      homeTeamName: fields[9] as String,
      awayTeamId: fields[10] as int,
      awayTeamName: fields[11] as String,
      betId: fields[12] as int,
      betName: fields[13] as String,
      betValueName: fields[14] as String,
      betValueOdd: fields[15] as double,
      halftimeScore: fields[16] as String?,
      fullTimeScore: fields[17] as String?,
      extraTimeScore: fields[18] as String?,
      penaltyScore: fields[19] as String?,
      status: fields[20] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Tip obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fixtureId)
      ..writeByte(2)
      ..write(obj.fixtureTimestamp)
      ..writeByte(3)
      ..write(obj.fixtureDate)
      ..writeByte(4)
      ..write(obj.fixtureStatus)
      ..writeByte(5)
      ..write(obj.createDate)
      ..writeByte(6)
      ..write(obj.leagueId)
      ..writeByte(7)
      ..write(obj.leagueName)
      ..writeByte(8)
      ..write(obj.homeTeamId)
      ..writeByte(9)
      ..write(obj.homeTeamName)
      ..writeByte(10)
      ..write(obj.awayTeamId)
      ..writeByte(11)
      ..write(obj.awayTeamName)
      ..writeByte(12)
      ..write(obj.betId)
      ..writeByte(13)
      ..write(obj.betName)
      ..writeByte(14)
      ..write(obj.betValueName)
      ..writeByte(15)
      ..write(obj.betValueOdd)
      ..writeByte(16)
      ..write(obj.halftimeScore)
      ..writeByte(17)
      ..write(obj.fullTimeScore)
      ..writeByte(18)
      ..write(obj.extraTimeScore)
      ..writeByte(19)
      ..write(obj.penaltyScore)
      ..writeByte(20)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TipAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
