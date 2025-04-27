class Activity {
  String id;
  String name;
  bool completed;

  Activity({
    required this.id,
    required this.name,
    this.completed = false,
  });

  Activity copyWith({
    String? id,
    String? name,
    bool? completed,
  }) {
    return Activity(
      id: id ?? this.id,
      name: name ?? this.name,
      completed: completed ?? this.completed,
    );
  }
}
