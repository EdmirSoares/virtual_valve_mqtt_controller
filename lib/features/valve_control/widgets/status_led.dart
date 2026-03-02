import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusLed extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color activeColor;

  const StatusLed({
    super.key,
    required this.label,
    required this.isActive,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? activeColor : const Color(0xFF333333),
              boxShadow: [
                if (isActive)
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.6),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                const BoxShadow(
                  color: Colors.white12,
                  offset: Offset(0, 1),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? Colors.white.withValues(alpha: 0.4)
                      : Colors.transparent,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
