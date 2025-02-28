import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_viewmodel.dart';
import 'home_binding.dart';
import 'saved_date_plans_screen.dart';

class HomeView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedMenuProvider);
    return Scaffold(
      appBar: AppBar(title: Text("🎯 데이트 플래너")),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          HomeBinding.buildHomeButtons(context, ref),
          SavedDatePlansScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == 1) {
            ref.read(savedPlansProvider.notifier).loadSavedPlans();
          }
          ref.read(selectedMenuProvider.notifier).state = index;
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "저장된 플랜"),
        ],
      ),
    );
  }
}