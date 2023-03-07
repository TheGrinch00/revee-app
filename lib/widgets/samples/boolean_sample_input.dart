import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/models/sample.dart';
import 'package:revee/providers/visit_create_edit_provider.dart';

class BooleanSampleInput extends StatefulWidget {
  const BooleanSampleInput({Key? key, required this.sample}) : super(key: key);

  final Sample sample;

  @override
  _BooleanSampleInputState createState() => _BooleanSampleInputState();
}

class _BooleanSampleInputState extends State<BooleanSampleInput> {
  @override
  Widget build(BuildContext context) {
    final visitCreateProvider = Provider.of<VisitCreateProvider>(context);
    final chosenSamples = visitCreateProvider.selectedSamples;
    final chosenSamplesIds =
        chosenSamples.map((sample) => sample.sample.id).toList();

    final isSampleAlreadyAdded = chosenSamplesIds.contains(widget.sample.id);
    final int value = isSampleAlreadyAdded
        ? chosenSamples
            .firstWhere((sample) => sample.sample.id == widget.sample.id)
            .quantity
        : 0;

    final bool _value = value != 0;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(widget.sample.name),
      trailing: Switch.adaptive(
        activeColor: Theme.of(context).primaryColor,
        value: _value,
        onChanged: (newVal) {
          visitCreateProvider.setSample(widget.sample, isGiven: newVal);
        },
      ),
    );
  }
}
