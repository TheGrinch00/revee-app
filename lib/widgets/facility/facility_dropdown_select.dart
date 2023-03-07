import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:revee/models/facility.dart';

import 'dart:developer' as developer;

class FacilitiesDropdownSelect extends StatefulWidget {
  const FacilitiesDropdownSelect({Key? key, required this.options})
      : super(key: key);

  final List<Facility> options;

  @override
  FacilitiesDropdownSelectState createState() =>
      FacilitiesDropdownSelectState();
}

class FacilitiesDropdownSelectState extends State<FacilitiesDropdownSelect> {
  Facility? chosenFacility;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Facility?>(
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          label: Text(
            "Scegli un ospedale (Obbligatorio)",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      itemAsString: (f) => f!.name,
      filterFn: (f, s) => f!.name.toLowerCase().contains(s.toLowerCase()),
      popupProps: PopupProps.dialog(
        itemBuilder: (context, f, x) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).secondaryHeaderColor.withOpacity(0.6),
              ),
            ),
            child: DropdownMenuItem<Facility>(
              //key: ValueKey(f!.id),
              value: f,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    f!.name,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    f.address,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: 12.0),
                  ),
                ],
              ),
            ),
          );
        },
        showSearchBox: true,
        searchFieldProps: const TextFieldProps(
          decoration: InputDecoration(
            label: Text(
              "Cerca un ospedale",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      items: widget.options,
      onChanged: (f) => setState(() {
        chosenFacility = f;
      }),
    );
  }
}
