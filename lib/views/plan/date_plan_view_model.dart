import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatePlanViewModel extends StateNotifier<DatePlanState> {
  DatePlanViewModel() : super(DatePlanState());

  void updateStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void updateTheme(String theme) {
    state = state.copyWith(selectedTheme: theme);
  }

  void updateBudget(String budget) {
    state = state.copyWith(selectedBudget: budget);
  }

  void updateLocation(String location) {
    state = state.copyWith(selectedLocation: location);
  }

  void updatePlan(String plan) {
    state = state.copyWith(selectedPlan: plan);
  }
}

class DatePlanState {
  final int currentStep;
  final String selectedTheme;
  final String selectedBudget;
  final String selectedLocation;
  final String selectedPlan;

  DatePlanState({
    this.currentStep = 0,
    this.selectedTheme = "감성 힐링",
    this.selectedBudget = "5만~10만 원",
    this.selectedLocation = "현재 위치 기반",
    this.selectedPlan = "AI 자동 추천",
  });

  DatePlanState copyWith({
    int? currentStep,
    String? selectedTheme,
    String? selectedBudget,
    String? selectedLocation,
    String? selectedPlan,
  }) {
    return DatePlanState(
      currentStep: currentStep ?? this.currentStep,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      selectedBudget: selectedBudget ?? this.selectedBudget,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedPlan: selectedPlan ?? this.selectedPlan,
    );
  }
}

final datePlanViewModelProvider = StateNotifierProvider<DatePlanViewModel, DatePlanState>((ref) {
  return DatePlanViewModel();
});
