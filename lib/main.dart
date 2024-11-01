import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keeper/features/write/data/repo_impl.dart';
import 'package:keeper/features/write/presentation/screens/new_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'features/write/data/write_storage.dart';
import 'features/write/presentation/cubit/write_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var storage = WriteStorage();
  await storage.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WriteCubit(WriteRepositoryImpl())),
      ],
      child: MyApp(
        storage: storage,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final WriteStorage storage;

  const MyApp({super.key, required this.storage});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: NewPage(
          storage: storage,
        ),
      );
    });
  }
}
