import 'package:flutter/material.dart';
import 'package:revee/models/employment.dart';
import 'package:revee/models/ward.dart';

class DropdownStringSelect extends StatefulWidget {
  const DropdownStringSelect({
    Key? key,
    required this.options,
    this.hint = "Seleziona un'opzione",
  }) : super(key: key);

  final List<String> options;
  final String hint;

  @override
  DropdownStringSelectState createState() => DropdownStringSelectState();
}

class DropdownStringSelectState extends State<DropdownStringSelect> {
  String? chosenValue;

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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            widget.hint,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          value: chosenValue,
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          elevation: 5,
          onChanged: (String? newValue) {
            setState(() {
              chosenValue = newValue;
            });
          },
          items: widget.options.map<DropdownMenuItem<String>>(
            (String s) {
              return DropdownMenuItem<String>(
                key: ValueKey(s),
                value: s,
                child: Text(
                  s,
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}

class DropdownEmploymentsSelect extends StatefulWidget {
  const DropdownEmploymentsSelect({
    Key? key,
    required this.options,
    this.hint = "Seleziona un'opzione",
  }) : super(key: key);

  final List<Employment> options;
  final String hint;

  @override
  DropdownEmploymentsSelectState createState() =>
      DropdownEmploymentsSelectState();
}

class DropdownEmploymentsSelectState extends State<DropdownEmploymentsSelect> {
  Employment? chosenValue;

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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Employment>(
          hint: Text(
            widget.hint,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          value: chosenValue,
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          elevation: 5,
          onChanged: (Employment? newValue) {
            setState(() {
              chosenValue = newValue;
            });
          },
          items: widget.options.map<DropdownMenuItem<Employment>>(
            (Employment e) {
              return DropdownMenuItem<Employment>(
                key: ValueKey(e.id),
                value: e,
                child: Text(
                  e.employmentName,
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}

class DropdownWardsSelect extends StatefulWidget {
  const DropdownWardsSelect({
    Key? key,
    required this.options,
    this.hint = "Seleziona un'opzione",
  }) : super(key: key);

  final List<Ward> options;
  final String hint;

  @override
  DropdownWardsSelectState createState() => DropdownWardsSelectState();
}

class DropdownWardsSelectState extends State<DropdownWardsSelect> {
  Ward? chosenValue;

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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Ward>(
          hint: Text(
            widget.hint,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          value: chosenValue,
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          elevation: 5,
          onChanged: (Ward? newValue) {
            setState(() {
              chosenValue = newValue;
            });
          },
          items: widget.options.map<DropdownMenuItem<Ward>>(
            (Ward w) {
              return DropdownMenuItem<Ward>(
                key: ValueKey(w.id),
                value: w,
                child: Text(
                  w.name,
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
