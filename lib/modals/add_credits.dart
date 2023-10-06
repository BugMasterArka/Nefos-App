import 'package:flutter/material.dart';

class AddCredits extends StatefulWidget {
  const AddCredits({super.key});

  @override
  State<AddCredits> createState() {
    return _AddCreditsState();
  }
}

class _AddCreditsState extends State<AddCredits> {
  final _amountController = TextEditingController();
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

// * in the below function the fetchedPin will be fetched from backend by HTTPS request
// * in the below function the credits will be added to the backend by HTTPS request

  void _onSubmitAddition() {
    var enteredAmount = double.tryParse(_amountController.text);
    var enteredPin = int.tryParse(_pinController.text);
    int? fetchedPin = 1234;

    if (enteredAmount == null || enteredPin == null) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Invalid Input'),
            content: Row(children: [
              Image.asset(
                'assets/images/error2.png',
                width: 100,
              ),
              const Expanded(
                child: Text('Make Sure to fill all the mandatory fields'),
              ),
            ]),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (enteredPin != fetchedPin) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Incorrect Pin'),
            content: Row(
              children: [
                Image.asset(
                  'assets/images/wrong2.png',
                  width: 100,
                ),
                const Expanded(
                  child: Text(
                    'Incorrectly Entered Pin',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay!'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (enteredPin == fetchedPin) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Success'),
            content: Row(
              children: [
                Image.asset(
                  'assets/images/correct2.png',
                  width: 50,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Expanded(
                  child: Text('Successfully added Credits'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            controller: _amountController,
            decoration: const InputDecoration(
              label: Text('Credits'),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            keyboardType: TextInputType.number,
            obscureText: true,
            controller: _pinController,
            decoration: const InputDecoration(
              label: Text('Pin'),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
                onPressed: _onSubmitAddition,
                child: const Text('Add'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
