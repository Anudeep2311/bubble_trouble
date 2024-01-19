import 'dart:async';

import 'package:bubble_trouble/ball.dart';
import 'package:bubble_trouble/button.dart';
import 'package:bubble_trouble/player.dart';
import 'package:bubble_trouble/shooter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum direction { LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  // PLAYER VARIABLES
  static double playerX = 0;
  double playerY = 1;

  // SHOOT VARIABLES
  double shootX = playerX;
  double shootingHeight = 10;
  bool midShot = false;

  // BALL VARIABLES
  double ballX = 0.5;
  double ballY = 0;
  var ballDirection = direction.LEFT;

  void moveLeft() {
    setState(() {
      if (playerX - 0.1 < -1) {
      } else {
        playerX -= 0.1;
      }
      if (!midShot) {
        shootX = playerX;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (playerX + 0.1 > 1) {
      } else {
        playerX += 0.1;
      }
      if (!midShot) {
        shootX = playerX;
      }
    });
  }

  void resetShoot() {
    shootX = playerX;
    shootingHeight = 10;
    midShot = false;
  }

// CONVERT HEIGHT TO CO-ORDINATE
  double heightToCoordinate(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  void shoot() {
    if (midShot == false) {
      Timer.periodic(const Duration(milliseconds: 20), (timer) {
        midShot = true;

        setState(() {
          shootingHeight += 10;
        });

        if (shootingHeight > MediaQuery.of(context).size.height * 3 / 4) {
          resetShoot();
          timer.cancel();
        }
        if (ballY > heightToCoordinate(shootingHeight) &&
            (ballX - shootX).abs() < 0.03) {
          resetShoot();
          ballX = 5;
          timer.cancel();
        }
      });
    }
  }

  void startGame() {
    double time = 0;
    double height = 0;
    double velocity = 60;
    Timer.periodic(const Duration(milliseconds: 15), (timer) {
      height = -5 * time * time + velocity * time;

      if (height < 0) {
        time = 0;
      }

      setState(() {
        ballY = heightToCoordinate(height);
      });
      if (ballX - 0.005 < -1) {
        ballDirection = direction.RIGHT;
      } else if (ballX + 0.05 > 1) {
        ballDirection = direction.LEFT;
      }

      if (ballDirection == direction.LEFT) {
        setState(() {
          ballX -= 0.005;
        });
      } else if (ballDirection == direction.RIGHT) {
        setState(() {
          ballX += 0.005;
        });
      }
      if (playerDied()) {
        timer.cancel();
        _showDialouge();
      }
      time += 0.1;
    });
  }

  void _showDialouge() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            backgroundColor: Colors.black,
            title: Text("You dead bro"),
            titleTextStyle: TextStyle(color: Colors.white),
          );
        });
  }

  bool playerDied() {
    if ((ballX - playerX).abs() < 0.05 && ballY > 0.95) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
        if (event.isKeyPressed(LogicalKeyboardKey.space)) {
          shoot();
        }
      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.pink[100],
              child: Center(
                child: Stack(
                  children: [
                    MyBall(ballX: ballX, ballY: ballY),
                    Shooter(
                      height: shootingHeight,
                      shootX: shootX,
                    ),
                    MyPlayer(
                      playerX: playerX,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    icon: Icons.play_circle_sharp,
                    function: startGame,
                  ),
                  MyButton(
                    icon: Icons.arrow_left,
                    function: moveLeft,
                  ),
                  MyButton(
                    icon: Icons.arrow_drop_up,
                    function: shoot,
                  ),
                  MyButton(
                    icon: Icons.arrow_right,
                    function: moveRight,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
