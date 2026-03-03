import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HeavyDutyToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isPending;

  const HeavyDutyToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.isPending = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = isPending || onChanged == null;

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              HapticFeedback.heavyImpact();
              onChanged!(!value);
            },
      child: Opacity(
        opacity: isDisabled ? 0.6 : 1.0,
        child: Container(
          width: 120,
          height: 200,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF4A4A4A),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(0, 10),
                blurRadius: 15,
              ),
              BoxShadow(
                color: Colors.white12,
                offset: Offset(0, -2),
                blurRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "OPEN",
                style: GoogleFonts.inter(
                  color: value ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 50,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black87, width: 2),
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOutBack,
                      alignment: value
                          ? Alignment.topCenter
                          : Alignment.bottomCenter,
                      child: Container(
                        width: 46,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE0E0E0), Color(0xFF909090)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black54, width: 1),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black87,
                              offset: Offset(0, 5),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (index) => Container(
                              height: 3,
                              width: 30,
                              color: Colors.black45,
                              margin: const EdgeInsets.symmetric(vertical: 3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                "CLOSE",
                style: GoogleFonts.inter(
                  color: !value ? Colors.red : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
