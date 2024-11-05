import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keeper/features/insights/presentaion/search_word_screen.dart';
import 'package:sizer/sizer.dart';

import '../../write/presentation/screens/new_page.dart';
import 'list_cubit.dart';

class ListJournalScreen extends StatelessWidget {
  const ListJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Journals",
          style: Get.theme.textTheme.titleMedium,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => SearchInsight());
            },
            child: const Icon(Icons.search),
          ),
          SizedBox(
            width: 10.w,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<ListCubit, ListState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.journals.length,
              itemBuilder: (c, i) {
                return GestureDetector(
                  onTap: () {
                    Get.to(
                      () => NewPage(
                        journal: state.journals.elementAt(i),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      state.journals.elementAt(i).title,
                      style: Get.theme.textTheme.bodyMedium,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    leading: const Icon(Icons.info),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
