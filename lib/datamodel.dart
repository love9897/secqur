class MyData {
  final img;
  final picCount;
  final freq;
  String connectivityStatus;
  String batteryStatus;
  String batteryPercentage;
  final longitude;
  final latitude;

  MyData(
      {required this.img,
      required this.picCount,
      required this.freq,
      required this.connectivityStatus,
      required this.batteryStatus,
      required this.batteryPercentage,
      required this.longitude,
      required this.latitude});
}
