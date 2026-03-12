import 'package:hive/hive.dart';

part 'body_measurements.g.dart';

@HiveType(typeId: 4)
class BodyMeasurements extends HiveObject {
  /// 0 = cm, 1 = inches
  @HiveField(0)
  int preferredUnit;

  /// Stored in centimeters (cm)
  @HiveField(1)
  double heightCm;

  /// Stored in kilograms (kg)
  @HiveField(2)
  double weightKg;

  /// Stored in centimeters (cm) keyed by body part name
  @HiveField(3)
  Map<String, double> measurementsCm;

  BodyMeasurements({
    this.preferredUnit = 0,
    this.heightCm = 0,
    this.weightKg = 0,
    Map<String, double>? measurementsCm,
  }) : measurementsCm = measurementsCm ?? <String, double>{};
}
