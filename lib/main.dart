import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Mario Bross'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        tiempo--;
        if (tiempo == 0) {
          checkGameOver();
          timer.cancel();
        }
      });
    });
    super.initState();
  }

  static double mariox = 0.0;
  static double marioy = 1.0;
  static double matiasx = 0.5;
  static double matiasy = 1.0;
  static int marioLife = 5;
  static int puntos = 0;
  static int tiempo = 120;
  static int saltos = 0;
  double time = 0;
  double height = 0;
  double initialPos = marioy;
  String direction = "right";
  static String gameOver = "";
  static bool holdingButton = false;

  var gameFont = GoogleFonts.pressStart2p(
      textStyle: TextStyle(color: Colors.white, height: 2, fontSize: 20));

  void preJump() {
    time = 0;
    initialPos = marioy;
  }

  void checkCrossMario() {
    if ((mariox - matiasx).abs() < 0.005 && (marioy - matiasy).abs() < 0.005) {
      setState(() {
        marioLife -= 1;
        checkGameOver();
      });
    }
  }

  void checkGameOver() {
    if (marioLife == 0 || tiempo == 0) {
      setState(() {
        gameOver = "Game Over";
      });
    }
  }

  void jumpMario() {
    preJump();
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 5 * time;

      if (initialPos - height > 1) {
        setState(() {
          marioy = 1;
          timer.cancel();
        });
      } else {
        setState(() {
          marioy = initialPos - height;
        });
      }
    });
  }

  void jumpMatias() {
    preJump();
    saltos++;
    if (saltos > 0) {
      setState(() {
        puntos = saltos ~/ 2;
      });
    }
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 5 * time;

      if (initialPos - height > 1) {
        setState(() {
          matiasy = 1;
          timer.cancel();
        });
      } else {
        setState(() {
          matiasy = initialPos - height;
        });
      }
    });
  }

  void walkLMario() {
    direction = "left";
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      checkCrossMario();
      if (holdingButton == true) {
        setState(() {
          mariox -= 0.02;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void walkLMatias() {
    direction = "left";
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      checkCrossMario();
      if (holdingButton == true) {
        setState(() {
          matiasx -= 0.02;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void walkRMario() {
    direction = "right";
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      checkCrossMario();
      if (holdingButton == true) {
        setState(() {
          mariox += 0.02;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void walkRMatias() {
    direction = "right";
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      checkCrossMario();
      if (holdingButton == true) {
        setState(() {
          matiasx += 0.02;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: Text(widget.title),
      ),
      */
      body: Column(children: [
        Expanded(
            flex: 8,
            child: Stack(children: [
              Container(
                color: Colors.blue,
                child: AnimatedContainer(
                    alignment: Alignment(mariox, marioy),
                    duration: Duration(milliseconds: 0),
                    child: Mario(
                      direction: direction,
                    )),
              ),
              Container(
                alignment: Alignment(matiasx, matiasy),
                child: Matias(),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Column(children: [
                  Text(
                    "Vidas",
                    style: gameFont,
                  ),
                  Text(
                    marioLife.toString(),
                    style: gameFont,
                  )
                ]),
                Column(children: [
                  Text(
                    "Puntos",
                    style: gameFont,
                  ),
                  Text(
                    puntos.toString(),
                    style: gameFont,
                  ),
                  Text(
                    gameOver,
                    style: TextStyle(color: Colors.red, fontSize: 30),
                  ),
                ]),
                Column(children: [
                  Text(
                    "Tiempo",
                    style: gameFont,
                  ),
                  Text(
                    tiempo.toString(),
                    style: gameFont,
                  )
                ]),
              ]),
            ])),
        Container(height: 10, color: Colors.green),
        Expanded(
            flex: 2,
            child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTapDown: (details) {
                                holdingButton = true;
                                walkLMario();
                              },
                              onTapUp: (details) {
                                holdingButton = false;
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.brown[300],
                                child: Icon(Icons.arrow_back),
                              )),
                          GestureDetector(
                              onTap: jumpMario,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.brown[300],
                                child: Icon(Icons.arrow_upward),
                              )),
                          GestureDetector(
                              onTapDown: (details) {
                                holdingButton = true;
                                walkRMario();
                              },
                              onTapUp: (details) {
                                holdingButton = false;
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  color: Colors.brown[300],
                                  child: Icon(Icons.arrow_forward))),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                              onTapDown: (details) {
                                holdingButton = true;
                                walkLMatias();
                              },
                              onTapUp: (details) {
                                holdingButton = false;
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.brown[300],
                                child: Icon(Icons.arrow_back),
                              )),
                          GestureDetector(
                              onTap: jumpMatias,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.brown[300],
                                child: Icon(Icons.arrow_upward),
                              )),
                          GestureDetector(
                              onTapDown: (details) {
                                holdingButton = true;
                                walkRMatias();
                              },
                              onTapUp: (details) {
                                holdingButton = false;
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  color: Colors.brown[300],
                                  child: Icon(Icons.arrow_forward))),
                        ])
                  ],
                )))
      ]),
    );
  }
}

class Mario extends StatelessWidget {
  final direction;

  Mario({this.direction});

  @override
  Widget build(BuildContext context) {
    if (direction == "right") {
      return Container(
          width: 50,
          height: 50,
          child: Image.network(
              "https://cdn.pixabay.com/photo/2021/02/11/15/40/mario-6005703_960_720.png"));
    } else {
      return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: Container(
              width: 50,
              height: 50,
              child: Image.network(
                  "https://cdn.pixabay.com/photo/2021/02/11/15/40/mario-6005703_960_720.png")));
    }
  }
}

class Matias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        height: 50,
        child: Image.network("https://i.imgur.com/NttYeG7.png"));
  }
}
