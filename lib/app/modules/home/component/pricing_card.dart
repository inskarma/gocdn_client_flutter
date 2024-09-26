import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/hover_button.dart';

class PricingCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String additional;

  const PricingCard({
    required this.title,
    required this.price,
    required this.description,
    required this.additional,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(child: const Divider(thickness: 2)),
          const SizedBox(height: 16),
          Text(
            price,
            style: const TextStyle(
                fontSize: 34, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Center(
            child: HoverEffectButton(
              onPressed: () {},
              expanded: 1.1,
              milsec: 150,
              shrink: 0.8,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => print("hello"),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('get_cdn_button'.tr,
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            additional,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
          ),
          const Divider(thickness: 2),
        ],
      ),
    );
  }
}
