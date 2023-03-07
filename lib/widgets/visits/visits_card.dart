import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revee/screens/visit_create_screen.dart';
import 'package:revee/widgets/product/product_card.dart';
import 'package:revee/utils/theme.dart';
import 'package:revee/models/visit.dart';
import 'package:revee/models/product.dart';
import 'package:revee/widgets/generic/pulsating_border_container.dart';

class VisitCard extends StatefulWidget {
  final Visit visit;

  const VisitCard({Key? key, required this.visit}) : super(key: key);

  @override
  _VisitCardState createState() => _VisitCardState();
}

class _VisitCardState extends State<VisitCard> {
  final visitReportFocusNode = FocusNode();
  late final reportController =
      TextEditingController(text: widget.visit.report);

  Widget _buildInfoRow(BuildContext context, String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: CustomColors.violaScuro,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      );

  Widget _buildTitleRow(BuildContext context, String label) => Text(
        label,
        style: Theme.of(context).textTheme.headline6!.copyWith(
              color: CustomColors.violaScuro,
              fontWeight: FontWeight.w600,
            ),
      );

  Widget _descriptionWidget() => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[100],
          ),
          child: widget.visit.isEditable
              ? TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  focusNode: visitReportFocusNode,
                  style: Theme.of(context).textTheme.headline6,
                  controller: reportController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                )
              : Text(
                  visitReport,
                  style: Theme.of(context).textTheme.headline6,
                ),
        ),
      );

  Widget _titleWidget(ctx) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            visitTitle,
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          _buildEditButton(ctx),
        ],
      );

  Widget _buildEditButton(ctx) => IconButton(
        onPressed: () async {
          if (widget.visit.isEditable) {
            await Navigator.of(context).pushNamed(
              VisitCreateScreen.routeName,
              arguments: VisitCreateArguments(
                doctor: widget.visit.doctor,
                visit: widget.visit,
                isEdit: true,
                listSamples: widget.visit.samples,
                listProducts: widget.visit.products,
              ),
            );
          }
        },
        icon: widget.visit.isEditable ? const Icon(Icons.edit) : Container(),
        color: CustomColors.revee,
      );

  Widget _buildProductsGrid(
    List<Product> products,
    BoxConstraints constraints,
  ) {
    final columnsCount = (constraints.maxWidth ~/ 300) + 2;
    final rowHeight = constraints.maxWidth / columnsCount;
    final rowsCount = (products.length / columnsCount).ceil();

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: rowHeight * rowsCount - 50,
            child: GridView.count(
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.5),
              crossAxisCount: columnsCount,
              children: List.generate(
                products.length,
                (index) => Stack(
                  children: [
                    IgnorePointer(
                      ignoring: widget.visit.isEditable,
                      child: ProductCard(
                        prod: products[index],
                        labelHeight: 30,
                      ),
                    ),
                    /*if (widget.visit.isEditable)
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: InkWell(
                              onTap: () {},
                              splashColor: Theme.of(context).primaryColor,
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),*/
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  String get visitTitle => widget.visit.title ?? "Visita: ${widget.visit.id}";
  String get visitReport =>
      widget.visit.report ??
      "Non è stata registrata alcuna nota relativa alla visita";

  @override
  void dispose() {
    visitReportFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chosenVisit = widget.visit;

    return PulsatingBorderContainer(
      isPulsating: widget.visit.isEditable,
      child: Card(
        margin: EdgeInsets.zero,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16).copyWith(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleWidget(context),
                    const SizedBox(height: 10),
                    _descriptionWidget(),
                    const SizedBox(height: 20),
                    _buildInfoRow(
                      context,
                      "Data",
                      DateFormat("d MMM yyyy, HH:mm")
                          .format(chosenVisit.realDate),
                    ),
                    _buildInfoRow(
                      context,
                      "Struttura",
                      chosenVisit.hospitalName ?? "Nessuna struttura",
                    ),
                    _buildInfoRow(
                      context,
                      "Medico",
                      chosenVisit.nameAndSurnameDoctor,
                    ),
                  ],
                ),
              ),
              if (chosenVisit.products.isNotEmpty)
                SingleChildScrollView(
                  child: ExpansionTile(
                    iconColor: CustomColors.violaScuro,
                    collapsedIconColor: CustomColors.violaScuro,
                    childrenPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    title: _buildTitleRow(
                      context,
                      "Prodotti di interesse",
                    ),
                    children: [
                      if (chosenVisit.products.isEmpty)
                        const Text(
                          "Non ci sono prodotti di interesse",
                        )
                      else
                        LayoutBuilder(
                          builder: (context, constraints) => _buildProductsGrid(
                            chosenVisit.products,
                            constraints,
                          ),
                        ),
                      /*if (widget.visit.isEditable == true)
                        
                      if (widget.visit.isEditable == false)
                        const AccordionProducts(),*/
                    ],
                  ),
                ),
              if (chosenVisit.samples.isNotEmpty)
                SingleChildScrollView(
                  child: ExpansionTile(
                    iconColor: CustomColors.violaScuro,
                    collapsedIconColor: CustomColors.violaScuro,
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
                    title: _buildTitleRow(context, "Campioni consegnati"),
                    children: [
                      ...chosenVisit.samples.map(
                        (visitSample) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Text(
                                "${visitSample.quantity.toString()} X ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.violaScuro,
                                ),
                              ),
                              Text(
                                visitSample.sample.name,
                                style: const TextStyle(
                                  color: CustomColors.violaScuro,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
