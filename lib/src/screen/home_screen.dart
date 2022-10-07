import 'package:flutter/material.dart';
import 'package:curved_progress_bar/curved_progress_bar.dart';

import 'settings_screen.dart';
import 'widget/square_button.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // TODO: Make Drawer beautieful
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Settings'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 48.0, left: 16.0, right: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                SquareButton(
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  child: const Icon(Icons.menu, size: 36.0),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Friday, 7th October, 2022',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Daily Activity',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: Colors.red,
                width: double.infinity,
                margin: const EdgeInsets.all(50.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '10,250',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48.0,
                            ),
                          ),
                          Text('Steps'),
                        ],
                      ),
                    ),
                    Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 30.0),
                        child: Text('Goal: 10,000'),
                      ),
                    ),
                    CurvedCircularProgressIndicator(
                      value: 0.5,
                      strokeWidth: 16,
                      animationDuration: const Duration(seconds: 1),
                      backgroundColor: Color(0xFF393939),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            /* Expanded(
              child: Container(
                color: Colors.red,
                margin: const EdgeInsets.symmetric(
                    vertical: 30.0, horizontal: 50.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '10250',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48.0,
                            ),
                          ),
                          Text('Steps'),
                          Spacer(
                            flex: 1,
                          ),
                          Text('Goal: 10,000'),
                        ],
                      ),
                    ),
                    FittedBox(
                      child: CurvedCircularProgressIndicator(
                        value: 0.5,
                        strokeWidth: 3,
                        animationDuration: const Duration(seconds: 1),
                        backgroundColor: Color(0xFF393939),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ), */
          ],
        ),
      ),
    );
  }
}
