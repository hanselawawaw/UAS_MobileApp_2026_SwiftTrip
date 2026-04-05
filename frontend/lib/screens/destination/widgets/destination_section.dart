import 'package:flutter/material.dart';
import '../models/destination_model.dart';
import 'destination_card.dart';

class DestinationSection extends StatelessWidget {
  final String title;
  final List<DestinationModel> items;
  final Widget? suffix;

  const DestinationSection({
    super.key,
    required this.title,
    required this.items,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (suffix != null) suffix!,
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 135,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: DestinationCard(destination: items[index]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
