// ignore_for_file: deprecated_member_use, non_constant_identifier_names, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Scan extends StatefulWidget {
  final Function(BluetoothDevice, BluetoothCharacteristic) onDeviceConnected;
  const Scan({super.key, required this.onDeviceConnected});

  @override
  State<Scan> createState() => ScanState();
}

class ScanState extends State<Scan> with AutomaticKeepAliveClientMixin{

@override
bool get wantKeepAlive => true;

List<ScanResult> scanResults = [];
List<BluetoothService> services = [];
BluetoothDevice? connectDevice;
BluetoothCharacteristic? BLEcharacteristic;
String codeVer = '6e7a6c';
String serchar = '';

@override
  // ignore: unnecessary_overrides
void initState() {
  super.initState();
  pindai();
}

void pindai() async {
  setState(() {
    scanResults.clear();
  });
  await Fluttertoast.showToast(
    msg: "Memindai...",
    backgroundColor: const Color.fromARGB(255, 88, 88, 88),
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
  FlutterBluePlus.startScan(timeout: Duration(seconds: 7));
  FlutterBluePlus.scanResults.listen((results) {
    setState(() => scanResults = results);
  });
}

void connectToDevice(BluetoothDevice device) async {
  try {
    await device.connect();
    setState(() => connectDevice = device);
    await FlutterBluePlus.stopScan();
    await Fluttertoast.showToast(
      msg: "Terconnect ke ${connectDevice!.name}",
      backgroundColor: const Color.fromARGB(255, 88, 88, 88),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    ); return discoverServices(device);

  } catch (e) {
    await Fluttertoast.showToast(
      msg: "Gagal Connect ke ${connectDevice!.name}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}

void discoverServices(BluetoothDevice device) async {
  services = await device.discoverServices();
  for (var service in services) {
    for (BluetoothCharacteristic characteristic in service.characteristics) {
      setState(() => serchar = "${service.uuid} - ${characteristic.uuid}");
      if (characteristic.properties.notify || characteristic.properties.write) {
        setState(() => BLEcharacteristic = characteristic);
        widget.onDeviceConnected(device, characteristic);
        verivikasi(characteristic);
      }
    }
  }
}

void verivikasi(BluetoothCharacteristic characteristic) async { 
  await characteristic.write(codeVer.codeUnits);
}

@override
Widget build(BuildContext context) {  
  super.build(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30), 
          child: Column(children: [
            Container(height: 30,),
            ElevatedButton(
              onPressed: pindai,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
              ),
              child: Text('Pindai', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, color: Colors.white),)
            ),
            Container(height: 20,),

            Expanded(
              child: ListView.builder(
                itemCount: scanResults.length,
                itemBuilder: (context, index) {
                  final result = scanResults[index];
                  return ListTile(
                    title: Text(result.device.name.isNotEmpty ? result.device.name : 'Unknown Device', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),),
                    subtitle: Text(result.device.toString()),
                    trailing: ElevatedButton(
                      onPressed: () => connectToDevice(result.device),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: connectDevice != null ? Colors.grey : Colors.brown,
                      ),
                      child: Text(connectDevice != null ? 'Terhubung':'Hubungkan', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, color: Colors.white),),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomSheet: Text(serchar, style: TextStyle(fontSize: 8),),
      )
    );
  }
}

