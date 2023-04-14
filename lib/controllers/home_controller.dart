import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jirawannabe/helpers/local_database.dart';
import 'package:jirawannabe/models/status.dart';
import 'package:jirawannabe/models/task.dart';

class HomeController extends GetxController {
  Rxn<List<Task>> tasks = Rxn();
  RxList<Status> temporaryFilter = <Status>[].obs;
  List<Status> filter = <Status>[];
  RxBool showSearchBar = false.obs;
  Timer? _debounceTimer;
  DateTime? _lastTyped;
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
    tasks.value = await LocalDatabase.instance.getTasks();
  }

  @override
  Future<void> onClose() async {
    _debounceTimer?.cancel();
    super.onClose();
  }

  Future<void> changeLocale(String languageCode) async {
    Locale locale = Locale(languageCode);
    await Get.updateLocale(
      locale,
    );
    await LocalDatabase.instance.saveLocale(languageCode);
  }

  Future<void> onReorder(int oldIndex, int newIndex) async {
    var firstTaskPosition = tasks.value?[oldIndex].position;
    var secondTaskPosition = tasks.value?[newIndex].position;
    Task? item = tasks.value?.removeAt(oldIndex);
    if (item != null) {
      tasks.value?.insert(newIndex, item);
      tasks.refresh();
    }
    await LocalDatabase.instance
        .reorderTasks(firstTaskPosition,secondTaskPosition);
    await filterTasks();
  }

  Future<void> filterTasks() async {
    tasks.value = await LocalDatabase.instance.filterTasks(
        statuses: (filter.isEmpty ? Status.values : filter).map((e) => e.index).toList(),
        title: searchTextEditingController.text);
    tasks.refresh();
  }

  Future<void> deleteTask(Task task) async {
    await LocalDatabase.instance.deleteTask(task);
    await filterTasks();
  }

  Future<void> updateTask(Task task) async {
    await filterTasks();
  }

  Future<void> addTask(Task task) async {
    await filterTasks();
  }

  Future<void> filterSavePressed() async {
    filter = temporaryFilter;
    await filterTasks();
    Get.back();
  }

  Future<void> searchTasks(_) async {
    if (_debounceTimer != null) {
      _debounceTimer?.cancel();
    }
    _lastTyped = DateTime.now();
    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      if (DateTime.now().difference(_lastTyped!) >= Duration(milliseconds: 500)) {
        await filterTasks();
      }
    });
  }
}
