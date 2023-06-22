import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/enums/charging_status.dart';
import 'package:geolocator/geolocator.dart';

import 'homePage.dart';

class BatteryInfoProvider with ChangeNotifier {
  String _batteryPercentage = 'Unknown';
  bool _isCharging = false;

  String get batteryPercentage => _batteryPercentage;
  bool get isCharging => _isCharging;

  Future<void> fetchBatteryInfo() async {
    try {
      BatteryInfoPlugin batteryInfo = BatteryInfoPlugin();
      var batteryStatus = await batteryInfo.androidBatteryInfo;
      _batteryPercentage = '${batteryStatus?.batteryLevel.toString()}';
      _isCharging = batteryStatus?.chargingStatus == ChargingStatus.Charging;

      notifyListeners();
    } catch (e) {
      print('Failed to get battery info: $e');
    }
  }
}

class LocationInfoProvider with ChangeNotifier {
  Position? _currentPosition;

  Position? get currentPosition => _currentPosition;

  Future<void> getCurrentLocation() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return Future.error("Lcoation service are disable");
    }
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          return Future.error('Location permission are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied,we cannot request');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = position;
      notifyListeners();
    } catch (e) {
      // Handle error while getting location
    }
  }
}

enum InternetStatus {
  on,
  off,
}

class InternetStatusInfo with ChangeNotifier {
  InternetStatus _status = InternetStatus.on;

  InternetStatus get status => _status;

  Future<void> checkInternetStatus() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _status = InternetStatus.off;
    } else {
      _status = InternetStatus.on;
    }
    notifyListeners();
  }
}

class CameraProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  CameraController? controller;
  XFile? imageFile;
  int pictureCount = 0;
  bool isTakingPicture = false;

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      controller = CameraController(cameras[0], ResolutionPreset.high);
      await controller!.initialize();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> takePicture(BuildContext context) async {
    if (controller!.value.isInitialized && !isTakingPicture) {
      try {
        isTakingPicture = true;

        final image = await controller!.takePicture();
        imageFile = XFile(image.path);

        pictureCount++;
        print(pictureCount);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MyHomePage(),
            settings: RouteSettings(
              arguments: {'image': imageFile, 'pictureCount': pictureCount},
            ),
          ),
        );
      } catch (e) {
        print('Error capturing image: $e');
      } finally {
        isTakingPicture = false;
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class FrequencyProvider extends ChangeNotifier {
  int _frequencyInMinutes = 5; // Initial frequency value in minutes

  int get frequencyInMinutes => _frequencyInMinutes;

  void setFrequency(int minutes) {
    _frequencyInMinutes = minutes;
    notifyListeners();
  }

  Future<void> showFrequencyDialog(
      BuildContext context, FrequencyProvider frequencyProvider) async {
    final newFrequency = await showDialog<int>(
      context: context,
      builder: (context) {
        int selectedFrequency = frequencyProvider.frequencyInMinutes;
        return AlertDialog(
          title: Text('Change Frequency'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              selectedFrequency = int.tryParse(value) ?? selectedFrequency;
            },
            decoration: InputDecoration(labelText: 'Frequency'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () => Navigator.pop(context, selectedFrequency),
            ),
          ],
        );
      },
    );

    if (newFrequency != null) {
      frequencyProvider.setFrequency(newFrequency);
    }
  }
}
