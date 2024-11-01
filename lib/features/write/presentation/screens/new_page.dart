import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keeper/features/write/data/write_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../cubit/write_cubit.dart';

class NewPage extends StatefulWidget {
  final WriteStorage storage;

  const NewPage({super.key, required this.storage});

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

  TextEditingController controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    controller.addListener(() {
      if (controller.text.characters.lastOrNull == " ") {
        context.read<WriteCubit>().appendToken();
        controller.text = "";
      } else if (controller.text.characters.lastOrNull != null) {
        context
            .read<WriteCubit>()
            .appendNewChar(controller.text.replaceAll(" ", ""));
      } else if (controller.text.isNotEmpty) {}
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
                controller: controller,
                onChanged: (s) {
                  print(s);
                },
              ),
            ),
            BlocBuilder<WriteCubit, WriteState>(
              builder: (context, state) {
                return Container(
                    color: Colors.grey,
                    width: 100.w,
                    height: 100.h,
                    child: Text(state.content + " " + state.input));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FocusScope.of(context).requestFocus(_focusNode);
          // widget.storage.saveWord("pred");
          // toggleKeyboard();
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
        actions: [
      GestureDetector(
        onTap: () {
          widget.storage.seeAll();
        },
        child: Icon(Icons.add),
      ),
      GestureDetector(
        onTap: () {
          widget.storage.deleteALl();
        },
        child: Icon(Icons.delete),
      ),
      GestureDetector(
        onTap: () {
          widget.storage.predictWord("p");
        },
        child: Icon(Icons.ac_unit),
      ),
    ]
            .map((e) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: e,
                ))
            .toList());
  }
}
