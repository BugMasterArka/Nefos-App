import 'package:flutter/material.dart';

class CardActivation extends StatefulWidget {
  const CardActivation({super.key});

  @override
  State<CardActivation> createState() {
    return _CardActivationState();
  }
}
// * default value of actiavtion status should be fetched from backend

class _CardActivationState extends State<CardActivation> {
  bool _activationStatus = true;
  String _buttonText = 'Deactivate';

// * in the below function activation status should be updated in the backend
  void _activationPress() {
    setState(() {
      _activationStatus = _activationStatus ? false : true;
      _buttonText = _activationStatus ? 'Deactivate' : 'Activate';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Current Status',
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                _activationStatus.toString(),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _activationPress,
            child: Text(
              _buttonText,
            ),
          ),
        ],
      ),
    );
  }
}
