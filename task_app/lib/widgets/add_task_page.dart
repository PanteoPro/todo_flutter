import 'package:flutter/material.dart';
import 'package:task_app/constants.dart';
import 'package:task_app/domain/entity/task.dart';
import 'package:task_app/services/task_model.dart';

class AddTaskPageWidget extends StatelessWidget {
  final Task? task;
  final bool isEdit;

  AddTaskPageWidget({
    Key? key,
    this.task,
    this.isEdit = false,
  }) : super(key: key);

  String errorText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit
            ? AddTaskPageContants.appBarTitleEdit
            : AddTaskPageContants.appBarTitle),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ErrorTextWidget(errorText: errorText),
            MyTextField(
              text: AddTaskPageContants.textInputTitleTask,
              callback: (String value) {
                TaskWidgetProvider.read(context)?.taskInputData.title = value;
              },
              startText: task?.title ?? '',
            ),
            MyTextField(
              text: AddTaskPageContants.textInputBodyTask,
              callback: (String value) {
                TaskWidgetProvider.read(context)?.taskInputData.body = value;
              },
              maxLines: 10,
              startText: task?.body ?? '',
            ),
            ElevatedButton(
              onPressed: () async {
                bool? result = false;
                if (task != null) {
                  result = await TaskWidgetProvider.read(context)
                      ?.changeContent(task: task!);
                } else {
                  result = await TaskWidgetProvider.read(context)?.addTask();
                }
                if (result!) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(isEdit
                  ? AddTaskPageContants.addButtonEdit
                  : AddTaskPageContants.addButton),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).buttonColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorTextWidget extends StatelessWidget {
  const ErrorTextWidget({
    Key? key,
    required this.errorText,
  }) : super(key: key);

  final String errorText;

  @override
  Widget build(BuildContext context) {
    final String? errorText =
        TaskWidgetProvider.watch(context)?.getErrorMessage;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        errorText ?? '',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}

class MyTextField extends StatefulWidget {
  final String text;
  final int? maxLines;
  final int? minLines;
  final Function(String) callback;

  final String startText;

  const MyTextField({
    Key? key,
    required this.text,
    required this.callback,
    required this.startText,
    this.maxLines,
    this.minLines,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: widget.startText);
    widget.callback(widget.startText);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        onChanged: (String value) => widget.callback(value),
        textInputAction: TextInputAction.next,
        minLines: widget.minLines ?? 1,
        maxLines: widget.maxLines ?? 1,
        decoration: InputDecoration(
          labelText: widget.text,
          enabledBorder: OutlineInputBorder(),
        ),
      ),
    );
  }
}
