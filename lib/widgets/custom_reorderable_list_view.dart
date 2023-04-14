import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jirawannabe/utils/app_colors.dart';

class CustomReorderableListView extends ReorderableListView {
  CustomReorderableListView.separated({
    Key? key,
    required IndexedWidgetBuilder itemBuilder,
    required IndexedWidgetBuilder separatorBuilder,
    required int itemCount,
    required ReorderCallback onReorder,
    double? itemExtent,
    Widget? prototypeItem,
    ReorderItemProxyDecorator? proxyDecorator,
    bool buildDefaultDragHandles = true,
    EdgeInsets? padding,
    Widget? header,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? scrollController,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = true,
    double anchor = 0.0,
    double? cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  }) : super.builder(
          key: key,
          itemCount: max(0, itemCount * 2 - 1),
          itemBuilder: (BuildContext context, int index) {
            if (index % 2 == 1) {
              final separator = separatorBuilder.call(context, index);

              if (separator.key == null) {
                return KeyedSubtree(
                  key: ValueKey('ReorderableSeparator${index}Key'),
                  child: IgnorePointer(child: separator),
                );
              }

              return separator;
            }

            return itemBuilder.call(context, index ~/ 2);
          },
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }

            if (oldIndex % 2 == 1) {
              return;
            }

            if ((oldIndex - newIndex).abs() == 1) {
              return;
            }

            newIndex =
                oldIndex > newIndex && newIndex % 2 == 1 ? (newIndex + 1) ~/ 2 : newIndex ~/ 2;
            oldIndex = oldIndex ~/ 2;
            onReorder.call(oldIndex, newIndex);
          },
          itemExtent: itemExtent,
          prototypeItem: prototypeItem,
          proxyDecorator: (Widget child, _, animation) {
            return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                final animValue = Curves.easeInOut.transform(animation.value);
                final scale = lerpDouble(1, 1.05, animValue)!;
                return Transform.scale(
                  scale: scale,
                  child: Material(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.transparent,
                    child: child,
                  ),
                );
              },
              child: child,
            );
          },
          buildDefaultDragHandles: buildDefaultDragHandles,
          padding: padding,
          header: header,
          scrollDirection: scrollDirection,
          reverse: reverse,
          scrollController: scrollController,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          anchor: anchor,
          cacheExtent: cacheExtent,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );
}
