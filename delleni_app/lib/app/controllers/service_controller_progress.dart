part of 'service_controller.dart';

// Progress and step tracking.
extension ServiceControllerProgress on ServiceController {
  Future<void> toggleStep(int index) async {
    final svc = selectedService.value;
    if (svc == null) return;
    if (index < 0 || index >= stepCompleted.length) return;

    stepCompleted[index] = !stepCompleted[index];
    stepCompleted.refresh();

    await _persistProgress(svc);
  }

  Future<void> _loadProgressForService(Service svc) async {
    final box = await _ensureProgressBox();
    final userId = supabase.auth.currentUser?.id ?? 'guest';
    final key = '${userId}_${svc.id}';
    final targetLength = svc.steps.length;

    final existing = box.get(key);
    if (existing != null) {
      // Normalize length in case steps changed.
      final normalized = List<bool>.filled(targetLength, false);
      for (
        var i = 0;
        i < targetLength && i < existing.stepsCompleted.length;
        i++
      ) {
        normalized[i] = existing.stepsCompleted[i];
      }
      stepCompleted.assignAll(normalized);

      // If lengths differ, persist the normalized list back.
      if (normalized.length != existing.stepsCompleted.length) {
        existing.stepsCompleted = normalized;
        existing.lastUpdated = DateTime.now();
        existing.updateStatus();
        await box.put(key, existing);
      }
      return;
    }

    // No record yet; initialize empty progress and persist.
    stepCompleted.assignAll(List<bool>.filled(targetLength, false));
    await _persistProgress(svc);
  }

  Future<void> _persistProgress(Service svc) async {
    final box = await _ensureProgressBox();
    final userId = supabase.auth.currentUser?.id ?? 'guest';
    final key = '${userId}_${svc.id}';

    final data = box.get(key);
    if (data != null) {
      data.stepsCompleted = List<bool>.from(stepCompleted);
      data.lastUpdated = DateTime.now();
      data.updateStatus();
      await data.save();
      return;
    }

    final progress = UserProgress(
      userId: userId,
      serviceId: svc.id,
      stepsCompleted: List<bool>.from(stepCompleted),
      lastUpdated: DateTime.now(),
    );
    progress.updateStatus();
    await box.put(key, progress);
  }

  Future<Box<UserProgress>> _ensureProgressBox() async {
    if (Hive.isBoxOpen('user_progress')) {
      progressBox = Hive.box<UserProgress>('user_progress');
      return progressBox;
    }

    progressBox = await Hive.openBox<UserProgress>('user_progress');
    return progressBox;
  }
}
