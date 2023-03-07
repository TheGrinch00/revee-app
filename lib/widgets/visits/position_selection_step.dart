import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/models/position.dart';
import 'package:revee/providers/visit_create_edit_provider.dart';
import 'package:revee/widgets/employee/position_tile.dart';

class PositionSelectionStep extends StatefulWidget {
  const PositionSelectionStep({
    Key? key,
    required this.positions,
    this.hint = "Scegli una posizione",
  }) : super(key: key);

  final List<Position> positions;
  final String hint;

  @override
  State<PositionSelectionStep> createState() => _PositionSelectionStepState();
}

class _PositionSelectionStepState extends State<PositionSelectionStep> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).secondaryHeaderColor.withOpacity(0.6),
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Consumer<VisitCreateProvider>(
        builder: (ctx, provider, _) {
          final position = provider.position;

          return widget.positions.isEmpty
              ? const Text("Nessuna posizione disponibile")
              : DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    hint: Text(
                      widget.hint,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    value: position?.id,
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    itemHeight: position == null ? 50 : 70.0,
                    elevation: 5,
                    onChanged: (int? chosenId) {
                      provider.position = widget.positions
                          .firstWhere((pos) => pos.id == chosenId);
                    },
                    dropdownColor: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5.0),
                    items: List.generate(
                      widget.positions.length,
                      (index) => DropdownMenuItem<int>(
                        key: ValueKey(widget.positions[index].id),
                        value: widget.positions[index].id,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child:
                              PositionTile(position: widget.positions[index]),
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
