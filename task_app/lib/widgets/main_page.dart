import 'package:flutter/material.dart';
import 'package:task_app/constants.dart';
import 'package:task_app/services/task_model.dart';
import 'package:task_app/widgets/add_task_page.dart';
import 'package:task_app/widgets/detail_task_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    TaskWidgetProvider.read(context)?.reloadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MainPageConstants.appBarTitle),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => AddTaskPageWidget(),
                  ),
                );
              },
              child: Text(MainPageConstants.addNewTaskButton),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).buttonColor),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return TaskRowWidget(index: index);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10);
                },
                itemCount: TaskWidgetProvider.watch(context)!.tasks.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskRowWidget extends StatelessWidget {
  final int index;
  const TaskRowWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final task = TaskWidgetProvider.read(context)!.tasks[index];
    return ListTile(
      tileColor: Theme.of(context).cardColor,
      leading: Checkbox(
        checkColor: Colors.grey,
        fillColor: MaterialStateProperty.all(Colors.blue),
        onChanged: (bool? value) {
          TaskWidgetProvider.read(context)?.changeChecked(id: task.id);
        },
        value: task.isChecked,
      ),
      title: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return DetailTaskPage(index: index);
              },
            ),
          );
        },
        child: Text(task.title),
      ),
      trailing: Container(
        width: 70,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                TaskWidgetProvider.read(context)?.deleteTask(id: task.id);
              },
              child: Icon(
                Icons.close,
                color: Theme.of(context).indicatorColor,
                size: 30,
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext) {
                      return AddTaskPageWidget(
                        task: task,
                        isEdit: true,
                      );
                    },
                  ),
                );
              },
              child: Icon(
                Icons.edit,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
