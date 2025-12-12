import 'package:hive/hive.dart';

part 'user_progress_model.g.dart';

@HiveType(typeId: 0)
class UserProgressModel {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String serviceId;

  @HiveField(2)
  final List<bool> stepsCompleted;

  @HiveField(3)
  final DateTime lastUpdated;

  @HiveField(4)
  String status; // 'pending', 'in_progress', 'completed'

  UserProgressModel({
    required this.userId,
    required this.serviceId,
    required this.stepsCompleted,
    required this.lastUpdated,
    this.status = 'pending',
  });

  // Helper to calculate completion percentage
  double get completionPercentage {
    if (stepsCompleted.isEmpty) return 0.0;
    final completed = stepsCompleted.where((step) => step).length;
    return completed / stepsCompleted.length;
  }

  // Helper to check if all steps are completed
  bool get isCompleted {
    return stepsCompleted.isNotEmpty && stepsCompleted.every((step) => step);
  }

  // Helper to check if any step is completed
  bool get hasProgress {
    return stepsCompleted.isNotEmpty && stepsCompleted.any((step) => step);
  }

  // Update status based on completion
  void updateStatus() {
    if (isCompleted) {
      status = 'completed';
    } else if (hasProgress) {
      status = 'in_progress';
    } else {
      status = 'pending';
    }
  }

  // Get completed steps count
  int get completedCount {
    return stepsCompleted.where((step) => step).length;
  }

  // Get total steps
  int get totalSteps {
    return stepsCompleted.length;
  }

  // Toggle a specific step
  UserProgressModel toggleStep(int index) {
    if (index < 0 || index >= stepsCompleted.length) return this;

    final newSteps = List<bool>.from(stepsCompleted);
    newSteps[index] = !newSteps[index];

    return copyWith(stepsCompleted: newSteps, lastUpdated: DateTime.now());
  }

  // Update all steps
  UserProgressModel updateSteps(List<bool> newSteps) {
    return copyWith(stepsCompleted: newSteps, lastUpdated: DateTime.now());
  }

  // Copy with method
  UserProgressModel copyWith({
    String? userId,
    String? serviceId,
    List<bool>? stepsCompleted,
    DateTime? lastUpdated,
    String? status,
  }) {
    return UserProgressModel(
      userId: userId ?? this.userId,
      serviceId: serviceId ?? this.serviceId,
      stepsCompleted: stepsCompleted ?? this.stepsCompleted,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      status: status ?? this.status,
    );
  }

  // Create from service model
  factory UserProgressModel.fromService({
    required String userId,
    required String serviceId,
    required int totalSteps,
  }) {
    return UserProgressModel(
      userId: userId,
      serviceId: serviceId,
      stepsCompleted: List<bool>.filled(totalSteps, false),
      lastUpdated: DateTime.now(),
      status: 'pending',
    );
  }
}
