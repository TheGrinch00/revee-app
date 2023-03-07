import 'package:flutter/material.dart';
import 'package:revee/Charts/campioni_consegnati_nel_tempo.dart';
import 'package:revee/Charts/contatti_aggiunti_quest_anno.dart';
import 'package:revee/Charts/contatti_per_provincia.dart';
import 'package:revee/Charts/medici_visitati.dart';
import 'package:revee/Charts/nuovi_contatti_al_mese.dart';
import 'package:revee/Charts/nuovi_medici.dart';
import 'package:revee/Charts/visite_di_oggi.dart';
import 'package:revee/utils/theme.dart';

class ChartsPage extends StatefulWidget {
  @override
  ChartsPageState createState() => ChartsPageState();
}

class ChartsPageState extends State<ChartsPage>
    with SingleTickerProviderStateMixin {
  final List<_ChartElement> _allPages = <_ChartElement>[
    _ChartElement(
      icon: Icons.pie_chart,
      text: 'CONTATTI AGGIUNTI\nNEL ${DateTime.now().year}',
      chart: ContattiAggiuntiQuestAnno(),
    ),
    _ChartElement(
      icon: Icons.table_chart,
      text: 'NUOVI CONTATTI\nAL MESE',
      chart: NuoviContattiMese(),
    ),
    _ChartElement(
      icon: Icons.bubble_chart,
      text: 'LE VISITE\nDI OGGI',
      chart: VisiteDiOggi(),
    ),
    // _ChartElement(
    //   icon: Icons.multiline_chart,
    //   text: 'FASCE: A e B',
    //   chart: FasceAB(),
    // ),
    _ChartElement(
      icon: Icons.insert_chart,
      text: 'CONTATTI\nPER PROVINCIA',
      chart: ContattiProvincia(),
    ),
    _ChartElement(
      icon: Icons.insert_chart,
      text: 'NUOVI MEDICI',
      chart: NuoviMedici(),
    ),
    _ChartElement(
      icon: Icons.insert_chart,
      text: 'MEDICI VISITATI',
      chart: MediciVisitati(),
    ),
    _ChartElement(
      icon: Icons.show_chart,
      text: 'CAMPIONI\nCONSEGNATI',
      chart: CampioniConsegnatiNelTempo(),
    ),
  ];

  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _allPages.length);

    _reloadContents();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          labelColor: CustomColors.violaScuro,
          controller: _controller,
          isScrollable: true,
          tabs: _allPages
              .map(
                (_ChartElement page) => Tab(
                  text: page.text,
                  icon: Icon(page.icon),
                ),
              )
              .toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: _allPages,
          ),
        )
      ],
    );
  }
}

class _ChartElement extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget chart;

  const _ChartElement({
    required this.icon,
    required this.text,
    required this.chart,
  });

  @override
  Widget build(BuildContext context) => chart;
}

void _reloadContents() {}
