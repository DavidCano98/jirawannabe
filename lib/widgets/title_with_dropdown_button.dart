import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jirawannabe/models/priority.dart';
import 'package:jirawannabe/models/status.dart';
import 'package:jirawannabe/utils/app_colors.dart';
import 'package:jirawannabe/utils/app_styles.dart';

class TitleWithDropdownButton extends StatelessWidget {
  final String title;
  final Enum value;
  final void Function(dynamic) onChanged;

  const TitleWithDropdownButton(
      {Key? key, required this.title, required this.value, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Enum> items = getItems();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.title,
        ),
        SizedBox(
          height: 5,
        ),
        DropdownButton<Enum>(
          isExpanded: true,
          underline: Divider(
            color: AppColors.divider,
            height: 0,
            thickness: 1,
          ),
          value: value,
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
          items: items.map<DropdownMenuItem<Enum>>((Enum value) {
            return DropdownMenuItem<Enum>(
              value: value,
              child: Text(value.name.tr),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<Enum> getItems() {
    switch (value.runtimeType) {
      case Status:
        return Status.values;
      case Priority:
        return Priority.values;
      default:
        return [];
    }
  }
}
