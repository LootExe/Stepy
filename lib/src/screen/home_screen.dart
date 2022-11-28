import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pedometer_bloc.dart';
import '../bloc/settings_bloc.dart';

import 'widget/home_menu.dart';
import 'widget/step_progress_bar.dart';
import 'widget/timeline.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late PedometerBloc _pedometerBloc;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _pedometerBloc.add(PedometerStarted());
        break;
      case AppLifecycleState.paused:
        _pedometerBloc.add(PedometerStopped());
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pedometerBloc = BlocProvider.of<PedometerBloc>(context);
    _pedometerBloc.add(PedometerStarted());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
        child: BlocBuilder<PedometerBloc, PedometerState>(
          builder: (context, state) => Stack(
            children: [
              Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: HomeMenu(),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20.0),
                    child: StepProgressBar(
                      currentSteps: state.stepsDaily,
                      stepsGoal: BlocProvider.of<SettingsBloc>(context)
                          .settings
                          .dailyStepGoal,
                      stepsRecord: state.stepsRecord,
                      averageSteps: state.stepsAverage,
                      progressColor: Theme.of(context).colorScheme.secondary,
                      backgroundColor: Colors.grey,
                      stepFontSize: 64.0,
                      strokeWidth: 1.5,
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                top: 330.0,
                child: Timeline(stepHistory: state.stepsHistory),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
