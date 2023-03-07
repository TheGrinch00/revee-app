import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:revee/models/doctor.dart';
import 'package:revee/models/position.dart';
import 'package:revee/models/product.dart';
import 'package:revee/models/visit.dart';
import 'package:revee/providers/doctor_provider.dart';
import 'package:revee/providers/position_provider.dart';
import 'package:revee/providers/products_provider.dart';
import 'package:revee/providers/samples_provider.dart';
import 'package:revee/providers/visit_create_edit_provider.dart';
import 'package:revee/widgets/appbar/revee_app_bar.dart';
import 'package:revee/widgets/generic/hero_dialog_route.dart';
import 'package:revee/widgets/generic/revee_loader.dart';
import 'package:revee/widgets/product/accordion_products.dart';
import 'package:revee/widgets/visits/doctor_selection_step.dart';
import 'package:revee/widgets/visits/general_visit_data_step.dart';
import 'package:revee/widgets/visits/position_selection_step.dart';
import 'package:revee/widgets/visits/samples_selection_step.dart';
import 'package:revee/widgets/visits/visit_create_recap.dart';

class VisitCreateArguments {
  const VisitCreateArguments({
    this.doctor,
    this.position,
    this.isEdit,
    this.visit,
    this.listSamples,
    this.listProducts,
    //TODO: ADD OTHER STUFF
  });
  final bool? isEdit;
  final Doctor? doctor;
  final Position? position;
  final Visit? visit;
  final List<VisitSample>? listSamples;
  final List<Product>? listProducts;
}

class VisitCreateScreen extends StatefulWidget {
  static const String routeName = '/visit-create';

  const VisitCreateScreen({Key? key}) : super(key: key);

  @override
  _VisitCreateScreenState createState() => _VisitCreateScreenState();
}

class _VisitCreateScreenState extends State<VisitCreateScreen> {
  final stepsCount = 5;
  bool? isEdit = false;
  int? visitId = 0;
  int _step = 0;
  List<VisitSample>? listSamples;
  List<Product>? listProducts;
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final visitCreateProvider =
          Provider.of<VisitCreateProvider>(context, listen: false);
      final args =
          ModalRoute.of(context)?.settings.arguments as VisitCreateArguments?;

      final doctor = args?.doctor;
      final position = args?.position;
      isEdit = args?.isEdit;
      listSamples = args?.listSamples;
      listProducts = args?.listProducts;
      if (args?.visit != null) {
        visitId = args?.visit!.id;
      }
      setState(() {
        if (listProducts != null) {
          visitCreateProvider.selectedProducts = listProducts!;
        }

        if (doctor != null && position != null) {
          visitCreateProvider.doctor = doctor;
          visitCreateProvider.position = position;
          _step = 2;
        } else if (doctor != null && position == null) {
          visitCreateProvider.doctor = doctor;
          _step = 1;
        } else {
          _step = 0;
        }
      });
    });
  }

  void displayRecapDialog() {
    Navigator.of(context).push(
      HeroDialogRoute(
          isDismissable: true,
          builder: (context) {
            if (isEdit ?? false) {
              return VisitCreateRecap(
                isEdit: isEdit,
                visitId: visitId,
                listSamples: listSamples,
                listProducts: listProducts,
              );
            } else {
              return VisitCreateRecap(
                isEdit: isEdit,
              );
            }
          },),
    );
  }

  bool _canStepperContinue(VisitCreateProvider provider) {
    bool isAllowedToContinue = false;

    switch (_step) {
      case 0:
        isAllowedToContinue = provider.doctor != null;
        break;
      case 1:
        isAllowedToContinue = provider.position != null;
        break;
      case 2:
        isAllowedToContinue = true;
        break;
      case 3:
        isAllowedToContinue = true;
        break;
      case 4:
        isAllowedToContinue = true;
        break;
      default:
        return false;
    }

    return isAllowedToContinue;
  }

  List<Step> buildSteps() {
    final doctorsProvider = Provider.of<DoctorProvider>(context, listen: false);
    final positionProvider =
        Provider.of<PositionProvider>(context, listen: false);
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final samplesProvider =
        Provider.of<SamplesProvider>(context, listen: false);

    return [
      Step(
        title: Consumer<VisitCreateProvider>(
          builder: (ctx, provider, _) {
            final doctor = provider.doctor;

            return _step != 0
                ? doctor == null
                    ? const Text("Seleziona medico")
                    : Text("Dr. ${doctor.name} ${doctor.surname}")
                : const Text("Seleziona medico");
          },
        ),
        content: FutureBuilder<List<Doctor>>(
          future: doctorsProvider.fetchDoctors(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ReveeBouncingLoader(),
                ),
              );
            } else {
              final options = snapshot.data ?? [];
              return DoctorSelectionStep(doctors: options);
            }
          },
        ),
        isActive: _step >= 0,
      ),
      Step(
        title: Consumer<VisitCreateProvider>(
          builder: (ctx, provider, _) {
            final position = provider.position;

            return _step != 1
                ? position == null
                    ? const Text("Seleziona posizione")
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(position.facility!.name),
                          Text(
                            position.facility!.address,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                : const Text("Seleziona posizione");
          },
        ),
        content: Consumer<VisitCreateDoctorProvider>(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ReveeBouncingLoader(),
            ),
          ),
          builder: (ctx, provider, child) => provider.doctorId == null
              ? const Text("Nessun medico selezionato")
              : FutureBuilder<List<Position>>(
                  future: positionProvider
                      .fetchPositionsByDoctorId(provider.doctorId!),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return child!;
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Si è verificato un errore"),
                      );
                    }

                    final options = snapshot.data ?? [];
                    return PositionSelectionStep(positions: options);
                  },
                ),
        ),
        isActive: _step >= 1,
      ),
      Step(
        title: const Text("Dati generali"),
        content: const GeneralVisitDataStep(),
        isActive: _step >= 2,
      ),
      Step(
        title: Consumer<VisitCreateProvider>(
          builder: (ctx, provider, _) {
            final products = provider.selectedProducts;
            final quantityDescription = products.length == 1
                ? "Prodotto selezionato"
                : "Prodotti selezionati";

            return _step >= 3
                ? Text("${products.length} $quantityDescription")
                : const Text("Prodotti di interesse");
          },
        ),
        content: FutureBuilder(
          future: productsProvider.fetchProducts(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ReveeBouncingLoader(),
                ),
              );
            } else {
              return AccordionProducts(isCreatingVisit: !(isEdit ?? false));
            }
          },
        ),
        isActive: _step >= 3,
      ),
      Step(
        title: const Text("Campioni gratuiti"),
        content: FutureBuilder(
          future: samplesProvider.fetchSamples(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ReveeBouncingLoader(),
                ),
              );
            }

            return const SamplesStep();
          },
        ),
        isActive: _step >= 4,
      ),
    ];
  }

  Widget buildStepperActions(
    BuildContext context,
    ControlsDetails details,
  ) =>
      Consumer<VisitCreateProvider>(
        builder: (ctx, provider, child) {
          return Row(
            children: <Widget>[
              if (_step != stepsCount - 1)
                ElevatedButton(
                  onPressed: _canStepperContinue(provider)
                      ? details.onStepContinue
                      : null,
                  child: const Text('Avanti'),
                ),
              if (_step == stepsCount - 1)
                ElevatedButton(
                  onPressed: () => displayRecapDialog(),
                  child: const Text('Riassunto'),
                ),
              const SizedBox(width: 16),
              if (_step != 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Indietro'),
                ),
            ],
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReveeAppBar(
        title: (isEdit ?? false) ? "Modifica la vista" : "Crea nuova visita",
        automaticallyImplyLeading: false,
        onPopEffect: () =>
            Provider.of<VisitCreateProvider>(context, listen: false).clear(),
      ),
      body: SafeArea(
        child: Stepper(
          currentStep: _step,
          onStepContinue: () {
            setState(() {
              _step++;
            });
          },
          onStepCancel: () {
            setState(() {
              _step = _step - 1;
            });
          },
          controlsBuilder: buildStepperActions,
          steps: buildSteps(),
        ),
      ),
    );
  }
}
