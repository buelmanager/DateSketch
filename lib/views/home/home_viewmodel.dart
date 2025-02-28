import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final selectedMenuProvider = StateProvider<int>((ref) => 0);
final savedPlansProvider = StateNotifierProvider<SavedPlansNotifier, List<Map<String, dynamic>>>((ref) => SavedPlansNotifier());

class SavedPlansNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  SavedPlansNotifier() : super([]) {
    loadSavedPlans();
  }

  Future<void> loadSavedPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString("date_plans");
    if (savedData != null) {
      state = List<Map<String, dynamic>>.from(jsonDecode(savedData));
    }
  }

  Future<void> deletePlan(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    state = state.where((plan) => plan["uid"] != uid).toList();
    await prefs.setString("date_plans", jsonEncode(state));
  }

  Future<void> addPlan(Map<String, dynamic> newPlan) async {
    final prefs = await SharedPreferences.getInstance();
    state = [...state, newPlan];
    await prefs.setString("date_plans", jsonEncode(state));
  }
}