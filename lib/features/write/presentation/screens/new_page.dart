import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../domain/entity/journal.dart';
import '../cubit/write_cubit.dart';

class NewPage extends StatefulWidget {
  final Journal journal;

  const NewPage({
    super.key,
    required this.journal,
  });

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController inputController = TextEditingController();
  int prevLength = 0;

  late Future<String> futureContent;

  @override
  void initState() {
    var cubit = context.read<WriteCubit>();
    inputController.addListener(() {
      String? lastChar = inputController.text.characters.lastOrNull;
      //on empty string
      if (lastChar == null) return;

      int contentLength = inputController.text.length;

      if (contentLength < prevLength) {
        //used backSpace
        cubit.onBackSpace(inputController.text);
      } else {
        //appended something
        cubit.onAppendSomething(
          lastChar,
          inputController.text,
        );
      }
      prevLength = contentLength;
    });
    cubit.init(
      textUpdater: (content) {
        inputController.text = content;
      },
      journal: widget.journal,
    );
    super.initState();
  }

  // late Future<void> init = storage.init();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.red,
              child: TextField(
                focusNode: _focusNode,
                controller: inputController,
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            BlocBuilder<WriteCubit, WriteState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(_focusNode);
                  },
                  child: Container(
                    color: Colors.white,
                    width: 100.w,
                    height: 100.h,
                    padding: const EdgeInsets.all(20),
                    child: Stack(
                      children: [
                        Text(
                          state.content,
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                        Text(
                          inputController.text,
                          style: GoogleFonts.poppins(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward),
        onPressed: () async {
          context.read<WriteCubit>().acceptSuggestion();
        },
      ),
    );
  }

  AppBar buildAppBar() {
    var cubit = context.read<WriteCubit>();
    return AppBar(
      title: GestureDetector(
        onTap: () => cubit.showOverlay(),
        child: Text(
          context.watch<WriteCubit>().state.title ?? widget.journal.title,
          style: Get.theme.textTheme.titleMedium,
        ),
      ),
      leading: GestureDetector(
        onTap: () => cubit.showAllJournals(),
        child: const Icon(Icons.arrow_back),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            cubit.showAllJournals();
          },
          child: const Icon(Icons.list),
        ),
        GestureDetector(
          onTap: () {},
          child: const Icon(Icons.delete),
        ),
        GestureDetector(
          onTap: () {
            context.read<WriteCubit>().savePage(
                  inputController.text,
                  widget.journal,
                );
          },
          child: const Icon(Icons.save),
        ),
      ]
          .map(
            (e) => Padding(
              padding: const EdgeInsets.all(10),
              child: e,
            ),
          )
          .toList(),
    );
  }
}
