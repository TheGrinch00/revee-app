import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/models/sample.dart';
import 'package:revee/providers/samples_provider.dart';
import 'package:revee/widgets/samples/boolean_sample_input.dart';
import 'package:revee/widgets/samples/numeric_sample_input.dart';

class SamplesStep extends StatelessWidget {
  const SamplesStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SamplesProvider>(
      builder: (ctx, samplesProvider, child) => Column(
        children: samplesProvider.samples
            .map(
              (sample) => sample.type == AllowedTypes.BOOL
                  ? BooleanSampleInput(sample: sample)
                  : NumericSampleInput(sample: sample),
            )
            .toList(),
      ),
    );
  }
}
