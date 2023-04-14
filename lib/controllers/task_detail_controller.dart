import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jirawannabe/helpers/local_database.dart';
import 'package:jirawannabe/models/priority.dart';
import 'package:jirawannabe/models/status.dart';
import 'package:jirawannabe/models/task.dart';

class TaskDetailController extends GetxController {
  late Rx<Status> status;
  late Rx<Priority> priority;
  final formKey = GlobalKey<FormState>();

  TaskDetailController(Task task) {
    status = task.status.obs;
    priority = task.priority.obs;
  }

  Future<void> createTask(Task task) async {
    if (formKey.currentState?.validate() ?? false) {
      Task? result = await LocalDatabase.instance.insertTask(task
        ..status = status.value
        ..priority = priority.value);
      Get.back(result: result);
    }
  }

  Future<void> updateTask(Task task) async {
    if (formKey.currentState?.validate() ?? false) {
      Task? result = await LocalDatabase.instance.saveTask(task
        ..status = status.value
        ..priority = priority.value);
      Get.back(result: result);
    }
  }
}
