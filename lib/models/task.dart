import 'package:jirawannabe/models/priority.dart';
import 'package:jirawannabe/models/status.dart';

class Task {
  int? id;
  String title;
  String description;
  Status status;
  Priority priority;
  String project;
  String reporter;
  String assignee;
  int? position;

  Task({
    this.id,
    this.title="",
    this.description="",
    this.status=Status.toDo,
    this.priority = Priority.medium,
    this.project="",
    this.reporter="",
    this.assignee="",
    this.position,
  });

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json["id"],
        status: Status.values[json["status"]],
        title: json["title"],
        priority: Priority.values[json["priority"]],
        project: json["project"],
        description: json["description"],
        reporter: json["reporter"],
        assignee: json["assignee"],
        position: json["position"],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status.index,
      'title': title,
      'priority': priority.index,
      'project': project,
      'description': description,
      'reporter': reporter,
      'assignee': assignee,
      'position': position,
    };
  }
}
