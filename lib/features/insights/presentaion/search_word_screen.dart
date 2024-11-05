import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/insight_cubit.dart';

class SearchInsight extends StatelessWidget {
  const SearchInsight({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Type word here",
            ),
            onChanged: context.read<InsightCubit>().getPossibleWords,
          ),
        ),
      ),
      body: BlocBuilder<InsightCubit, InsightState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.availableWords.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    context.read<InsightCubit>().showInsightFor(index);
                  },
                  child: ListTile(
                    title: Text(state.availableWords.elementAt(index)),
                  ));
            },
          );
        },
      ),
    );
  }
}
