import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keeper/features/write/domain/entity/chacter_node.dart';
import 'package:sizer/sizer.dart';

import '../../write/domain/entity/journal.dart';
import '../../write/presentation/screens/new_page.dart';
import '../../write/domain/entity/chacter_node.dart' as n;

class InsightScreen extends StatelessWidget {
  final List<Journal> journals;
  final String word;
  final n.Node node;

  const InsightScreen({
    super.key,
    required this.journals,
    required this.word,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    print(node);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(
          height: 100.h,
          width: 100.w,
          child: Column(
            children: [
              Container(
                child: RichText(
                  text: TextSpan(
                    text: "The word ",
                    style: Get.theme.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: word,
                        style: Get.theme.textTheme.titleMedium
                            ?.copyWith(backgroundColor: Colors.yellow),
                      ),
                      TextSpan(
                        text: " have been used ${node.usedPages.length} times",
                        style: Get.theme.textTheme.bodyMedium,
                      )
                    ],
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: journals.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => NewPage(
                          journal: journals.elementAt(index),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        journals.elementAt(index).title,
                        style: Get.theme.textTheme.bodyMedium,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      leading: const Icon(Icons.info),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
