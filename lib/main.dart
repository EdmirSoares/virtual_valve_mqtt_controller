import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:virtual_valve_mqtt_controller/features/valve_control/pages/valve_screen.dart';
import 'package:virtual_valve_mqtt_controller/features/valve_control/presentation/bloc/valve_bloc.dart';
import 'core/config/env_config.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final envConfig = EnvConfig.fromDotEnv();

  await di.init(envConfig);

  runApp(const PetrobrasValveApp());
}

class PetrobrasValveApp extends StatelessWidget {
  const PetrobrasValveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Valve Control IoT',
      theme: ThemeData.dark(),
      home: BlocProvider<ValveBloc>(
        create: (_) => di.sl<ValveBloc>(),
        child: const ValveScreen(),
      ),
    );
  }
}
