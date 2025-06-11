import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final List<bool>? switches;
  final List<String>? buttons;

  const SettingsSection({
    super.key,
    required this.title,
    required this.items,
    this.switches,
    this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1E2B3A),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: List.generate(items.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(items[index], style: const TextStyle(fontSize: 14)),
                  if (switches != null && index < switches!.length)
                    Switch(
                      value: switches![index],
                      onChanged: (_) {},
                      activeColor: Colors.cyan,
                    ),
                  if (buttons != null && index < buttons!.length)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        buttons![index],
                        style: const TextStyle(fontSize: 13),
                      ),
                    )
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
