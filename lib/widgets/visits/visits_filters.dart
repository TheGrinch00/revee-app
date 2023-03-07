import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/providers/visits_filters_provider.dart';
import 'package:revee/widgets/generic/date_picker.dart';

class VisitsFilters extends StatelessWidget {
  const VisitsFilters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filtersProvider = Provider.of<VisitsFiltersProvider>(context);
    final currentFilter = filtersProvider.filterType;

    Widget _buildCustomFilters() => Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: DatePicker(
                  emptyText: "Dal giorno",
                  defaultValue: filtersProvider.startDate,
                  initialDate: filtersProvider.defaultStartDate,
                  firstDate: filtersProvider.minDate,
                  lastDate: filtersProvider.endDate ?? filtersProvider.maxDate,
                  onDateChanged: (date) {
                    filtersProvider.startDate = date;
                  },
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: DatePicker(
                  emptyText: "Al giorno",
                  defaultValue: filtersProvider.endDate,
                  initialDate: filtersProvider.defaultEndDate,
                  firstDate:
                      filtersProvider.startDate ?? filtersProvider.minDate,
                  lastDate: filtersProvider.maxDate,
                  onDateChanged: (date) {
                    filtersProvider.endDate = date;
                  },
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );

    Widget _buildFilterButton(
      String text,
      FilterTypes filterType,
    ) =>
        currentFilter == filterType
            ? ElevatedButton(
                onPressed: () {
                  filtersProvider.filterType = FilterTypes.NONE;
                },
                child: Text(text),
              )
            : TextButton(
                onPressed: () {
                  filtersProvider.filterType = filterType;
                },
                child: Text(text),
              );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFilterButton(
                "Oggi",
                FilterTypes.TODAY,
              ),
              _buildFilterButton(
                "Ultimi 7 giorni",
                FilterTypes.THIS_WEEK,
              ),
              _buildFilterButton(
                "Personalizzato",
                FilterTypes.CUSTOM,
              ),
            ],
          ),
        ),
        if (currentFilter == FilterTypes.CUSTOM) _buildCustomFilters(),
        if (currentFilter == FilterTypes.CUSTOM) const SizedBox(height: 10),
      ],
    );
  }
}
