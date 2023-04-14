import 'package:flutter/material.dart';
import 'package:jirawannabe/utils/app_colors.dart';
import 'package:jirawannabe/utils/app_styles.dart';

class TitleWithTextfield extends StatelessWidget {
  final String title;
  final String value;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final TextEditingController textEditingController = TextEditingController();

  TitleWithTextfield(
      {Key? key, required this.title, required this.value, required this.onChanged, this.validator})
      : super(key: key) {
    textEditingController.text = value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
            TextSpan(
              text: title,
              children: [
                if (validator != null)
                  TextSpan(text: " *", style: AppStyles.title.copyWith(color: AppColors.red)),
              ],
            ),
            style: AppStyles.title),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: title,
            isDense: true,
          ),
          validator: validator,
          controller: textEditingController,
          onChanged: (value) => onChanged(value),
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }
}
