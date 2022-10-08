import 'package:flutter/material.dart';

import 'settings_screen.dart';
import 'widget/steps_indicator.dart';
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
                          'Daily Activity - Today',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            StepsIndicator(currentSteps: 7500, stepsGoal: 10000),
            Spacer(),
            Container(
              margin: EdgeInsets.only(bottom: 100.0),
              height: 100.0,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 3.0, // soften the shadow
                    spreadRadius: 1.5, //extend the shadow
                    offset: Offset(
                      3.0, // Move to right 5  horizontally
                      3.0, // Move to bottom 5 Vertically
                    ),
                  ),
                  BoxShadow(
                    color: Colors.white12,
                    blurRadius: 3.0, // soften the shadow
                    spreadRadius: 0.5, //extend the shadow
                    offset: Offset(
                      -3.0, // Move to right 5  horizontally
                      -3.0, // Move to bottom 5 Vertically
                    ),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [Text('Distance'), Text('5.6 km')],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [Text('Calories'), Text('1589 kcal')],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [Text('Average'), Text('8762 Steps')],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
