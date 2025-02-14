import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:my_appbus/api/func.dart';
import 'dart:convert';
import '../api/bus_api.dart';

class maps extends StatefulWidget {
  final String ipAddress; // รับ ipAddress จากหน้า PinCodeWidget

  const maps(
      {super.key, required this.ipAddress}); // รับ ipAddress จาก constructor

  @override
  State<maps> createState() => _mapsState();
}

class _mapsState extends State<maps> {
  final MapController _mapController = MapController();
  final Func function = Func();
  String selectedRoute = 'BUS101';
  List<String> busRoutes = [];
  List<dynamic> allStations = [];
  String _data = '';
  String _data2 = '';
  LatLng? apiLocation; // ตัวแปรเก็บตำแหน่งจาก API
  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
    function.trackLocation();
    fetchBusRoutes();
  }

  void fetchBusRoutes() async {
    List<String> routes = await function.Fetch_Bus();
    setState(() {
      busRoutes = routes;
    });
  }

  void setcentermap(LatLng location) {
    _mapController.move(location, 15.0);
  }

// ============================== UI ==================================
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: 40, // ตำแหน่งจากด้านบน
        left: 20, // ตำแหน่งจากด้านซ้าย
        child: FloatingActionButton(
          backgroundColor: Colors.white, // สีพื้นหลังปุ่ม
          elevation: 5, // เงาให้ดูมีมิติ
          mini: true, // ทำให้ปุ่มเล็กลง
          onPressed: () {
            Navigator.pop(context); // ย้อนกลับไปหน้าก่อนหน้า
          },
          child: Icon(Icons.arrow_back, color: Colors.black), // ไอคอนลูกศร
        ),
      ),
      Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter:
                      //currentLocation ?? LatLng(7.167384, 100.613034),     //songkla
                      currentLocation ?? LatLng(13.8097, 100.66), //bkk
                  initialZoom: 5,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.evo.app',
                    maxNativeZoom: 19,
                  ),
                  MarkerLayer(
                    markers: [
                      if (currentLocation != null)
                        Marker(
                          point: currentLocation!,
                          width: 80,
                          height: 80,
                          child: const Icon(Icons.location_on,
                              size: 40, color: Colors.red),
                        ),
                      if (apiLocation != null)
                        Marker(
                          point: apiLocation!,
                          width: 80,
                          height: 80,
                          child: const Icon(Icons.directions_bus,
                              size: 40, color: Colors.green),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), //
            const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "เลือกรถบัส",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedRoute,
                    icon: const Icon(Icons.arrow_drop_down, size: 30),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRoute = newValue!;
                      });
                    },
                    items:
                        busRoutes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        onPressed: () async {
                          var success =
                              await function.createDataSearch(selectedRoute);

                          if (success != null) {
                            setState(() {
                              // อัปเดตค่าและบังคับให้ FlutterMap รีเรนเดอร์
                              apiLocation = success;
                            });
                            var snackBar =
                                function.searchSuccessToast(selectedRoute);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            setcentermap(apiLocation ?? LatLng(13.81, 100.66));
                          } else {
                            Fluttertoast.showToast(
                              msg: "Failed to connected please try again.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        child: const Text('ค้นหา'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        onPressed: () async {
                          var success = await function.AddPassenger();
                          if (success) {
                            var snackBar = function.showSuccessToast();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
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
                        child: const Text('เรียกรถ'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  // SizedBox(
                  //   height: 100,
                  //   child: SingleChildScrollView(
                  //     child: Text(_data),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 100,
                  //   child: SingleChildScrollView(
                  //     child: Text(_data2),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
