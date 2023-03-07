import 'package:flutter/material.dart';
import 'package:revee/models/statistics.dart';

// ignore: must_be_immutable
class ChartWithRange extends StatefulWidget {
  Widget Function(StatisticsTimeRange) child;

  ChartWithRange({
    required this.child,
  });

  @override
  _ChartWithRangeState createState() => _ChartWithRangeState();
}

class _ChartWithRangeState extends State<ChartWithRange> {
  StatisticsTimeRange _timeRange = StatisticsTimeRange.oneMonth;

  @override
  Widget build(BuildContext context) {
    Widget _buildRangeButton(String text, StatisticsTimeRange rangeToSet) {
      if (rangeToSet == _timeRange) {
        return ElevatedButton(
          onPressed: () {
            setState(() {
              _timeRange = rangeToSet;
            });
          },
          child: Text(text),
        );
      }

      return TextButton(
        onPressed: () {
          setState(() {
            _timeRange = rangeToSet;
          });
        },
        child: Text(text),
      );
    }

    return Container(
      height: 600,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRangeButton('1 Mese', StatisticsTimeRange.oneMonth),
              _buildRangeButton('6 Mesi', StatisticsTimeRange.sixMonths),
              _buildRangeButton('1 Anno', StatisticsTimeRange.oneYear),
            ],
          ),
          Expanded(
            child: widget.child(_timeRange),
          ),
        ],
      ),
    );
  }
}
