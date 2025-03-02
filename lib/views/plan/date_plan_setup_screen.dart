import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/home_view.dart';
import '../home/home_viewmodel.dart';
import 'date_plan_view_model.dart';
import 'date_plan_binding.dart';

class DatePlanSetupScreen extends ConsumerWidget {
  const DatePlanSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(datePlanViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("📌 데이트 플랜 설정")),
      body: Stepper(
        currentStep: viewModel.currentStep,
        onStepTapped: (step) {
          ref.read(datePlanViewModelProvider.notifier).updateStep(step);
        },
        onStepContinue: () async {
          if (viewModel.currentStep < 3) {
            ref.read(datePlanViewModelProvider.notifier).nextStep();
          } else {
            await _saveDatePlan(viewModel);
            await _loadDatePlans();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DatePlanResultScreen()),
            );
          }
        },
        onStepCancel: () {
          if (viewModel.currentStep > 0) {
            ref.read(datePlanViewModelProvider.notifier).previousStep();
          }
        },
        steps: DatePlanBinding.buildSteps(ref, context),
      ),
    );
  }

  Future<void> _saveDatePlan(DatePlanState viewModel) async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString("date_plans");
    List<Map<String, dynamic>> datePlans = savedData != null ? List<Map<String, dynamic>>.from(jsonDecode(savedData)) : [];

    const uuid = Uuid();
    final String timestamp = DateTime.now().toLocal().toString();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("⚠️ 유저가 로그인되어 있지 않습니다.");

      return;
    }

    final datePlanData = {
      "uid": uuid.v4(), // 고유 UID 생성
      "user_uid": user.uid, // 유저 UID 저장
      "theme": viewModel.selectedTheme,
      "budget": viewModel.selectedBudget,
      "location": viewModel.selectedLocation,
      "plan": viewModel.selectedPlan,
      "group": "기본 그룹",
      "created_at": timestamp // 저장된 날짜 및 시간 추가
    };

    // SharedPreferences에 저장
    datePlans.add(datePlanData);
    await prefs.setString("date_plans", jsonEncode(datePlans));
    if (kDebugMode) {
      print("📌 datePlanData : $datePlanData");
      print("📌 datePlanData[uid] : ${datePlanData["uid"]}");
    }

    // Firestore에 저장
    await FirebaseFirestore.instance.collection("date_plans").doc(datePlanData["uid"]).set(datePlanData);
    print("📌 저장된 데이트 플랜 목록 (Firestore): ${jsonEncode(datePlanData)}");
  }

  Future<void> _loadDatePlans() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString("date_plans");
    if (savedData != null) {
      final List<dynamic> datePlans = jsonDecode(savedData);
      print("✅ 불러온 데이트 플랜 목록: $datePlans");
    } else {
      print("⚠️ 저장된 데이터가 없습니다.");
    }
  }
}

class DatePlanResultScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(datePlanViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("📅 데이트 플랜 결과")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("✅ 테마: ${viewModel.selectedTheme}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("💰 예산: ${viewModel.selectedBudget}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("📍 위치: ${viewModel.selectedLocation}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("📌 일정 계획: ${viewModel.selectedPlan}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ref.read(selectedMenuProvider.notifier).state = 0;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeView()),
                        (Route<dynamic> route) => false,
                  );
                },
                child: const Text("🏡 메인 메뉴로 돌아가기"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}