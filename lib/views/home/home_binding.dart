import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../plan/date_plan_setup_screen.dart';
import 'home_viewmodel.dart';

class HomeBinding {
  static Widget buildHomeButtons(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              ref.read(selectedMenuProvider.notifier).state = 1;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DatePlanSetupScreen()),
              ).then((_) {
                ref.read(selectedMenuProvider.notifier).state = 0;
              });
            },
            child: const Text("📌 데이트 플랜 설정"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // 랜덤 데이트 플랜 기능 추가 가능
            },
            child: const Text("🎲 랜덤 데이트 플랜"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // 인기 있는 데이트 코스 기능 추가 가능
            },
            child: const Text("🔥 인기 데이트 코스"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // 데이트 팁 & 리뷰 기능 추가 가능
            },
            child: const Text("💡 데이트 팁 & 리뷰"),
          ),
        ],
      ),
    );
  }
}