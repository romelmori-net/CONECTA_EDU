import 'package:flutter/material.dart';

class OnboardingProgressIndicator extends StatelessWidget {
  final int step;
  final int totalSteps;

  const OnboardingProgressIndicator({
    super.key,
    required this.step,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps, (index) {
          bool isActive = index < step;
          bool isCurrent = index == step - 1;
          return Flexible(
            child: Container(
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? (isCurrent ? const Color(0xFF0D6EFD) : const Color(0xFF0D47A1)) // Current step is brighter
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        }),
      ),
    );
  }
}
