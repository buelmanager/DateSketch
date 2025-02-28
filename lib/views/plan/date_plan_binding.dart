import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'date_plan_view_model.dart';

class DatePlanBinding {
  static List<Step> buildSteps(WidgetRef ref, BuildContext context) {
    final viewModel = ref.watch(datePlanViewModelProvider);
    return [
      Step(
        title: const Text("테마 선택"),
        content: _buildRadioOptions(ref, viewModel.selectedTheme, [
          "감성 힐링", "미식 데이트", "액티브 데이트", "야경 데이트", "이색 체험", "문화/공연"
        ], ref.read(datePlanViewModelProvider.notifier).updateTheme),
      ),
      Step(
        title: const Text("예산 선택"),
        content: _buildRadioOptions(ref, viewModel.selectedBudget, [
          "3만 원 이하", "5만~10만 원", "10만 원 이상"
        ], ref.read(datePlanViewModelProvider.notifier).updateBudget),
      ),
      Step(
        title: const Text("위치 설정"),
        content: Column(
          children: [
            _buildRadioOptions(ref, viewModel.selectedLocation, [
              "현재 위치 기반", "특정 지역 선택"
            ], (value) {
              ref.read(datePlanViewModelProvider.notifier).updateLocation(value);
              if (value == "특정 지역 선택") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapSelectionScreen(ref)),
                ).then((selectedLocation) {
                  print(selectedLocation);
                  if (selectedLocation == null) {
                    ref.read(datePlanViewModelProvider.notifier).updateLocation("현재 위치 기반");
                  }
                });
              }
            }),
          ],
        ),
      ),
      Step(
<<<<<<< HEAD
        title: Text("일정 구성"),
=======
        title: const Text("일정 구성"),
>>>>>>> develop
        content: _buildRadioOptions(ref, viewModel.selectedPlan, [
          "AI 자동 추천", "사용자 지정"
        ], ref.read(datePlanViewModelProvider.notifier).updatePlan),
      ),
    ];
  }

  static Widget _buildRadioOptions(
      WidgetRef ref, String selectedValue, List<String> options, Function(String) onChanged) {
    return Column(
      children: options.map((option) => RadioListTile(
        title: Text(option),
        value: option,
        groupValue: selectedValue,
        onChanged: (value) {
          onChanged(value as String);
        },
      )).toList(),
    );
  }
}

class MapSelectionScreen extends StatefulWidget {
  final WidgetRef ref;
  const MapSelectionScreen(this.ref, {super.key});

  @override
  _MapSelectionScreenState createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  GoogleMapController? _mapController;
  LatLng _selectedLocation = const LatLng(37.5665, 126.9780);

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  void _saveLocation() {
    widget.ref.read(datePlanViewModelProvider.notifier).updateLocation("위도: ${_selectedLocation.latitude}, 경도: ${_selectedLocation.longitude}");
    Navigator.pop(context, "위도: ${_selectedLocation.latitude}, 경도: ${_selectedLocation.longitude}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("지도에서 위치 선택"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
      ),
      body:Container(),
      // GoogleMap(
      //   initialCameraPosition: CameraPosition(
      //     target: _selectedLocation,
      //     zoom: 12,
      //   ),
      //   onMapCreated: _onMapCreated,
      //   onTap: _onTap,
      //   markers: {
      //     Marker(
      //       markerId: MarkerId("selectedLocation"),
      //       position: _selectedLocation,
      //     ),
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: _saveLocation,
      ),
    );
  }
}
