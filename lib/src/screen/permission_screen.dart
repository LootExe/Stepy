import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bloc/background_bloc.dart';
import '../bloc/pedometer_bloc.dart';

import 'home_screen.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  final String _permission =
      'The app uses the hardware step sensor in order to count steps.\n'
      'To access the sensor, physical activity permission '
      'needs to be granted.';

  final String _background =
      'The app sets up a background service for the sensor to stay alive '
      'and schedules a background alarm roughly every 15 minutes in order '
      'to wake up and access steps taken and to save data.';

  final String _battery =
      'On some phones, battery optimization needs to be disabled for the '
      'background service to work properly';

  bool _canStart = false;

  Future<void> _requestPermissions() async {
    if (await PedometerBloc.requestPermission()) {
      setState(() => _canStart = true);
    }
  }

  void _moveToHome(BuildContext context) {
    BlocProvider.of<BackgroundBloc>(context).add(BackgroundServiceStarted());

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  Widget _buildHeader(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }

  Widget _buildTextBlock(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14.0, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 36.0),
        child: Column(
          children: [
            Text(
              'Stepy - Step count app',
              style: Theme.of(context).textTheme.headline5,
            ),
            const Spacer(),
            _buildHeader('Permissions:'),
            _buildTextBlock(_permission),
            ElevatedButton(
              onPressed: () => _requestPermissions(),
              child: const Text('Request Permission'),
            ),
            const Spacer(),
            _buildHeader('Background Service:'),
            _buildTextBlock(_background),
            const Spacer(),
            _buildHeader('Battery Optimization:'),
            _buildTextBlock(_battery),
            ElevatedButton(
              onPressed: () => openAppSettings(),
              child: const Text('Open App settings'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _canStart ? () => _moveToHome(context) : null,
              child: const Text('Start counting'),
            ),
          ],
        ),
      ),
    );
  }
}
