import 'package:flutter/material.dart';
import 'package:nefos/add_credits.dart';
import 'package:nefos/card_activation.dart';

class CardMenu extends StatefulWidget {
  const CardMenu({super.key});

  @override
  State<CardMenu> createState() => _CardMenuState();
}

class _CardMenuState extends State<CardMenu> {
  void _presentCreditsAddition() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => const AddCredits(),
    );
  }

  void _presentCardActivation() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => const CardActivation(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello 20BCE7349'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _presentCreditsAddition,
                child: Card(
                  elevation: 15,
                  child: Column(children: [
                    Image.asset(
                      'assets/images/deposit.jpg',
                      width: 175,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text('Add Credits'),
                  ]),
                ),
              ),
              Card(
                elevation: 15,
                child: Column(children: [
                  Image.asset(
                    'assets/images/transact.jpg',
                    width: 175,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text('Recent Transactions'),
                ]),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: GestureDetector(
                  onTap: _presentCardActivation,
                  child: Card(
                    elevation: 15,
                    child: Column(children: [
                      Image.asset(
                        'assets/images/block.jpg',
                        width: 175,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text('Card Activation'),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
