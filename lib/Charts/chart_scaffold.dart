import 'package:flutter/material.dart';
import 'package:revee/widgets/generic/revee_loader.dart';

class ChartScaffold<T> extends StatefulWidget {
  final IconData? icon;
  final String? text;
  final Widget Function(T?) legend;
  final String description;
  final Widget Function(T?) chart;
  final Future<T> future;

  const ChartScaffold({
    Key? key,
    required this.legend,
    required this.description,
    required this.chart,
    required this.future,
    this.icon,
    this.text,
  }) : super(key: key);

  @override
  _ChartScaffoldState<T> createState() => _ChartScaffoldState<T>();
}

class _ChartScaffoldState<T> extends State<ChartScaffold> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: (widget as ChartScaffold<T>).future,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: ReveeBouncingLoader());
        }

        return Container(
          height: 600,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Center(child: (widget as ChartScaffold<T>).legend(snapshot.data)),
              Expanded(
                child: Center(
                  child: (widget as ChartScaffold<T>).chart(snapshot.data),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    widget.description,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
