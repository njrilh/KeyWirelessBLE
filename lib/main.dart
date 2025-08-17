import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:bluekey/screen.dart';
import 'package:bluekey/off.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  
bool blestatus = false;

@override
void initState() {
  super.initState();
  statusBlue();
}

void statusBlue() async{
FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
    if (state == BluetoothAdapterState.on) {
      setState(() => blestatus = true);
    } else if (state == BluetoothAdapterState.off) {
      setState(() => blestatus = false);
    }
});}

@override
Widget build(BuildContext context) {  
    return blestatus == true
    ? Screen() : Off();
}}