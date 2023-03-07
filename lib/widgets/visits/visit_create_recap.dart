import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/mixins/screen_load_feedback.dart';
import 'package:revee/models/product.dart';
import 'package:revee/models/visit.dart';
import 'package:revee/providers/auth_provider.dart';
import 'package:revee/providers/feedback_provider.dart';
import 'package:revee/providers/visit_create_edit_provider.dart';
import 'package:revee/providers/visits_provider.dart';
import 'package:revee/screens/visits_screen.dart';
import 'package:revee/utils/extensions/date_time_extension.dart';
import 'package:revee/utils/theme.dart';
import 'package:revee/widgets/employee/position_tile.dart';
import 'package:revee/widgets/employee/tiny_doctor_tile.dart';
import 'package:revee/widgets/generic/date_time_picker.dart';
import 'package:revee/widgets/product/product_card.dart';

// ignore: must_be_immutable
class VisitCreateRecap extends StatefulWidget {
  VisitCreateRecap({
    Key? key,
    this.isEdit,
    this.visitId,
    this.listSamples,
    this.listProducts,
  }) : super(key: key);
  bool? isEdit;
  int? visitId;
  List<VisitSample>? listSamples; //Samples if you are editing
  List<Product>? listProducts; //Products if you are editing
  @override
  _VisitCreateRecapState createState() => _VisitCreateRecapState();
}

class _VisitCreateRecapState extends State<VisitCreateRecap> {
  final _dateTimePickerKey = GlobalKey<DateTimePickerState>();

  bool _didVisitJustFinished = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    const defaultVerticalSpacing = 12.0;

    final visitsProvider = Provider.of<VisitsProvider>(context, listen: false);
    final memberId = Provider.of<AuthProvider>(context, listen: false).user!.id;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Consumer<VisitCreateProvider>(
                    builder: (context, provider, child) {
                      final doctor = provider.doctor;
                      final position = provider.position;
                      final visitName = provider.visitName;
                      final visitDescription = provider.visitDescription;
                      final products = provider.selectedProducts;
                      final samples = provider.selectedSamples;
                      final visitDate = provider.visitDate;

                      final longestSampleName = samples.isNotEmpty
                          ? samples
                              .map((visitSample) => visitSample.sample.name)
                              .fold(
                                0,
                                (int max, currentSample) =>
                                    currentSample.length > max
                                        ? currentSample.length
                                        : max,
                              )
                          : 0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              "RIEPILOGO",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: defaultVerticalSpacing),
                          if (visitName != null)
                            const Text(
                              "Titolo visita",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Text(
                              visitName ?? "Nessun nome assegnato",
                              style: TextStyle(
                                color: visitName == null
                                    ? Colors.grey
                                    : Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: defaultVerticalSpacing),
                          if (visitDescription != null)
                            const Text(
                              "Descrizione visita",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Text(
                              visitDescription ??
                                  "Nessuna descrizione appuntata",
                              maxLines: 4,
                              style: TextStyle(
                                color: visitDescription == null
                                    ? Colors.grey
                                    : Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(height: defaultVerticalSpacing),
                          const Text(
                            "Medico",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          if (doctor != null) TinyDoctorTile(doctor: doctor),
                          const SizedBox(height: defaultVerticalSpacing),
                          const Text(
                            "Posizione lavorativa",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          if (position != null)
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: PositionTile(position: position),
                                ),
                              ),
                            ),
                          if (products.isNotEmpty)
                            const SizedBox(height: defaultVerticalSpacing),
                          if (products.isNotEmpty)
                            const Text(
                              "Prodotti di interesse",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          if (products.isNotEmpty)
                            Wrap(
                              children: products
                                  .map(
                                    (p) => SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: IgnorePointer(
                                        child: ProductCard(
                                          prod: p,
                                          labelHeight: 20,
                                          hideLabel: true,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          if (samples.isNotEmpty)
                            const SizedBox(height: defaultVerticalSpacing),
                          if (samples.isNotEmpty)
                            const Text(
                              "Campioni gratuiti",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          if (samples.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  ...samples.map(
                                    (visitSample) => Row(
                                      children: [
                                        Text(
                                          "${visitSample.quantity} X ",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: CustomColors.violaScuro,
                                          ),
                                        ),
                                        Text(
                                          visitSample.sample.name,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: CustomColors.violaScuro,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          CheckboxListTile(
                            title: const Text(
                              "Visita avvenuta adesso",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            value: _didVisitJustFinished,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            onChanged: (newValue) {
                              setState(() {
                                _didVisitJustFinished = newValue ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          if (!_didVisitJustFinished)
                            Row(
                              children: [
                                Expanded(
                                  child: DateTimePicker(
                                    key: _dateTimePickerKey,
                                    initialDate: visitDate,
                                    firstDate: DateTime.now()
                                        .subtract(const Duration(days: 365)),
                                    lastDate: DateTime.now().endOfDay(),
                                    onDatePicked: (newDate) {
                                      provider.visitDate = newDate;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          if (!_didVisitJustFinished)
                            const SizedBox(height: defaultVerticalSpacing),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () async {
                                        if (!_didVisitJustFinished) {
                                          if (visitDate == null) {
                                            Provider.of<FeedbackProvider>(
                                              context,
                                              listen: false,
                                            ).showFailFeedback(
                                              context,
                                              "La data della visita è obbligatoria",
                                            );
                                            return;
                                          }
                                        }

                                        setState(() {
                                          _isLoading = true;
                                        });
                                        final Visit? createdVisit;
                                        if (widget.isEdit ?? false) {
                                          createdVisit =
                                              await visitsProvider.editVisit(
                                            visitId: widget.visitId ?? 0,
                                            agentId: memberId,
                                            doctor: doctor!,
                                            position: position!,
                                            products: products,
                                            samples: samples,
                                            samplesBefore: widget.listSamples,
                                            productsBefore: widget.listProducts,
                                            visitName: visitName,
                                            visitDescription: visitDescription,
                                            visitDate: _didVisitJustFinished
                                                ? DateTime.now()
                                                : visitDate!,
                                          );
                                        } else {
                                          createdVisit =
                                              await visitsProvider.postVisit(
                                            agentId: memberId,
                                            doctor: doctor!,
                                            position: position!,
                                            products: products,
                                            samples: samples,
                                            visitName: visitName,
                                            visitDescription: visitDescription,
                                            visitDate: _didVisitJustFinished
                                                ? DateTime.now()
                                                : visitDate!,
                                          );
                                        }

                                        setState(() {
                                          _isLoading = false;
                                        });
                                        if (!mounted) return;
                                        final feedbackProvider =
                                            Provider.of<FeedbackProvider>(
                                          context,
                                          listen: false,
                                        );

                                        if (createdVisit == null) {
                                          feedbackProvider.showFailFeedback(
                                            context,
                                            "Errore nella creazione della visita, riprova più tardi",
                                          );
                                        } else {
                                          provider.clear();
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                            VisitsScreen.routeName,
                                            (Route<dynamic> route) => false,
                                            arguments: const FeedbackRouteArgs(
                                              showFeedback: true,
                                              feedbackType:
                                                  FeedbackType.SUCCESS,
                                              feedbackMessage:
                                                  "Visita creata con successo",
                                            ),
                                          );
                                        }
                                      },
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : (widget.isEdit ?? false)
                                        ? const Text("Modifica visita")
                                        : const Text("Crea visita"),
                              ),
                              TextButton(
                                child: const Text("Indietro"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
