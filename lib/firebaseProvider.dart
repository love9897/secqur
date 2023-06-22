import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'datamodel.dart';

class DataProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> storeData(MyData data) async {
    // Store data in Firestore
    await _firestore.collection('data').add({
      'img': data.img,
      'pictureCount': data.picCount,
      'frequency': data.freq,
      'connectivityStatus': data.connectivityStatus,
      'batteryStatus': data.batteryStatus,
      'batteryPercentage': data.batteryPercentage,
      'longitude': data.longitude,
      'latitude': data.latitude,
    });

    // Store image in Firebase Storage
    final ref = _storage.ref().child('images').child('${data.img}');
    final file = File(data.img);
    await ref.putFile(file);

    notifyListeners();
  }
}
