import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:revee/models/facility.dart';
import 'package:revee/providers/facility_provider.dart';
import 'package:revee/providers/feedback_provider.dart';
import 'package:revee/screens/hospitals_screen.dart';
import 'package:revee/utils/theme.dart';

import 'package:provider/provider.dart';
import 'package:revee/providers/auth_provider.dart';

import 'package:revee/widgets/appbar/revee_app_bar.dart';
import 'package:revee/utils/generic_functions.dart';

class CreateNewFacilityArguments {
  final Facility? facility;

  CreateNewFacilityArguments(this.facility);
}

class CreateNewFacilityScreen extends StatefulWidget {
  static const String routeName = '/hospital-create';

  const CreateNewFacilityScreen({Key? key}) : super(key: key);

  @override
  _CreateNewFacilityScreenState createState() =>
      _CreateNewFacilityScreenState();
}

class _CreateNewFacilityScreenState extends State<CreateNewFacilityScreen> {
  final _nameFormKey = GlobalKey<FormFieldState>();
  final _telephoneNumberFormKey = GlobalKey<FormFieldState>();
  final _websiteFormKey = GlobalKey<FormFieldState>();
  final _emailFormKey = GlobalKey<FormFieldState>();
  final _postalCodeFormKey = GlobalKey<FormFieldState>();
  final _houseNumberFormKey = GlobalKey<FormFieldState>();
  final _streeFormKey = GlobalKey<FormFieldState>();
  final _divisionFormKey = GlobalKey<FormFieldState>();
  final _typeFormKey = GlobalKey<FormFieldState>();

  String? _name;
  String? _phoneNumber;
  String? _email;
  String? _website;
  String? _street;
  String? _houseNumber;
  String? _postalCode;
  String? _division;
  String? _type;
  Facility? _facility;

  @override
  Widget build(BuildContext context) {
    final facility = _facility = (ModalRoute.of(context)!.settings.arguments
            as CreateNewFacilityArguments?)
        ?.facility;

    final size = MediaQuery.of(context).size;
    final List<String> divisions =
        Provider.of<AuthProvider>(context, listen: false).allowedDivisions;
    divisions.sort();
    return Scaffold(
      appBar: ReveeAppBar(
          title: facility != null
              ? "Modifica una struttura"
              : "Crea una nuova struttura",),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  key: _nameFormKey,
                  initialValue: facility?.name,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                  onChanged: (value) => {
                    setState(() {
                      _name = value.trim().toTitleCase();
                    })
                  },
                  validator: (String? value) {
                    if (value == null) {
                      return 'Inserisci un nome';
                    }
                    if (value.isEmpty) {
                      return 'Inserisci un nome';
                    }
                    return (value.contains('@'))
                        ? 'Do not use the @ char.'
                        : null;
                  },
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  key: _telephoneNumberFormKey,
                  initialValue: facility?.phoneNumber,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Telefono (Opzionale)',
                  ),
                  onChanged: (value) => {
                    setState(() {
                      _phoneNumber = value.trim().replaceAll(' ', '');
                    })
                  },
                  validator: (value) => validatePhone(value!),
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  key: _emailFormKey,
                  initialValue: facility?.email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email (Opzionale)',
                  ),
                  onChanged: (value) => {
                    setState(() {
                      _email = value.trim();
                    })
                  },
                  validator: (value) =>
                      validateEmailWithPossibleEmptyValue(_email),
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  key: _websiteFormKey,
                  initialValue: facility?.website,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Sito Web (Opzionale)',
                  ),
                  onChanged: (value) => {
                    setState(() {
                      _website = value.trim();
                    })
                  },
                  validator: (String? value) {
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  key: _streeFormKey,
                  initialValue: facility?.street,
                  keyboardType: TextInputType.streetAddress,
                  decoration: const InputDecoration(
                    labelText: 'Indirizzo (Opzionale)',
                  ),
                  onChanged: (value) => {
                    setState(() {
                      _street = value.trim().toTitleCase();
                    })
                  },
                  validator: (String? value) {
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  key: _houseNumberFormKey,
                  initialValue: facility?.houseNumber,
                  decoration: const InputDecoration(
                    labelText: 'Numero Civico (Opzionale)',
                  ),
                  onChanged: (value) => {
                    setState(() {
                      _houseNumber = value.trim();
                    })
                  },
                  validator: (String? value) {
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  key: _postalCodeFormKey,
                  initialValue: facility?.postalCode,
                  decoration: const InputDecoration(
                    labelText: 'CAP (Opzionale)',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) => {
                    setState(() {
                      _postalCode = value.trim();
                    })
                  },
                  validator: (String? value) {
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.02),
                DropdownButtonFormField<String>(
                    hint: const Text(
                      "Seleziona la provincia",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.left,
                    ),
                    isExpanded: true,
                    value: _division ?? facility?.province,
                    key: _divisionFormKey,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    style: const TextStyle(color: CustomColors.violaScuro),
                    onChanged: (String? newValue) {
                      setState(() {
                        _division = newValue;
                      });
                    },
                    items: divisions.map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Seleziona una provincia';
                      }
                      return null;
                    },),
                SizedBox(height: size.height * 0.02),
                DropdownButtonFormField<String>(
                  hint: const Text(
                    "Seleziona il tipo di struttura",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.left,
                  ),
                  isExpanded: true,
                  value: _type ?? facility?.facilityType.name,
                  key: _typeFormKey,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  style: const TextStyle(color: CustomColors.violaScuro),
                  onChanged: (String? newValue) {
                    setState(() {
                      _type = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Seleziona il tipo di struttura';
                    }
                    return null;
                  },
                  items: <String>[
                    'Ospedale pubblico',
                    'Ospedale privato',
                    'Farmacia',
                    'Studio medico',
                    'Parafarmacia'
                  ].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                ),
                SizedBox(height: size.height * 0.02),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => {
                      if (_nameFormKey.currentState!.validate() &&
                          _emailFormKey.currentState!.validate() &&
                          _telephoneNumberFormKey.currentState!.validate() &&
                          _divisionFormKey.currentState!.validate() &&
                          _typeFormKey.currentState!.validate())
                        {onSubmit()}
                    },
                    child: Text(
                      "CREA NUOVA STRUTTURA ",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Facility?> onSubmit() async {
    final feedbackProvider =
        Provider.of<FeedbackProvider>(context, listen: false);
    final facilityProvider =
        Provider.of<FacilityProvider>(context, listen: false);

    if (_name == null) {
      feedbackProvider.showFailFeedback(
        context,
        "Devi scrivere un nome",
      );
      return null;
    }

    if (_division == null) {
      feedbackProvider.showFailFeedback(
        context,
        "Devi selezionare una provincia",
      );
      return null;
    }

    if (_type == null) {
      feedbackProvider.showFailFeedback(
        context,
        "Devi selezionare un tipo di struttura",
      );
      return null;
    }
    final createdStructure = _facility != null
        ? await facilityProvider.patchFacility(
            id: _facility!.id,
            name: _name!,
            division: _division!,
            type: _type!,
            address: _street,
            cap: _postalCode,
            email: _email,
            houseNumber: _houseNumber,
            telephone: _phoneNumber,
            website: _website,
          )
        : await facilityProvider.postFacility(
            name: _name!,
            division: _division!,
            type: _type!,
            address: _street,
            cap: _postalCode,
            email: _email,
            houseNumber: _houseNumber,
            telephone: _phoneNumber,
            website: _website,
          );

    Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return null;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HospitalsScreen(),
      ),
    );

    if (!mounted) return null;
    feedbackProvider.showSuccessFeedback(
      context,
      "Struttura $_name creata con successo!",
    );

    return createdStructure;
  }
}
