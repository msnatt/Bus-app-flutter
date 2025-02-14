import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_appbus/api/func.dart';
import 'package:my_appbus/screen/bus.dart';
import 'package:my_appbus/screen/maps.dart';

class MenuScreen extends StatefulWidget {
  final String ipAddress;

  const MenuScreen({super.key, required this.ipAddress});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final Func function = Func();
  Timer? _timer;
  LatLng? currentLocation;
  String Stationtext = "กำลังค้นหาสถานี..";

  @override
  void initState() {
    super.initState();
    startLocationUpdates();
  }

  void startLocationUpdates() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      LatLng? newLocation = await function.trackLocation();
      List<dynamic> stations = await function.Fetch_Stations();
      Map<String, dynamic>? station = await function.findNearestStation(newLocation, stations);

      currentLocation = newLocation;
      if (station?['distance'] <= 50) {
        setState(() {
          Stationtext = station?['name'];
        });
      } else {
                setState(() {
          Stationtext = "กำลังค้นหาสถานี..";
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // หยุด Timer เมื่อ Widget ถูกทำลาย
    super.dispose();
  }

  Future<void> findstationonload() async {
    LatLng? currentLocation_ = await function.trackLocation();
  }

  @override
  Widget build(BuildContext context) {
    double radiusbtn = 24;
    double height = 100;
    double width = 110;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bus App'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'เลือกเมนูที่ต้องการ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                Stationtext,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: width,
                    height: height,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.zero, // ลบ padding เพื่อให้รูปเต็มปุ่ม
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radiusbtn),
                        ),
                      ),
                      onPressed: () async {
                        var success = await function.AddPassenger();
                        if (success) {
                          var snackBar = function.showSuccessToast();
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Failed to create data get",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radiusbtn),
                          image: const DecorationImage(
                            image: AssetImage(
                                'assets/images/seach_btn.png'), // ใช้รูปภาพ
                            fit: BoxFit.cover, // ขยายรูปให้เต็มขนาดปุ่ม
                          ),
                        ),
                        child: Container(), // ใช้ Container เป็นลูกของ Ink
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    height: height,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.zero, // ลบ padding เพื่อให้รูปเต็มปุ่ม
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radiusbtn),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  maps(ipAddress: widget.ipAddress)),
                        );
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radiusbtn),
                          image: const DecorationImage(
                            image: AssetImage(
                                'assets/images/map_btn.png'), // ใช้รูปภาพ
                            fit: BoxFit.cover, // ขยายรูปให้เต็มขนาดปุ่ม
                          ),
                        ),
                        child: Container(), // ใช้ Container เป็นลูกของ Ink
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: width,
                    height: height,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.zero, // ลบ padding เพื่อให้รูปเต็มปุ่ม
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radiusbtn),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Bus(ipAddress: widget.ipAddress)),
                        );
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radiusbtn),
                          image: const DecorationImage(
                            image: AssetImage(
                                'assets/images/station_btn.png'), // ใช้รูปภาพ
                            fit: BoxFit.cover, // ขยายรูปให้เต็มขนาดปุ่ม
                          ),
                        ),
                        child: Container(), // ใช้ Container เป็นลูกของ Ink
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    height: height,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.zero, // ลบ padding เพื่อให้รูปเต็มปุ่ม
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radiusbtn),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Bus(ipAddress: widget.ipAddress)),
                        );
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radiusbtn),
                          image: const DecorationImage(
                            image: AssetImage(
                                'assets/images/bus_btn.png'), // ใช้รูปภาพ
                            fit: BoxFit.cover, // ขยายรูปให้เต็มขนาดปุ่ม
                          ),
                        ),
                        child: Container(), // ใช้ Container เป็นลูกของ Ink
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
