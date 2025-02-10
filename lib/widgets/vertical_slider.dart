import 'package:flutter/material.dart';

class VerticalSlider extends StatefulWidget {
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const VerticalSlider({
    Key? key,
    required this.min,
    required this.max,
    required this.onChanged,
  }) : super(key: key);

  @override
  _VerticalSliderState createState() => _VerticalSliderState();
}

class _VerticalSliderState extends State<VerticalSlider> {
  double _currentValue = 1.0;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Slider(
        min: widget.min,
        max: widget.max,
        value: _currentValue,
        onChanged: (value) {
          setState(() {
            _currentValue = value;
          });
          widget.onChanged(value);
        },
      ),
    );
  }
}
