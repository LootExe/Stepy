import 'package:flutter/material.dart';

import 'widget/date_bar.dart';
import 'widget/footer_bar.dart';
import 'widget/header_bar.dart';
import 'widget/menu_drawer.dart';
import 'widget/steps_indicator.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuDrawer(),
      body: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 64.0,
          horizontal: 16.0,
        ),
        child: Column(
          children: [
            HeaderBar(
              onButtonPressed: () => _scaffoldKey.currentState?.openDrawer(),
              date: DateTime.now(),
              dateRange: 'Daily Activity',
            ),
            Spacer(flex: 2),
            DateBar(),
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
