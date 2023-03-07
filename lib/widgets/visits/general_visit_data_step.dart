import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/providers/visit_create_edit_provider.dart';

class GeneralVisitDataStep extends StatelessWidget {
  const GeneralVisitDataStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visitCreateProvider = Provider.of<VisitCreateProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Nome visita (opzionale)',
            ),
            initialValue: visitCreateProvider.visitName,
            maxLength: 30,
            onChanged: (value) => visitCreateProvider.visitName = value,
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Descrizione visita (opzionale)',
              alignLabelWithHint: true,
            ),
            initialValue: visitCreateProvider.visitDescription,
            minLines: 4,
            maxLines: 4,
            maxLength: 200,
            onChanged: (value) => visitCreateProvider.visitDescription = value,
          ),
        ],
      ),
    );
  }
}
