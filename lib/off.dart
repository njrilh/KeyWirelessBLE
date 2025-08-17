import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Off extends StatefulWidget {
  const Off({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _Off createState() => _Off();
}

class _Off extends State<Off> {

void turnOn() async{
  await FlutterBluePlus.turnOn();
  Fluttertoast.showToast(
    msg: 'Menyalakan Bluetooth',
    backgroundColor: const Color.fromARGB(255, 88, 88, 88),
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}

@override
Widget build(BuildContext context) {  
    return Scaffold(
      appBar: AppBar(title: Text('Bluetooth Off', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),)),
      body: Center(
        child: Column(children: <Widget>[
          Container(height: 70,),
          Icon(Icons.bluetooth_disabled_outlined),
          Container(height: 30,),
          ElevatedButton(
            onPressed: turnOn,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
            ),
            child: Text('Nyalakan Bluetooth', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),),
          ),],)
        )
      );
    }
  }