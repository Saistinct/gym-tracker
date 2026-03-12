import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 3)
class UserProfile extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  int weekCount;

  @HiveField(2)
  int currentDayIndex;

  UserProfile({
    required this.username,
    this.weekCount = 0,
    this.currentDayIndex = 0,
  });
}
