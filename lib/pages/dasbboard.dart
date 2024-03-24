import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patuhapps/pages/akunlogin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class PelanggaranKategoriData {
  final int total;
  final String kategori;

  PelanggaranKategoriData({required this.total, required this.kategori});
  factory PelanggaranKategoriData.fromJson(Map<String, dynamic> json) {
    return PelanggaranKategoriData(
      total: json['total_siswa'],
      kategori: json['nama'],
    );
  }
}

//kategori pelanggaran
Future<List<PelanggaranKategoriData>> fetchPelanggaranKategoriData() async {
  final dynamic apiUrl = Uri.parse(
    "https://sipatuhbackend.adipramanacomputer.com/dashboardapi/kategoripelanggaran",
  );
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('tokenJwt') ?? '';
  try {
    final response = await http.get(apiUrl, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': token,
    });
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<PelanggaranKategoriData> kategoriData = jsonData
          .map((jsonItem) => PelanggaranKategoriData.fromJson(jsonItem))
          .toList();
      return kategoriData;
    } else {
      throw Exception('Gagal mengambil data: ${response.statusCode}');
    }
  } catch (e) {
    if (e
        .toString()
        .contains("Connection closed before full header was received")) {
      // Handle the specific error condition here
      // You can add custom handling logic for this case
      Get.snackbar(
        'Gagal meload data',
        "Error:{$e} Connection closed before full header was received",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.add_alert),
      );
    }
    throw e;
  }
}

//cek data pelanggaran
//Count pelanggaran
Future<int> countPelanggaran() async {
  final dynamic apiUrl = Uri.parse(
    "https://sipatuhbackend.adipramanacomputer.com/dashboardapi/countpelanggaran",
  );
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('tokenJwt') ?? '';
  try {
    final response = await http.get(apiUrl, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': token,
    });
    if (response.statusCode == 200) {
      // API mengembalikan respons dengan kode status 200 (OK).
      // Ubah respons JSON ke integer (total siswa).
      int totalPelanggaran = int.parse(response.body);
      return totalPelanggaran;
    } else {
      // Tangani kesalahan jika respons tidak berhasil.
      throw Exception('Gagal mengambil data total Pelanggaran');
    }
  } catch (e) {
    if (e
        .toString()
        .contains("Connection closed before full header was received")) {
      // Handle the specific error condition here
      // You can add custom handling logic for this case
      Get.snackbar(
        'Gagal meload data',
        "Error:{$e} Connection closed before full header was received",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.add_alert),
      );
    }
    rethrow;
  }
}

//cek data siswa
Future<int> countSiswa() async {
  final dynamic apiUrl = Uri.parse(
      "https://sipatuhbackend.adipramanacomputer.com/dashboardapi/countsiswa");
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('tokenJwt') ?? '';
  try {
    final response = await http.get(apiUrl, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': token,
    });
    if (response.statusCode == 200) {
      // API mengembalikan respons dengan kode status 200 (OK).
      // Ubah respons JSON ke integer (total siswa).
      int totalSiswa = int.parse(response.body);
      return totalSiswa;
    } else {
      // Tangani kesalahan jika respons tidak berhasil.
      throw Exception('Gagal mengambil data total siswa');
    }
  } catch (e) {
    if (e
        .toString()
        .contains("Connection closed before full header was received")) {
      // Handle the specific error condition here
      // You can add custom handling logic for this case
      Get.snackbar(
        'Gagal meload data',
        "Error:{$e} Connection closed before full header was received",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.add_alert),
      );
    }
    rethrow;
  }
}

//count Data Hari ini
Future<int> countPelanggaranToday() async {
  final dynamic apiUrl = Uri.parse(
    "https://sipatuhbackend.adipramanacomputer.com/dashboardapi/counthariini",
  );
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('tokenJwt') ?? '';
  try {
    final response = await http.get(apiUrl, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': token,
    });
    if (response.statusCode == 200) {
      // API mengembalikan respons dengan kode status 200 (OK).
      // Ubah respons JSON ke integer (total siswa).
      int totalSiswa = int.parse(response.body);
      return totalSiswa;
    } else {
      // Tangani kesalahan jika respons tidak berhasil.
      throw Exception('Gagal mengambil data total siswa');
    }
  } catch (e) {
    if (e
        .toString()
        .contains("Connection closed before full header was received")) {
      // Handle the specific error condition here
      // You can add custom handling logic for this case
      Get.snackbar(
        'Gagal meload data',
        "Error:{$e} Connection closed before full header was received",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.add_alert),
      );
    }
    rethrow;
  }
}

class AuthService {
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> check() async {
    final prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(
        'https://sipatuhbackend.adipramanacomputer.com/indexapi/checkloginstate');
    final token = prefs.getString('tokenJwt') ?? '';
    final response = await http.get(url, headers: {'Cookie': token});
    final data = json.decode(response.body);
    if (data['status']) {
      Get.to(() => Dashboard());
    } else {
      Get.to(() => AkunLogin());
    }
  }
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TooltipBehavior _tooltipBehaviorKategori;
  late TooltipBehavior _tooltipBehaviorPelanggaranToday;
  late TooltipBehavior _tooltipBehaviorPelanggaranPerKelas;
  @override
  void initState() {
    super.initState();
    AuthService.check();
    _tooltipBehaviorKategori = TooltipBehavior(enable: true);
    _tooltipBehaviorPelanggaranToday = TooltipBehavior(enable: true);
    _tooltipBehaviorPelanggaranPerKelas = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff3a57e7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          "Nanti",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Color(0xffffffff),
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              color: Color(0xffffffff),
              onPressed: () => Scaffold.of(context).openDrawer(),
              iconSize: 24,
            );
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child:
                Icon(Icons.account_circle, color: Color(0xffffffff), size: 40),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff3a57e7),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 70,
        width: 70,
        margin: EdgeInsets.only(top: 5.0),
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {},
            child: Icon(
              Icons.qr_code,
              color: Colors.white,
            ),
            // Define the shape of the FAB here
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  30), // Adjust radius for your preference
            ),
            backgroundColor: Color(0xff3a57e7),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff3a57e7),
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: () {
                // Define the action when this button is pressed
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            GridView(
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              children: [
                Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xff3b58ea),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FutureBuilder<int>(
                          future: countSiswa(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (snapshot.hasData) {
                              return Text(
                                snapshot.data.toString(),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 25,
                                  color: Color(0xffa6def1),
                                ),
                              );
                            } else {
                              return Text('No Data');
                            }
                          }),
                      Text(
                        "Siswa",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 10,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xff3a57e6),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FutureBuilder<int>(
                        future: countPelanggaran(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            return Text(
                              snapshot.data.toString(),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 30,
                                color: Color(0xffa4ddf0),
                              ),
                            );
                          }
                        },
                      ),
                      Text(
                        "Pelanggaran",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 10,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xff3b58e9),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FutureBuilder<int>(
                        future: countPelanggaranToday(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            return Text(
                              snapshot.data.toString(),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 30,
                                color: Color(0xffa4ddf0),
                              ),
                            );
                          }
                        },
                      ),
                      Text(
                        "Hari ini",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 10,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            GridView(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.3,
              ),
              children: [
                Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xff3a57e9),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Kategori Pelanggaran",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 15,
                          color: Color(0xffffffff),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<PelanggaranKategoriData>>(
                          future: fetchPelanggaranKategoriData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else {
                              List<PelanggaranKategoriData>
                                  _pelanggaranKategoriData = snapshot.data!;

                              return SfCircularChart(
                                palette: const <Color>[
                                  Colors.amber,
                                  Colors.lightBlue,
                                  Colors.white,
                                  Colors.purple
                                ],
                                tooltipBehavior: _tooltipBehaviorKategori,
                                // legend: Legend(
                                //   isVisible: true,
                                //   overflowMode: LegendItemOverflowMode.wrap,
                                // ),
                                series: <CircularSeries>[
                                  DoughnutSeries<PelanggaranKategoriData,
                                      String>(
                                    dataSource: _pelanggaranKategoriData,
                                    xValueMapper:
                                        (PelanggaranKategoriData data, _) =>
                                            data.kategori,
                                    yValueMapper:
                                        (PelanggaranKategoriData data, _) =>
                                            data.total,
                                    dataLabelSettings: const DataLabelSettings(
                                        isVisible: true),
                                    enableTooltip: true,
                                    sortingOrder: SortingOrder.descending,
                                  )
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xff3a57e9),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Hari ini",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 15,
                          color: Color(0xffffffff),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<PelanggaranKategoriData>>(
                          future: fetchPelanggaranKategoriData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else {
                              List<PelanggaranKategoriData>
                                  _pelanggaranKategoriData = snapshot.data!;

                              return SfCircularChart(
                                palette: const <Color>[
                                  Colors.amber,
                                  Colors.lightBlue,
                                  Colors.white,
                                  Colors.purple
                                ],
                                tooltipBehavior: _tooltipBehaviorKategori,
                                // legend: Legend(
                                //   isVisible: true,
                                //   overflowMode: LegendItemOverflowMode.wrap,
                                // ),
                                series: <CircularSeries>[
                                  DoughnutSeries<PelanggaranKategoriData,
                                      String>(
                                    dataSource: _pelanggaranKategoriData,
                                    xValueMapper:
                                        (PelanggaranKategoriData data, _) =>
                                            data.kategori,
                                    yValueMapper:
                                        (PelanggaranKategoriData data, _) =>
                                            data.total,
                                    dataLabelSettings: const DataLabelSettings(
                                        isVisible: true),
                                    enableTooltip: true,
                                    sortingOrder: SortingOrder.descending,
                                  )
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
