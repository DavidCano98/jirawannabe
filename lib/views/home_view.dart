import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jirawannabe/controllers/home_controller.dart';
import 'package:jirawannabe/models/status.dart';
import 'package:jirawannabe/models/task.dart';
import 'package:jirawannabe/utils/app_colors.dart';
import 'package:jirawannabe/utils/app_styles.dart';
import 'package:jirawannabe/widgets/custom_reorderable_list_view.dart';
import 'package:jirawannabe/widgets/custom_switcher.dart';
import 'package:jirawannabe/widgets/task_button.dart';
import 'package:jirawannabe/widgets/task_detail.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.showSearchBar.value = true);
    return Scaffold(
      appBar: appBar(),
      body: Obx(
        () => taskList(controller.tasks.value),
      ),
    );
  }

  Widget taskList(List<Task>? tasks) {
    return tasks == null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "emptyTasks".tr,
                  style: AppStyles.title,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                newTaskButton(),
              ],
            ),
          )
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    filterButton(),
                    newTaskButton(),
                  ],
                ),
              ),
              Expanded(
                child: tasks.isEmpty
                    ? Center(
                        child: Text(
                          "zeroMatch".tr,
                          style: AppStyles.title,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : CustomReorderableListView.separated(
                        padding: const EdgeInsets.only(bottom: 10),
                        itemCount: tasks.length,
                        separatorBuilder: (_, __) => SizedBox(
                          height: 10,
                        ),
                        itemBuilder: (_, int index) {
                          var task = tasks[index];
                          return TaskButton(
                            task: task,
                            onDismissed: (_) async => await controller.deleteTask(task),
                            key: Key(task.id.toString()),
                            onSave: controller.updateTask,
                          );
                        },
                        onReorder: controller.onReorder,
                      ),
              ),
            ],
          );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: false,
      title: Obx(
        () => AnimatedSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          duration: Duration(seconds: 3),
          child: controller.showSearchBar.value
              ? TextField(
                  controller: controller.searchTextEditingController,
                  onChanged: controller.searchTasks,
                  cursorColor: AppColors.white,
                  decoration: InputDecoration(
                    hintText: "search".tr,
                    hintStyle: AppStyles.titleRegular,
                    isDense: true,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.white,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  style: AppStyles.titleRegular,
                )
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "jirawannabe".tr,
                    style: AppStyles.appBar,
                  ),
                ),
        ),
      ),
      actions: [
        CustomSwitcher(
          "EN",
          Get.locale?.languageCode == "en",
          () async => await controller.changeLocale("en"),
        ),
        CustomSwitcher(
          "SK",
          Get.locale?.languageCode == "sk",
          () async => await controller.changeLocale("sk"),
        ),
      ],
    );
  }

  Widget newTaskButton() => ElevatedButton(
        onPressed: () async {
          Task? task = await Get.dialog(
            TaskDetail(task: Task()),
          );
          if (task != null) {
            await controller.addTask(task);
          }
        },
        child: Text("newTask".tr),
      );

  Widget filterButton() => ElevatedButton(
        onPressed: () async {
          controller.temporaryFilter.value = List.from(controller.filter);
          Get.dialog(
            AlertDialog(
              content: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => Obx(
                                () => CheckboxListTile(
                                  title: Text(Status.values[index].name.tr),
                                  value: controller.temporaryFilter.contains(Status.values[index]),
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      if (newValue) {
                                        controller.temporaryFilter.add(Status.values[index]);
                                      } else {
                                        controller.temporaryFilter.remove(Status.values[index]);
                                      }
                                    }
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                                ),
                              ),
                          separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
                          itemCount: Status.values.length),
                      ElevatedButton(
                        onPressed: () async => await controller.filterSavePressed(),
                        child: Text("save".tr),
                      ),
                    ],
                  ),
                ),
              ),
              contentPadding: EdgeInsets.zero,
            ),
          );
        },
        child: Text("filter".tr),
      );
}
