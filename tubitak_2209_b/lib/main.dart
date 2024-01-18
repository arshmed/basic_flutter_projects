import 'package:flutter/material.dart';
import 'package:tubitak_2209_b/Dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Sulama Otomasyonu'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff708D81),
        title: Text(widget.title),
      ),
      body: Container(
        //margin: EdgeInsets.only(top: 50),
        alignment: Alignment.center,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Merhaba Muhammed 👋",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff001427),
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "27.4°C",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            CircleAvatar(
              radius: 120.0,
              backgroundImage: AssetImage("images/image.jpg"),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Konya, Türkiye",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xff001427),
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(
              height: 80,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: TextStyle(fontSize: 24),
                backgroundColor: Color(0xff708D81),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dashboard()));
              },
              child: Text(
                "Verileri Getir",
                style: TextStyle(color: Color(0xff001427)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
