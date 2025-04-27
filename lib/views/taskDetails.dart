import '../utils/const.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late List<Activity> activities;
  late List<bool> activityCompletionStates;

  @override
  void initState() {
    super.initState();
    activities = widget.task.activities;
    activityCompletionStates = List.generate(
      activities.length,
      (index) => activities[index].completed,
    );
  }

  void _showEditTaskTitleDialog(BuildContext context, Task task) {
    final TextEditingController controller =
        TextEditingController(text: task.title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task Title'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'New Title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Title cannot be empty')),
                  );
                } else {
                  final updatedTask =
                      task.copyWith(title: controller.text.trim());
                  Provider.of<TaskViewModelProvider>(context, listen: false)
                      .updateTask(updatedTask);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModelProvider>(
      builder: (context, viewModel, child) {
        final updatedTask = viewModel.tasks.firstWhere(
          (t) => t.id == widget.task.id,
          orElse: () => widget.task,
        );

        return Scaffold(
          backgroundColor: AppColor.bgColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: AppColor.appBarColor,
            title: Text(
              updatedTask.title.toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditTaskTitleDialog(context, updatedTask),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddActivityDialog(taskId: widget.task.id),
              );
            },
            backgroundColor: AppColor.fabColor,
            elevation: 6,
            child: const Icon(Icons.add),
            tooltip: 'Add activity',
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Activities',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: updatedTask.activities.isEmpty
                      ? Center(
                          child: Text(
                          'No activities yet',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColor.blackTextColor),
                        ))
                      : ListView.builder(
                          itemCount: updatedTask.activities.length,
                          itemBuilder: (context, index) {
                            final activity = updatedTask.activities[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  activity.name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: activity.completed,
                                      onChanged: (_) {
                                        Provider.of<TaskViewModelProvider>(
                                                context,
                                                listen: false)
                                            .toggleActivityCompletion(
                                                updatedTask.id, activity.id);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: AppColor.redColor),
                                      onPressed: () {
                                        Provider.of<TaskViewModelProvider>(
                                                context,
                                                listen: false)
                                            .removeActivityFromTask(
                                                updatedTask.id, activity.id);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
