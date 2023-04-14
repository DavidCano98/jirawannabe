import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jirawannabe/models/task.dart';
import 'package:jirawannabe/utils/app_colors.dart';
import 'package:jirawannabe/utils/app_styles.dart';
import 'package:jirawannabe/widgets/task_detail.dart';

class TaskButton extends StatelessWidget {
  final Task task;
  final Function(Task) onSave;
  final Function(DismissDirection dismissDirection) onDismissed;

  const TaskButton({Key? key, required this.task, required this.onDismissed, required this.onSave})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Dismissible(
        key: Key("dismissible${task.id}"),
        onDismissed: onDismissed,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.white,
            padding: EdgeInsets.zero,
          ),
          onPressed: () async {
            Task? result = await Get.dialog(
              TaskDetail(task: task),
            );
            if (result != null) {
              await onSave(result);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: AppStyles.title,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/${task.priority.name}.svg"),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        task.status.name.tr,
                        style: AppStyles.description(),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      child:  Text(
                          "${task.project} - ${task.id}",
                          style: AppStyles.description(color: AppColors.black),
                          textAlign: TextAlign.end,

                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: task.assignee != "" ? AppColors.blue : AppColors.grey,
                      ),
                      child: Text((task.assignee == "" ? "?" : task.assignee)[0].capitalizeFirst!),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
