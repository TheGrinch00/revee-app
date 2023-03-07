import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:revee/widgets/employee/expiry_days_counter.dart';

import 'package:revee/models/doctor.dart';

import 'package:revee/screens/doctor_details_screen.dart';

class ExpansionProvider with ChangeNotifier {
  bool _isExpanded = false;

  // ignore: avoid_positional_boolean_parameters
  void setIsExpanded(bool newValue) {
    _isExpanded = newValue;
    notifyListeners();
  }

  bool get isExpanded => _isExpanded;
}

class DoctorCard extends StatelessWidget {
  const DoctorCard({Key? key, required this.doctor, this.canShow = true})
      : super(key: key);

  final Doctor doctor;
  final bool canShow;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ExpansionProvider(),
      child: DoctorCardContent(doctor: doctor, canShow: canShow),
    );
  }
}

class DoctorCardContent extends StatelessWidget {
  const DoctorCardContent({
    Key? key,
    required this.doctor,
    required this.canShow,
  }) : super(key: key);
  final Doctor doctor;
  final bool canShow;

  Widget _buildShowButton(BuildContext context) => TextButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorDetailScreen(
                doctor: doctor,
              ),
            ),
          ),
        },
        child: Row(
          children: const [
            Text("Mostra"),
            SizedBox(width: 10),
            Icon(Icons.visibility),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final expansionProvider =
        Provider.of<ExpansionProvider>(context, listen: false);

    final textTheme = Theme.of(context).textTheme;

    final solidViolet = Theme.of(context).secondaryHeaderColor;
    final opacityViolet = solidViolet.withOpacity(0.075);

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 6,
        child: Column(
          children: [
            ExpansionTile(
              onExpansionChanged: expansionProvider.setIsExpanded,
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Container(
                      width: 36,
                      height: 36,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: (doctor.photoURL == null ||
                                doctor.photoURL == "" ||
                                doctor.photoURL == "string")
                            ? Image.asset("assets/icons/doctor-icon.png")
                            : Image.network(
                                doctor.photoURL!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${doctor.name} ${doctor.surname}",
                          style: textTheme.headline6!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          doctor.email,
                          style: textTheme.headline6!
                              .copyWith(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: opacityViolet,
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: solidViolet,
                      ),
                    ),
                  ),
                  width: double.infinity,
                  child: Text(
                    doctor.note ?? "Nessuna nota disponibile",
                    style: textTheme.headline6,
                  ),
                ),
              ],
            ),
            Consumer<ExpansionProvider>(
              builder: (ctx, provider, child) => Container(
                decoration: BoxDecoration(
                  border: provider.isExpanded
                      ? null
                      : Border(
                          top: BorderSide(color: solidViolet),
                        ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: child,
              ),
              child: Row(
                children: [
                  Card(
                    color: opacityViolet,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        doctor.categoryName,
                        style: textTheme.headline6!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (doctor.status != DoctorStatus.VISITED)
                    const SizedBox(width: 10),
                  if (doctor.status != DoctorStatus.VISITED)
                    ExpiryDaysCounter(
                      expiryDays: doctor.expirationDays,
                      color: doctor.gravityColor,
                    ),
                  const Expanded(child: SizedBox()),
                  if (canShow) _buildShowButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
