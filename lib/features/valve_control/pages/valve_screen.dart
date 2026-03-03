import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_valve_mqtt_controller/features/valve_control/domain/entities/valve_entity.dart';
import 'package:virtual_valve_mqtt_controller/features/valve_control/presentation/bloc/valve_bloc.dart';
import 'package:virtual_valve_mqtt_controller/features/valve_control/presentation/bloc/valve_event.dart';
import 'package:virtual_valve_mqtt_controller/features/valve_control/presentation/bloc/valve_state.dart';
import 'package:virtual_valve_mqtt_controller/features/valve_control/widgets/heavy_duty_toggle.dart';
import 'package:virtual_valve_mqtt_controller/features/valve_control/widgets/status_led.dart';
import 'package:google_fonts/google_fonts.dart';

class ValveScreen extends StatelessWidget {
  const ValveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD1D1C8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD1D1C8),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: BlocBuilder<ValveBloc, ValveState>(
            builder: (context, state) {
              if (state is ValveLoaded && !state.isPending) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green.withValues(alpha: 0.6),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "SISTEMA ONLINE",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 10),
                  ),
                );
              } else if (state is ValveError) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.red.withValues(alpha: 0.6),
                  ),
                  child: Text(
                    "SISTEMA OFFLINE - RECONECTANDO",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 10),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
      body: BlocBuilder<ValveBloc, ValveState>(
        builder: (context, state) {
          if (state is ValveInitial) {
            return Center(
              child: ElevatedButton(
                onPressed: () =>
                    context.read<ValveBloc>().add(ConnectToValve()),
                child: Text(
                  'INICIALIZAR SISTEMA',
                  style: GoogleFonts.inter(color: Colors.white),
                ),
              ),
            );
          }

          if (state is ValveLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          if (state is ValveLoaded) {
            return _buildDashboard(context, state);
          }

          if (state is ValveError) {
            return Center(
              child: Text(
                'ERRO CRÍTICO NO SISTEMA: ${state.message}',
                style: GoogleFonts.inter(color: Colors.red),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, ValveLoaded state) {
    final isOpen = state.valve.status == ValveStatus.open;

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color(0xFFD1D1C8),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color.fromARGB(255, 196, 196, 195),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(137, 45, 45, 45),
              offset: Offset(0, 20),
              blurRadius: 32,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "IND-VALVE LAUNCH CTRL",
              style: GoogleFonts.inter(
                color: const Color(0xFF2A2A2A),
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const Divider(
              color: Color.fromARGB(137, 142, 142, 142),
              thickness: 2,
              height: 30,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StatusLed(
                      label: "ENERGIA",
                      isActive: true,
                      activeColor: Colors.green,
                    ),
                    StatusLed(
                      label: "PENDENTE",
                      isActive: state.isPending,
                      activeColor: Colors.orange,
                    ),
                    StatusLed(
                      label: "ATIVO",
                      isActive: isOpen && !state.isPending,
                      activeColor: Colors.redAccent,
                    ),
                  ],
                ),

                HeavyDutyToggle(
                  value: isOpen,
                  isPending: state.isPending,
                  onChanged: (value) {
                    context.read<ValveBloc>().add(ToggleValveCommand(value));
                  },
                ),
              ],
            ),

            if (state.isPending)
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: LinearProgressIndicator(
                  color: Colors.orange,
                  backgroundColor: Colors.black26,
                  minHeight: 10,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
