import '../utils/const.dart';


class Task {
  String id;
  String title;
  List<Activity> activities;

  Task({
    required this.id,
    required this.title,
    this.activities = const [],
  });

  Task copyWith({
    String? id,
    String? title,
    List<Activity>? activities,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      activities: activities ?? this.activities,
    );
  }
}
