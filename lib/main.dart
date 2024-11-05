import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keeper/features/insights/data/insight_storage.dart';
import 'package:keeper/features/insights/data/repo_impl.dart';
import 'package:keeper/features/write/data/repo_impl.dart';
import 'package:keeper/features/write/presentation/screens/new_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'core/app_storage.dart';
import 'core/theme.dart';
import 'features/insights/presentaion/cubit/insight_cubit.dart';
import 'features/view_entries/presentation/list_cubit.dart';
import 'features/write/data/write_storage.dart';
import 'features/write/domain/entity/journal.dart';
import 'features/write/presentation/cubit/write_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var storage = AppStorage();
  await storage.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => InsightCubit(
            InsightRepositoryImpl(
              storage: InsightStorage(
                storage: storage,
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => ListCubit(
            WriteRepositoryImpl(WriteStorage(storage: storage)),
          ),
        ),
        BlocProvider(
          create: (_) => WriteCubit(
            WriteRepositoryImpl(WriteStorage(storage: storage)),
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
          home: NewPage(
            journal: Journal(dateTime: DateTime.now()),
          ),
        );
      },
    );
  }
}
