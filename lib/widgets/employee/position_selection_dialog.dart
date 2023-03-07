import 'package:flutter/material.dart';
import 'package:revee/models/position.dart';
import 'package:revee/widgets/employee/position_tile.dart';

class PositionSelectionDialog extends StatelessWidget {
  const PositionSelectionDialog({Key? key, required this.options})
      : super(key: key);

  final List<Position> options;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16,
                      ),
                      child: Text(
                        "Seleziona una posizione lavorativa per la visita",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(
                      options.length,
                      (index) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: PositionTile(position: options[index]),
                            onTap: () {
                              Navigator.pop(context, options[index]);
                            },
                          ),
                          if (index != options.length - 1)
                            Divider(
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
