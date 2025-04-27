import '../utils/const.dart';


class TaskViewModelProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void removeTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void addActivityToTask(String taskId, Activity activity) {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      final updatedTask = _tasks[taskIndex].copyWith(activities: [
        ..._tasks[taskIndex].activities,
        activity,
      ]);
      _tasks[taskIndex] = updatedTask;
      notifyListeners();
    }
  }

  void toggleActivityCompletion(String taskId, String activityId) {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      final activityIndex =
          _tasks[taskIndex].activities.indexWhere((a) => a.id == activityId);
      if (activityIndex != -1) {
        final activity = _tasks[taskIndex].activities[activityIndex];
        final updatedActivity = activity.copyWith(
          completed: !activity.completed,
        );
        final updatedTask = _tasks[taskIndex].copyWith(activities: [
          ..._tasks[taskIndex].activities.where((a) => a.id != activity.id),
          updatedActivity
        ]);
        _tasks[taskIndex] = updatedTask;
        notifyListeners();
      }
    }
  }

  void removeActivityFromTask(String taskId, String activityId) {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      final updatedTask = _tasks[taskIndex].copyWith(activities: [
        ..._tasks[taskIndex]
            .activities
            .where((activity) => activity.id != activityId),
      ]);
      _tasks[taskIndex] = updatedTask;
      notifyListeners();
    }
  }
}
