import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keeper/features/write/data/write_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../cubit/write_cubit.dart';

class NewPage extends StatefulWidget {
  const NewPage({
    super.key,
  });

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  bool isKeyboardOn = false;

  void toggleKeyboard() {
    if (isKeyboardOn) {
      SystemChannels.textInput.invokeMethod("TextInput.hide");
    } else {
      SystemChannels.textInput.invokeMethod("TextInput.show");
    }
    isKeyboardOn = !isKeyboardOn;
  }

  final FocusNode _focusNode = FocusNode();
  TextEditingController inputController = TextEditingController();
  int prevLength = 0;

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
                print("state updated");
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
          context.read<WriteCubit>().acceptSuggestion((content) {
            inputController.text = content;
          });
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
        actions: [
      GestureDetector(
        onTap: () {},
        child: Icon(Icons.add),
      ),
      GestureDetector(
        onTap: () {},
        child: Icon(Icons.delete),
      ),
      GestureDetector(
        onTap: () {},
        child: Icon(Icons.save),
      ),
    ]
            .map((e) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: e,
                ))
            .toList());
  }
}
