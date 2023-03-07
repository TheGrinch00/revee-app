import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/models/sample.dart';
import 'package:revee/providers/visit_create_edit_provider.dart';

class NumericSampleInput extends StatefulWidget {
  const NumericSampleInput({Key? key, required this.sample}) : super(key: key);

  final Sample sample;

  @override
  _NumericSampleInputState createState() => _NumericSampleInputState();
}

class _NumericSampleInputState extends State<NumericSampleInput> {
  final TextEditingController controller = TextEditingController();
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

    controller.text = value.toString();
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return ListTile(
      minVerticalPadding: 0.0,
      contentPadding: EdgeInsets.zero,
      title: Text(widget.sample.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: value == 0
                ? null
                : () {
                    if (value > 0) {
                      visitCreateProvider.setSample(
                        widget.sample,
                        quantity: value - 1,
                      );
                    }
                  },
            icon: const Icon(Icons.remove),
            color: Theme.of(context).secondaryHeaderColor,
          ),
          SizedBox(
            width: 50,
            child: TextField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              controller: controller,
              onChanged: (value) {
                final isNumber =
                    int.tryParse(value.isEmpty ? "0" : value) != null;

                visitCreateProvider.setSample(
                  widget.sample,
                  quantity:
                      isNumber ? int.parse(value.isEmpty ? '0' : value) : 0,
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {
              visitCreateProvider.setSample(
                widget.sample,
                quantity: value + 1,
              );
            },
            icon: const Icon(Icons.add),
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ],
      ),
    );
  }
}
