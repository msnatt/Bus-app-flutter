import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class StationScreen extends StatefulWidget {
  const StationScreen({super.key});

  @override
  _StationScreenState createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic> stations = {}; // เก็บข้อมูลสถานีจาก JSON
  double radiusbtn = 24;
  double height = 50;
  double width = 90;
  String name_station = "";
  String data_station = "";
  var allow_gps = false;

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final String response = await rootBundle.loadString('assets/station.json');
    final Map<String, dynamic> jsonData = json.decode(response);
    setState(() {
      stations = jsonData["stations"];
    });
  }

  void loadDataStationSelected(String select_station) async {
    // ตรวจสอบว่ามีคีย์ของสถานีที่เลือกหรือไม่
    if (stations.containsKey(select_station)) {
      var station = stations[select_station]; // ดึงข้อมูลของสถานีนั้น
      setState(() {
        name_station = station['name'];
        data_station = station['data'];
      });
    } else {
      print("ไม่พบสถานีที่เลือก");
    }
  }

  void showStationPopup(BuildContext context, String name, String data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            name,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                data,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด popup
              },
              child: const Text("ปิด", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  
                  const SizedBox(height: 40),
                  const SizedBox(
                    height: 60 ,
                    child: Text(
                    'เลือกสถานีเพื่อดูข้อมูล',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ), // เว้นที่ด้านบน
                  
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      children: stations.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              showStationPopup(
                                context,
                                entry.value["name"], // ชื่อสถานี
                                entry.value["data"], // รายละเอียด
                              );
                            },
                            child: Text(
                              entry.value["name"],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Expanded(
                  //   child: SingleChildScrollView(
                  //     child: Wrap(
                  //       alignment: WrapAlignment.center, // จัดให้อยู่ตรงกลาง
                  //       spacing: 10, // ระยะห่างระหว่างปุ่ม
                  //       runSpacing: 10, // ระยะห่างระหว่างแถว
                  //       children: stations.entries.map((entry) {
                  //         return ConstrainedBox(
                  //           constraints: BoxConstraints(
                  //               minWidth: 170, // ปรับขนาดขั้นต่ำของปุ่ม
                  //               maxWidth: 170),
                  //           child: ElevatedButton(
                  //             onPressed: () {
                  //               showStationPopup(
                  //                 context,
                  //                 entry.value["name"], // ชื่อสถานี
                  //                 entry.value["data"], // รายละเอียด
                  //               );
                  //             },
                  //             child: Text(
                  //               entry.value["name"],
                  //               style: TextStyle(
                  //                   color: Colors.black,
                  //                   fontWeight: FontWeight.bold),
                  //             ),
                  //           ),
                  //         );
                  //       }).toList(),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          // ปุ่มย้อนกลับอยู่บนซ้าย
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 16), // ปรับตำแหน่ง
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                mini: true,
                elevation: 3,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
