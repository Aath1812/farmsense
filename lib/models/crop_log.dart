import 'package:hive/hive.dart';

@HiveType(typeId: 0) // Unique ID for this type
class CropLog extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String cropType;

  @HiveField(2)
  late DateTime date;

  @HiveField(3)
  late String notes;

  @HiveField(4)
  late String status; // e.g., 'Sown', 'Harvested', 'Growing'

  @HiveField(5)
  late double yieldAmount;

  CropLog({
    required this.id,
    required this.cropType,
    required this.date,
    this.notes = '',
    required this.status,
    this.yieldAmount = 0.0,
  });

  // Add the copyWith method
  CropLog copyWith({
    String? id,
    String? cropType,
    DateTime? date,
    String? notes,
    String? status,
    double? yieldAmount,
  }) {
    return CropLog(
      id: id ?? this.id,
      cropType: cropType ?? this.cropType,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      yieldAmount: yieldAmount ?? this.yieldAmount,
    );
  }
}

// Manual TypeAdapter for CropLog
class CropLogAdapter extends TypeAdapter<CropLog> {
  @override
  final int typeId = 0;

  @override
  CropLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++)
        reader.readByte(): reader.read(),
    };
    return CropLog(
      id: fields[0] as String,
      cropType: fields[1] as String,
      date: fields[2] as DateTime,
      notes: fields[3] as String,
      status: fields[4] as String,
      yieldAmount: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CropLog obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cropType)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.yieldAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CropLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
