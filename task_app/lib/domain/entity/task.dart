import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  final int id;
  final String title;
  final String body;
  final int position;
  final bool isChecked;

  Task({
    required this.id,
    required this.title,
    required this.body,
    required this.position,
    required this.isChecked,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
