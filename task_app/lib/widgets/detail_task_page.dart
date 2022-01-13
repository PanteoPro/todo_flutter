import 'package:flutter/material.dart';
import 'package:task_app/constants.dart';
import 'package:task_app/services/task_model.dart';

class DetailTaskPage extends StatelessWidget {
  final int index;
  const DetailTaskPage({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final task = TaskWidgetProvider.read(context)?.tasks[index];
    return Scaffold(
      appBar: AppBar(
        title: Text(DetailTaskPageContants.appBarTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${DetailTaskPageContants.textTitleDescribe}:',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              Text(
                '${task!.title}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '${DetailTaskPageContants.textBodyDescribe}:',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              Text(
                '${task.body}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
