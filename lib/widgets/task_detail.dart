import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jirawannabe/controllers/task_detail_controller.dart';
import 'package:jirawannabe/models/task.dart';
import 'package:jirawannabe/widgets/title_with_dropdown_button.dart';
import 'package:jirawannabe/widgets/title_with_textfield.dart';

class TaskDetail extends StatelessWidget {
  final Task task;

  const TaskDetail({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TaskDetailController controller = Get.put(TaskDetailController(task));
    return AlertDialog(
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Obx(
                () => Form(
                  key: controller.formKey,
                  child: Wrap(
                    runSpacing: 30,
                    children: [
                      TitleWithTextfield(
                        title: "title".tr,
                        value: task.title,
                        onChanged: (value) {
                          task.title = value;
                        },
                        validator: (value){
                          if(value==null || value.isEmpty){
                            return "${"pleaseEnter".tr} ${"title".tr.toLowerCase()}";
                          }
                          return null;
                        },
                      ),
                      TitleWithTextfield(
                        title: "project".tr,
                        value: task.project,
                        onChanged: (value) {
                          task.project = value;
                        },
                        validator: (value){
                          if(value==null || value.isEmpty){
                            return "${"pleaseEnter".tr} ${"project".tr.toLowerCase()}";
                          }
                          return null;
                        },
                      ),
                      TitleWithTextfield(
                        title: "description".tr,
                        value: task.description,
                        onChanged: (value) {
                          task.description = value;
                        },
                      ),
                      TitleWithDropdownButton(
                        title: "priority".tr,
                        value: controller.priority.value,
                        onChanged: (value) {
                          controller.priority.value = value;
                        },
                      ),
                      TitleWithDropdownButton(
                        title: "status".tr,
                        value: controller.status.value,
                        onChanged: (value) {
                          controller.status.value = value;
                        },
                      ),
                      TitleWithTextfield(
                        title: "reporter".tr,
                        value: task.reporter,
                        onChanged: (value) {
                          task.reporter = value;
                        },
                      ),
                      TitleWithTextfield(
                        title: "assignee".tr,
                        value: task.assignee,
                        onChanged: (value) {
                          task.assignee = value;
                        },
                      ),
                    ],
                    /*'id': id,
              'status': status.index,
              'title': title,
              'priority': priority.index,
              'project': project,
              'description': description,
              'reporter': reporter,
              'assignee': assignee,
              'position': position,*/
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              task.position == null
                  ? ElevatedButton(
                      onPressed: () async => await controller.createTask(task),
                      child: Text("create".tr),
                    )
                  : ElevatedButton(
                      onPressed: () async => await controller.updateTask(task),
                      child: Text("save".tr),
                    ),
            ],
          ),
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
