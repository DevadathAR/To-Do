import '../utils/const.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: AppBar(
        title: const Text(
          'TODO',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        backgroundColor: AppColor.appBarColor,
      ),
      body: Consumer<TaskViewModelProvider>(
        builder: (context, taskViewModel, child) {
          final tasks = taskViewModel.tasks;

          return tasks.isEmpty
              ? Center(
                  child: Text(
                    'No tasks yet.',
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900, color: AppColor.blackTextColor),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: tasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskTile(
                      task: task,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailsScreen(task: task),
                          ),
                        );
                      },
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const NewTaskDialog(),
          );
        },
        backgroundColor: AppColor.fabColor,
        elevation: 6,
        child: const Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}
