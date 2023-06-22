import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:secqur/camera.dart';
import 'package:secqur/datamodel.dart';
import 'package:secqur/firebaseProvider.dart';

import 'Provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<BatteryInfoProvider>(context, listen: false).fetchBatteryInfo();
    Provider.of<LocationInfoProvider>(context, listen: false)
        .getCurrentLocation();
    Provider.of<InternetStatusInfo>(context, listen: false)
        .checkInternetStatus();
  }

  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic>? data =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?;
    @override
    final battery = Provider.of<BatteryInfoProvider>(context);
    final location = Provider.of<LocationInfoProvider>(context);
    final connectivity = Provider.of<InternetStatusInfo>(context);
    final frequencyProvider = Provider.of<FrequencyProvider>(context);
    final frequencyInMinutes = frequencyProvider.frequencyInMinutes;
    final store = Provider.of<DataProvider>(context);

    final img = data?['image']?.path;
    final picCount = data?['pictureCount'];
    final freq = frequencyInMinutes;
    String connectivityStatus =
        connectivity.status == InternetStatus.off ? 'Off' : 'On';
    String batteryStatus = battery.isCharging ? 'On' : 'Off';
    String batteryPercentage = battery.batteryPercentage;
    final longitude = location.currentPosition?.longitude;
    final latitude = location.currentPosition?.latitude;

    final myData = MyData(
        img: img,
        picCount: picCount,
        freq: freq,
        connectivityStatus: connectivityStatus,
        batteryStatus: batteryStatus,
        batteryPercentage: batteryPercentage,
        longitude: longitude,
        latitude: latitude);

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Container(
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
                height: 200,
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
                  child: img != null
                      ? Image.file(File(img), fit: BoxFit.fitWidth)
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
                            "${picCount ?? 0}",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.green),
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
                          InkWell(
                            onTap: () {
                              frequencyProvider.showFrequencyDialog(
                                  context, frequencyProvider);
                            },
                            child: Text(
                              '$freq ',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.green),
                            ),
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
                            connectivityStatus,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.green),
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
                            batteryStatus,
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
                            '$batteryPercentage %',
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
                            ' ${longitude ?? 'Unknown'} ${latitude ?? 'Unknown'}',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.green),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(0, 102, 102, 100),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.only(left: 50, right: 50),
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
                              store.storeData(myData);
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
      ),
    );
  }
}

String getCurrentDateTime() {
  var now = DateTime.now();
  var formatter = DateFormat('dd-MM-yyyy HH:mm:ss');
  return formatter.format(now);
}
