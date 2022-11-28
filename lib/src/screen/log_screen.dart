import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/log_data.dart';
import '../provider/hive_database.dart';
import '../repository/logger_repository.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  late LoggerRepository _logger;

  Future<void> _loadData() async {
    await _logger.initialize();
  }

  Future<void> _clearData() async {
    await _logger.clear();
    setState(() => {});
  }

  @override
  void initState() {
    super.initState();
    _logger = LoggerRepository(
      database: HiveDatabase(
        boxName: LogData.boxName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Data')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 8.0),
        child: FutureBuilder(
          future: _loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _logger.entries.length,
                itemBuilder: (BuildContext context, int index) {
                  final data = _logger.entries[index];
                  final timestamp = DateFormat('yyyy-MM-dd – HH:mm:ss')
                      .format(data.timestamp);

                  return Text('${data.message} / Time: $timestamp');
                },
              );
            } else {
              return Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: _clearData,
        child: const Icon(
          Icons.delete,
        ),
      ),
    );
  }
}
