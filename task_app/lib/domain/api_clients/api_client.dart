import 'dart:convert';
import 'dart:io';

import 'package:task_app/domain/entity/task.dart';

class ApiClient {
  final _client = HttpClient();

  Future<List<Task>> getTasks() async {
    String url = 'http://192.168.1.4:8000/task/';
    final response = await _GETResponse(url);
    final json = await _getJsonByResponse(response) as List<dynamic>;
    final tasks =
        json.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
    return tasks;
  }

  Future<Task?> createTask(
      {required String title, required String body}) async {
    String url = 'http://192.168.1.4:8000/task/create';
    final response = await _POSTResponse(url: url, title: title, body: body);
    final json = await _getJsonByResponse(response) as Map<String, dynamic>;
    if (json['isCreated']) {
      return Task.fromJson(json['task']);
    }
  }

  Future<bool> deleteTask({required int id}) async {
    String url = 'http://192.168.1.4:8000/task/delete?id=$id';
    final response = await _GETResponse(url);
    final json = await _getJsonByResponse(response);
    if (json['isDeleted']) {
      return true;
    }
    return false;
  }

  Future<bool> changeChecked({required int id}) async {
    String url = 'http://192.168.1.4:8000/task/changeChecked?id=$id';
    final response = await _GETResponse(url);
    final json = await _getJsonByResponse(response);
    if (json['isChangedChecked']) {
      return true;
    }
    return false;
  }

  Future<Task?> changeContent(
      {required String title, required String body, required int id}) async {
    String url = 'http://192.168.1.4:8000/task/changeContent';
    final response =
        await _POSTResponse(url: url, title: title, body: body, id: id);
    final json = await _getJsonByResponse(response) as Map<String, dynamic>;
    if (json['isChangedContent']) {
      return Task.fromJson(json['task']);
    }
  }

  Future<HttpClientResponse> _POSTResponse({
    required String url,
    required String title,
    required String body,
    int? id,
  }) async {
    final uri = Uri.parse(url);
    final parameters = <String, dynamic>{
      'title': title,
      'body': body,
    };
    if (id != null) {
      parameters['id'] = id;
    }

    final request = await _client.postUrl(uri);
    request.headers
        .set(HttpHeaders.contentTypeHeader, ContentType.json.toString());

    final reg = RegExp(r'[а-яА-Я]');
    request.headers.contentLength = jsonEncode(parameters).length +
        reg.allMatches(jsonEncode(parameters)).length;
    request.write(jsonEncode(parameters)); // Записываем данные в body

    final response = await request.close();
    return response;
  }

  Future<HttpClientResponse> _GETResponse(String url) async {
    final uri = Uri.parse(url);
    final request = await _client.getUrl(uri);
    final response = await request.close();
    return response;
  }

  Future<dynamic> _getJsonByResponse(HttpClientResponse response) async {
    final jsonStrings = await response.transform(utf8.decoder).toList();
    final jsonString = jsonStrings.join();
    final json = jsonDecode(jsonString);
    return json;
  }
}
