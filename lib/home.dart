// ignore_for_file: deprecated_member_use, duplicate_ignore, unnecessary_null_comparison
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  final BluetoothCharacteristic? Function() getCharacteristic;
  const Home({super.key, required this.getCharacteristic,});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin{

BluetoothCharacteristic? get char => widget.getCharacteristic();
String data = "...";

@override
bool get wantKeepAlive => true;
bool isSwitchOn = false;
bool kontak = false;
bool stater = false;
bool hazard = false;
bool suhu = false;

String codeKontakOn = '6e316c';
String codeKontakOff = '0a';
String codeBeep = '1b';
String codeStaterOn = '1c';
String codeStaterOff = '0c';
String codeSuhuOn = '1d';
String codeSuhuOff = '0d';

@override
void initState() {
  super.initState();
  Timer.periodic(Duration(seconds: 10), (timer) {
      terimaData();
    });
}

void kirimData(String message) async{
  if (char != null) {
    await char!.write(message.codeUnits);
    await Fluttertoast.showToast(
      msg: "Request berhasil",
      backgroundColor: const Color.fromARGB(255, 88, 88, 88),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}

void terimaData() async {
  if (char != null) {
    if (suhu == true) {
      List<int> value = await char!.read();
      setState (() => data = String.fromCharCodes(value));
  }}
}

@override
Widget build(BuildContext context) {
  super.build(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 70),
            child: Column(
              children: [
                Container(
                  height: 60,
                  ),
                GestureDetector(
                  onTap:() {
                    setState(()  => kontak = !kontak); 
                    kirimData(kontak ? codeKontakOn : codeKontakOff);
                    }, 
                  child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        width: double.infinity, 
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: kontak ?  Colors.brown : Colors.grey,
                          boxShadow: [BoxShadow(
                            color: Colors.black,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          )]
                        ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                              children: <Widget>[
                                Text(kontak ? 'Kontak ON' : 'Kontak OFF', style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.bold, color: kontak ? Colors.white : Colors.black),),
                                Icon(kontak ? Icons.key_outlined : Icons.key_off_outlined, color: kontak ? Colors.white : Colors.black,),
                            ],)
                          )
                        )
                    ),
                  
                  Container(height: 50,),
                  
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                      children: <Widget>[
                        Icon(Icons.motorcycle_rounded, size: 25,),
                        Text('...', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, fontSize: 18)),])),
                  
                  Container(height: 50,),

                  GestureDetector(
                    onTapDown: (_) {
                      setState(() => hazard = true);
                      kirimData(codeBeep);
                    },
                    onTapUp: (_) => setState(() => hazard = false),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      height: 70, 
                      decoration: BoxDecoration(
                        color:hazard ? Colors.brown : Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [BoxShadow(
                          color: Colors.black,
                          blurRadius: 5,
                          offset: Offset(2, 2),
                        )]
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                          children: <Widget>[
                            Icon(Icons.warning_outlined, color: hazard ? Colors.white : Colors.black,),
                            Text('BeepBeep', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, color: hazard ? Colors.white : Colors.black),)],),),)),
                  
                  Container(height: 50, ),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    GestureDetector(
                    onTapDown: (_) { 
                      setState(() => stater = true);
                      kirimData(codeStaterOn);
                    },
                    onTapUp: (_) {
                      setState(() => stater = false);
                      kirimData(codeStaterOff);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: 140,
                      width: 140, 
                      decoration: BoxDecoration(
                        color: stater? Colors.brown : Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [BoxShadow(
                          color: Colors.black,
                          blurRadius: 5,
                          offset: Offset(2, 2),
                        )]
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                          children: <Widget>[
                            Icon(Icons.electric_bolt_outlined, color: stater? Colors.white : Colors.black),
                            Text('Stater', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, color: stater? Colors.white : Colors.black))],),),),),

                    GestureDetector(
                    onTap: () {
                      setState(() => suhu = !suhu);
                      kirimData(suhu? codeSuhuOn : codeSuhuOff);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: 140,
                      width: 140, 
                      decoration: BoxDecoration(
                        color: suhu? Colors.brown : Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [BoxShadow(
                          color: Colors.black,
                          blurRadius: 5,
                          offset: Offset(2, 2),
                        )]
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                          children: <Widget>[
                            Icon(Icons.thermostat_outlined, color: suhu? Colors.white : Colors.black,),
                            Text(suhu? "$data °C" : "Suhu °C", style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, color: suhu? Colors.white : Colors.black),)],),),))],),
                      ])
                )));}
}