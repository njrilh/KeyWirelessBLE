// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures, avoid_types_as_parameter_names, non_constant_identifier_names
// ignore: use_key_in_widget_constructors
import 'package:bluekey/home.dart';
import 'package:bluekey/scan.dart';
import 'package:bluekey/voice.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _Screen();
}

class _Screen extends State<Screen> with TickerProviderStateMixin{

late TabController controller;
late BluetoothDevice? connectedDevice;
late BluetoothCharacteristic? writeCharacteristic;
final List<Widget> pages = [];
bool connectDevice = false;
bool theme = false;

final ThemeData isDarkMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromARGB(255, 33, 33, 33),
  appBarTheme: AppBarTheme(backgroundColor: Colors.brown,),
  bottomAppBarTheme: BottomAppBarTheme(color: Colors.brown),
);

final ThemeData isLightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(backgroundColor: Colors.white),
  bottomAppBarTheme: BottomAppBarTheme(color: Colors.brown)
);

@override
void initState() {
  super.initState();
  controller = TabController(vsync: this, length: 2);
  pages.add(Scan(onDeviceConnected: (device, characteristic) {
    setState(() {
      connectedDevice = device;
      writeCharacteristic = characteristic;
      connectDevice = true;
      });}));
  pages.add(Home(getCharacteristic: () => writeCharacteristic));
}

@override
Widget build(BuildContext context) {  
  return SafeArea(child: 
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: theme ? isDarkMode : isLightMode,
    home: Scaffold(
    appBar: AppBar(
      title: Text('JillProject', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold)),
      toolbarHeight: 95,
      actions: [
        IconButton(onPressed: () {Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (context, _, __) => voice()),);}, icon: Icon(Icons.mic_rounded)),
        Padding(padding: EdgeInsets.only(right: 0)),
        IconButton(onPressed: () => setState(() => theme = !theme), icon: theme ? Icon(Icons.light_mode_outlined) : Icon(Icons.dark_mode_outlined)),
        Padding(padding: EdgeInsets.only(right: 30)),],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Column(children: <Widget>[ 
          connectDevice == true 
          ? AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: 25, 
              width: double.infinity, 
              decoration: BoxDecoration(
                color: Colors.amber,
                boxShadow: [BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                  offset: Offset(2, 2))],), 
              child: Center(
                child: Text('Terhubung ke ${connectedDevice!.name}', style: GoogleFonts.fredoka(color: Colors.white, fontWeight: FontWeight.bold))))
          : AnimatedContainer(
            duration: Duration(milliseconds: 300),
              height: 25, 
              width: double.infinity, 
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 128, 128, 128), 
                boxShadow: [BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                  offset: Offset(4, 4))],),
              child: Center(
                child: Text('Hubungkan ke ESP terlebih dahulu', style:  GoogleFonts.fredoka(color: Colors.white, fontWeight: FontWeight.bold)))),

          Container(
          height: 1,
          decoration: BoxDecoration(
            color: const Color.fromARGB(51, 158, 158, 158),
            boxShadow: [BoxShadow(
              color: Colors.black,
              blurRadius: 10,
              offset: Offset(4, 4)),
              ]
            ),
          ),
        ]
      )
    ),
  ),

      body: TabBarView(
        controller: controller,
        children: [ 
          pages[1],
          pages[0],
        ]),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          child:  BottomAppBar(
            height: 70,
            child: TabBar(
              dividerHeight: 0,
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              automaticIndicatorColorAdjustment: false,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: const Color.fromARGB(255, 128, 128, 128),
              controller: controller,
              tabs: <Widget> [
                Tab(icon: Icon(Icons.home, size: 30,)),
                Tab(icon: Icon(Icons.bluetooth_outlined, size: 30,)),
              ],
            ),
          )
        )
      )
    )));
  }
}