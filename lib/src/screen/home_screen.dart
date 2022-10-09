import 'package:flutter/material.dart';

import 'settings_screen.dart';
import 'widget/footer_bar.dart';
import 'widget/header_bar.dart';
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
            HeaderBar(
              onButtonPressed: () => _scaffoldKey.currentState?.openDrawer(),
              date: DateTime.now(),
              dateRange: 'Daily Activity',
            ),
            Spacer(),
            StepsIndicator(
              currentSteps: 7500,
              stepsGoal: 10000,
            ),
            Spacer(),
            FooterBar(
              distance: 5.6,
              calories: 1589,
              avgSteps: 8762,
            ),
          ],
        ),
      ),
    );
  }
}
