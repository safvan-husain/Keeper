import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:keeper/features/write/presentation/cubit/write_cubit.dart';
import 'package:sizer/sizer.dart';

class ModifyTitleOverlay extends StatelessWidget {
  final String title;

  const ModifyTitleOverlay({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: title);
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Get.theme.scaffoldBackgroundColor,
          ),
          height: 20.h,
          width: 60.w,
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.theme.highlightColor,
                ),
                child: TextField(
                  style:
                      Get.textTheme.bodyMedium?.copyWith(color: Colors.black),
                  decoration: const InputDecoration(border: InputBorder.none),
                  controller: controller,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: LocalButton(
                  itemColor: Colors.white,
                  color: Get.theme.primaryColor,
                  contentAlignment: Alignment.center,
                  label: "Modify",
                  onTap: () {
                    context.read<WriteCubit>().changeTitle(controller.text);
                    Get.back();
                  },
                  width: 30.w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocalButton extends StatelessWidget {
  final String label;
  final void Function() onTap;
  final double? width;
  final Color? color;
  final Color? itemColor;
  final Alignment? contentAlignment;

  const LocalButton({
    super.key,
    this.color,
    this.itemColor,
    this.contentAlignment,
    required this.label,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(microseconds: 500),
        width: width ?? 60.w,
        height: 5.h,
        alignment: contentAlignment ?? Alignment.centerLeft,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: color ?? Get.theme.highlightColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: Get.textTheme.bodyMedium
              ?.copyWith(color: itemColor ?? Get.theme.canvasColor),
        ),
      ),
    );
  }
}
