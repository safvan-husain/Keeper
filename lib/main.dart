import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keeper/features/write/data/repo_impl.dart';
import 'package:keeper/features/write/presentation/screens/new_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'core/theme.dart';
import 'features/write/data/write_storage.dart';
import 'features/write/presentation/cubit/write_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var storage = WriteStorage();
  await storage.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => WriteCubit(
            WriteRepositoryImpl(storage),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: const NewPage(),
        );
      },
    );
  }
}
