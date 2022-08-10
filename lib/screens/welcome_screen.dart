import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  // NEED TO DECLARE CONTROLLER AS A GLOBAL VARIABLE FOR ANIMATING SOMETHIG

  @override
  // INITIALIZING THE CONTROLLER IN INITSTATE BCZ WE WANT TO INITIALIZE IT ONLY ONCE
  void initState() {
    controller = AnimationController(
      duration: Duration(seconds: 1),
      upperBound: 100, // BY DEFAULT IT IS 1.0 , WE CAN CHANGE IT TO ANY VALUE
      vsync:
          this, // THIS REFERS TO THE STATE CLASS ITSELF || NEED TO ACCESS THIS BEFORE INITIALIZING THE SINGLE TICKER PROVIDER STATE MIXIN
    );
    controller.forward(); // THIS WILL ANIMATE THE CONTROLLER FORWARD
    controller.addListener(() {
      // THIS WILL LISTEN TO THE CONTROLLER AND WILL UPDATE THE STATE OF THE WIDGET
      setState(() {});
      // print(controller.value); // THIS WILL PRINT THE VALUE OF THE CONTROLLER
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                Text(
                  'Flash Chat',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                    //Go to login screen.
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Log In',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/registration');
                    //Go to registration screen.
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              // THIS WON'T WORK FOR THE FIRST TIME | NEED TO CALL SETSTATE TO UPDATE THE UI
              child: Text(
                '${controller.value.toInt()}%',
                style: TextStyle(fontSize: 30),
              ), // NEED TO SET IT TO A STRING | TEXT ONLY TAKES STRING
            )
          ],
        ),
      ),
    );
  }
}
