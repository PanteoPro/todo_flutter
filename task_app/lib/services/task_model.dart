import 'package:flutter/material.dart';
import 'package:task_app/constants.dart';
import 'package:task_app/domain/api_clients/api_client.dart';
import 'package:task_app/domain/entity/task.dart';

class TaskInputData {
  String? _title;
  String? _body;
  set title(String value) => _title = value;
  set body(String value) => _body = value;
  String? get getTitle => _title;
  String? get getBody => _body;

  void clear() {
    _title = null;
    _body = null;
  }
}

class TaskWidgetModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final taskInputData = TaskInputData();
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  String? _errorMessage;
  String? get getErrorMessage {
    final res = _errorMessage;
    _errorMessage = null;
    return res;
  }

  void reloadTasks() async {
    _tasks = await _apiClient.getTasks();
    notifyListeners();
  }

  Future<bool> addTask() async {
    final result = _isFilledInputData();
    final isFilled = result.remove('isFilled');

    bool success = false;

    if (result.isNotEmpty) {
      _errorMessage = result.values.join('\n');
    }

    if (isFilled) {
      final task = await _apiClient.createTask(
        title: taskInputData.getTitle!,
        body: taskInputData.getBody!,
      );
      if (task != null) {
        reloadTasks();
        taskInputData.clear();
        success = true;
      }
    }
    notifyListeners();
    return success;
  }

  Map<dynamic, dynamic> _isFilledInputData() {
    var isFilled = true;
    Map message = {};
    if (taskInputData.getTitle == null || taskInputData.getTitle == '') {
      isFilled = false;
      message['title_error'] = AddTaskPageContants.errorTitle;
    }

    if (taskInputData.getBody == null || taskInputData.getBody == '') {
      isFilled = false;
      message['body_error'] = AddTaskPageContants.errorBody;
    }

    message['isFilled'] = isFilled;
    return message;
  }

  void deleteTask({required int id}) async {
    final isDeleted = await _apiClient.deleteTask(id: id);
    if (isDeleted) {
      reloadTasks();
      notifyListeners();
    }
  }

  void changeChecked({required int id}) async {
    bool isChangeChacked = await _apiClient.changeChecked(id: id);
    if (isChangeChacked) {
      reloadTasks();
      notifyListeners();
    }
  }

  Future<bool> changeContent({required Task task}) async {
    final result = _isFilledInputData();
    final isFilled = result.remove('isFilled');

    bool success = false;

    if (result.isNotEmpty) {
      _errorMessage = result.values.join('\n');
    }

    if (isFilled) {
      final editTask = await _apiClient.changeContent(
        title: taskInputData.getTitle!,
        body: taskInputData.getBody!,
        id: task.id,
      );
      if (editTask != null) {
        reloadTasks();
        taskInputData.clear();
        success = true;
      }
    }

    notifyListeners();
    return success;
  }
}

class TaskWidgetProvider extends InheritedNotifier<TaskWidgetModel> {
  TaskWidgetProvider({
    Key? key,
    required Widget child,
    required TaskWidgetModel model,
  }) : super(key: key, notifier: model, child: child);

  static TaskWidgetModel? watch(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<TaskWidgetProvider>();
    final notifier = provider?.notifier;
    return notifier;
  }

  static TaskWidgetModel? read(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<TaskWidgetProvider>();
    final provider = element?.widget as TaskWidgetProvider;
    final notifier = provider.notifier;
    return notifier;
  }
}
