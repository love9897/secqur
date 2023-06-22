import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/enums/charging_status.dart';
import 'package:geolocator/geolocator.dart';

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






