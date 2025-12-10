import 'package:hive/hive.dart';

part 'user_progress.g.dart';

@HiveType(typeId: 0)
class UserProgress extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String serviceId;

  @HiveField(2)
  late List<bool> stepsCompleted;

  @HiveField(3)
  late DateTime lastUpdated;

  UserProgress({
    required this.userId,
    required this.serviceId,
    required this.stepsCompleted,
    required this.lastUpdated,
  });
}
