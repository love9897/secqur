import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:secqur/camera.dart';
import 'package:path/path.dart' as path;

import 'Provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final imageFile = ModalRoute.of(context)?.settings.arguments as XFile?;
    // final picturecount = ModalRoute.of(context)?.settings.arguments as int?;
    final Map<dynamic, dynamic>? data =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?;
    @override
    var battery = Provider.of<BatteryInfoProvider>(context);
    var location = Provider.of<LocationInfoProvider>(context);
    var connectivity = Provider.of<InternetStatusInfo>(context);

    @override
    void initState() {
      battery;
      location;
    }

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 150,
              child: Image.asset(
                'image/logo.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            Text(
              getCurrentDateTime(),
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 150,
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraPage(),
                    ),
                  );
                },
                child: data?['image'] != null
                    ? Image.file(File(data?['image']?.path),
                        fit: BoxFit.fitWidth)
                    : Image.asset(
                        'image/defaultImage.png',
                        fit: BoxFit.fitWidth,
                        color: Color.fromRGBO(157, 113, 0, 100),
                      ),
              ),
            ),
            Card(
              color: Colors.black,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 20.0,
                  runSpacing: 15.0,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Capture Count',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.white),
                        ),
                        Text(
                          "${data?['pictureCount'] ?? 0}",
                          style: TextStyle(fontSize: 16.0, color: Colors.green),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Frequency (Min)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.white),
                        ),
                        Text(
                          '18',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Connectivity',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.white),
                        ),
                        Text(
                          connectivity.status == InternetStatus.off
                              ? 'Off'
                              : 'On',
                          style: TextStyle(fontSize: 16.0, color: Colors.green),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Battery Charging',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.white),
                        ),
                        Text(
                          '${battery.isCharging ? 'On' : 'Off'}',
                          style: TextStyle(fontSize: 16, color: Colors.green),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Battery Charge',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.white),
                        ),
                        Text(
                          '${battery.batteryPercentage}%',
                          style: TextStyle(fontSize: 16, color: Colors.green),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.white),
                        ),
                        Text(
                          ' ${location.currentPosition?.longitude ?? 'Unknown'} ${location.currentPosition?.latitude ?? 'Unknown'}',
                          style: TextStyle(fontSize: 16.0, color: Colors.green),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(0, 102, 102, 100),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.only(left: 50, right: 50),

                              // maximumSize: Size.fromWidth(double.infinity),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          child: Text(
                            "Mannual Data Refresh",
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            location.getCurrentLocation();
                            battery.fetchBatteryInfo();
                            connectivity.checkInternetStatus();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

String getCurrentDateTime() {
  var now = DateTime.now();
  var formatter = DateFormat('dd-MM-yyyy HH:mm:ss');
  return formatter.format(now);
}
