import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/background_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../custom_icons.dart';
import 'log_screen.dart';
import 'widget/settings_tile.dart';
import 'widget/step_goal_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _stepGoalSettings(context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) => SettingsTile(
        icon: CustomIcons.trophy,
        title: 'Daily Step Goal',
        subtitle: state.settings.dailyStepGoal.toString(),
        onTap: () async {
          final bloc = BlocProvider.of<SettingsBloc>(context);
          final newGoal = await StepGoalDialog.show(
            context: context,
            initialValue: state.settings.dailyStepGoal,
          );

          if (newGoal == state.settings.dailyStepGoal) {
            return;
          }

          state.settings.dailyStepGoal = newGoal;
          bloc.add(SettingsChanged());
        },
      ),
    );
  }

  Widget _serviceSettings(context) {
    return BlocBuilder<BackgroundBloc, BackgroundState>(
      builder: (context, state) => SettingsTile(
        icon: CustomIcons.clock,
        title: 'Background Service',
        subtitle: state.isRunning ? 'Is Active' : 'Is Inactive',
        onTap: () {
          if (state.isRunning) {
            BlocProvider.of<BackgroundBloc>(context)
                .add(BackgroundServiceStopped());
          } else {
            BlocProvider.of<BackgroundBloc>(context)
                .add(BackgroundServiceStarted());
          }
        },
      ),
    );
  }

  Widget _logScreenSettings(context) {
    return SettingsTile(
      icon: CustomIcons.database,
      title: 'Log Data',
      subtitle: 'Open debug log data',
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LogScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Container(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 4.0),
        child: Column(
          children: [
            _stepGoalSettings(context),
            const Divider(),
            _serviceSettings(context),
            const Divider(),
            _logScreenSettings(context),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
