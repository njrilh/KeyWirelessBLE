// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class voice extends StatefulWidget {
  const voice({super.key});

  @override
  State<voice> createState() => _voice();
}

class _voice extends State<voice> {

SpeechToText stt = SpeechToText();
bool mic = false;
bool dengar = false;
String kata = "Ketuk untuk berbicara";

@override
void initState() {
  super.initState();
  mikrofon();
}

void mikrofon() async {
  bool tersedia = await stt.initialize();
  setState(() {
    mic = tersedia;
  });
}

void mulai() async{
  final option = SpeechListenOptions(
    listenMode: ListenMode.dictation,
    cancelOnError: false,
    partialResults: true,
    autoPunctuation: true,
    sampleRate: 48000,
  );
  await Future.delayed(Duration(milliseconds: 500));
  await stt.listen(listenOptions: option, onResult: (SpeechRecognitionResult hasil)  {setState(() => kata = hasil.recognizedWords);});
}

void selesai() async{
  await stt.stop();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(235, 0, 0, 0),
      appBar: AppBar(
        toolbarHeight: 95,
        backgroundColor: Colors.transparent,
        leading: BackButton(color: Colors.white,),
      ),
      body:
        Center(child: 
          Column(children: <Widget>[
            Container(height: 200,),
            Text(kata, style: GoogleFonts.fredoka(color: Colors.white),),
            Container(height: 50,),
            GestureDetector(
              onTap: () {
                setState(() => dengar = !dengar);
                dengar ? mulai() : selesai();
              },
              child:
                AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(360),
                    color: dengar ? Colors.brown : Colors.grey,
                  ),
                  child: Center(child: Icon(Icons.mic, size: 40,),),
              )),
        ],)),
    );
  }
}