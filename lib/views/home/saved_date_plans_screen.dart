import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_viewmodel.dart';

class SavedDatePlansScreen extends ConsumerWidget {
  const SavedDatePlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedPlans = ref.watch(savedPlansProvider);
    return Scaffold(
      //appBar: AppBar(title: Text("📅 저장된 데이트 플랜")),
      body: savedPlans.isEmpty
          ? const Center(child: Text("저장된 데이트 플랜이 없습니다."))
          : ListView.builder(
        itemCount: savedPlans.length,
        itemBuilder: (context, index) {
          final plan = savedPlans[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: ListTile(
              title: Text("테마: ${plan["theme"]}"),
              subtitle: Text("저장 날짜: ${plan["created_at"]}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(context, ref, plan["uid"]),
              ),
              onTap: () => _showPlanDetails(context, ref, plan),
            ),
          );
        },
      ),
    );
  }

  void _showPlanDetails(BuildContext context, WidgetRef ref, Map<String, dynamic> plan) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("📅 데이트 플랜 상세 정보"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("✅ 테마: ${plan["theme"]}"),
              Text("💰 예산: ${plan["budget"]}"),
              Text("📍 위치: ${plan["location"]}"),
              Text("📌 일정 계획: ${plan["plan"]}"),
              Text("📆 저장 날짜: ${plan["created_at"]}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("닫기"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _confirmDelete(context, ref, plan["uid"]);
              },
              child: const Text("삭제", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String uid) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("삭제 확인"),
          content: const Text("정말로 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ref.read(savedPlansProvider.notifier).deletePlan(uid);
              },
              child: const Text("삭제", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}