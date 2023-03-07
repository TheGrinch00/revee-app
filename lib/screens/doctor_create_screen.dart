import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Utils
import 'package:revee/utils/theme.dart';
import 'package:revee/utils/generic_functions.dart';

// Models
import 'package:revee/models/doctor.dart';

// Providers
import 'package:revee/providers/doctor_provider.dart';
import 'package:revee/providers/feedback_provider.dart';

// Screens
import 'package:revee/screens/doctors_screen.dart';

// Widgets
import 'package:revee/widgets/generic/date_picker.dart';
import 'package:revee/widgets/generic/image_picker.dart';
import 'package:revee/widgets/appbar/revee_app_bar.dart';

class CreateNewDoctorArguments {
  final Doctor? doctor;

  const CreateNewDoctorArguments({
    this.doctor,
  });
}

class CreateNewDoctorScreen extends StatefulWidget {
  static const String routeName = '/doctor-create';
  final Doctor? doctor;

  const CreateNewDoctorScreen({
    Key? key,
    this.doctor,
  }) : super(key: key);

  @override
  _CreateNewDoctorScreenState createState() => _CreateNewDoctorScreenState();
}

class _CreateNewDoctorScreenState extends State<CreateNewDoctorScreen> {
  String? _category = "Fascia A";
  String? _name;
  String? _surname;
  String? _email;
  DateTime? _birthDate;
  String? _categoryReason;
  String? _note;
  String? _telephone;

  final _nameFormKey = GlobalKey<FormFieldState>();
  final _surnameFormKey = GlobalKey<FormFieldState>();
  final _emailFormKey = GlobalKey<FormFieldState>();
  final _categoryReasonFormKey = GlobalKey<FormFieldState>();
  final _noteFormKey = GlobalKey<FormFieldState>();
  final _telephoneFormKey = GlobalKey<FormFieldState>();
  final _categoryFormKey = GlobalKey();
  final _birthDateFormKey = GlobalKey<DatePickerState>();
  final _imagePickerFormKey = GlobalKey<ImagePickerTileState>();


  @override
  void initState() {
    super.initState();
    final doctor = widget.doctor;
    if(doctor == null) return;
    setState(() {
      _category = doctor.categoryName;
      _name = doctor.name;
      _surname = doctor.surname;
      _email = doctor.email;
      _birthDate = doctor.birthDate;
      _categoryReason = doctor.categoryReason;
      _note = doctor.note;
      _telephone = doctor.phoneNumber;
    });
  }

  Future<Doctor?> onSubmit() async {
    final feedbackProvider =
        Provider.of<FeedbackProvider>(context, listen: false);
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);

    if (_name == null) {
      feedbackProvider.showFailFeedback(
        context,
        "Devi scrivere un nome",
      );
      return null;
    }

    if (_surname == null) {
      feedbackProvider.showFailFeedback(
        context,
        "Devi scrivere un cognome",
      );
      return null;
    }

    if (_email == null) {
      feedbackProvider.showFailFeedback(
        context,
        "Devi scrivere un email",
      );
      return null;
    }

    if (_category == "Fascia B" && _categoryReason == null) {
      if (_categoryReason!.isEmpty) {
        feedbackProvider.showFailFeedback(
          context,
          "Se la categoria è B devi scrivere una motivazione per la categoria",
        );
      }
      return null;
    }

    String _urlImg = "";
    String? _nameFile = "";
    late File? picture;
    if (_imagePickerFormKey.currentState != null) {
      picture = _imagePickerFormKey.currentState!.selected;
      _nameFile = await doctorProvider.uploadImage(picture);
      if (_nameFile != null) {
        _urlImg = doctorProvider.getImageUrl(_nameFile);
      }
    }

    final createdDoctor = widget.doctor != null ? 
      await doctorProvider.patchDoctor(
        id: widget.doctor!.id,
        name: _name ?? "",
        surname: _surname ?? "",
        email: _email ?? "",
        category: _category ?? "",
        birthDate: _birthDate ?? DateTime(1980),
        numeroTelefono: _telephone ?? "",
        urlPhoto: _urlImg,
        categoryReason: _categoryReason ?? "",
        note: _note ?? "",
      )
      :
      await doctorProvider.postDoctor(
        name: _name ?? "",
        surname: _surname ?? "",
        email: _email ?? "",
        category: _category ?? "",
        birthDate: _birthDate ?? DateTime(1980),
        numeroTelefono: _telephone ?? "",
        urlPhoto: _urlImg,
        categoryReason: _categoryReason ?? "",
        note: _note ?? "",
      ); 

    if (!mounted) return null;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorsScreen(),
      ),
    );

    if (!mounted) return null;
    feedbackProvider.showSuccessFeedback(
      context,
      widget.doctor != null ? "Medico aggiornato con successo!" : "Medico $_name $_surname creato con successo!",
    );

    return createdDoctor;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: ReveeAppBar(title: widget.doctor != null ? "Aggiorna medico" : "Crea un nuovo medico"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  key: _nameFormKey,
                  initialValue: widget.doctor?.name,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                  onChanged: (value) => {
                    setState(() {
                      _name = value.trim().toTitleCase();
                    })
                  },
                  validator: (String? value) {
                    return (value != null && value.contains('@'))
                        ? 'Do not use the @ char.'
                        : null;
                  },
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  key: _surnameFormKey,
                  decoration: const InputDecoration(
                    labelText: 'Cognome',
                  ),
                  initialValue: widget.doctor?.surname,
                  onChanged: (value) => {
                    setState(() {
                      _surname = value.trim().toTitleCase();
                    })
                  },
                  validator: (String? value) {
                    return (value != null && value.contains('@'))
                        ? 'Do not use the @ char.'
                        : null;
                  },
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  key: _emailFormKey,
                  initialValue: widget.doctor?.email,
                  decoration: const InputDecoration(
                    labelText: 'Email ',
                  ),
                  onChanged: (value) => {
                    setState(() {
                      _email = value.trim();
                    })
                  },
                  validator: (value) => validateEmail(value),
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  key: _telephoneFormKey,
                  initialValue: widget.doctor?.phoneNumber,
                  decoration: const InputDecoration(
                    labelText: 'Telefono (Opzionale)',
                  ),
                  onChanged: (value) => {
                    setState(() {
                      _telephone = value.trim();
                    })
                  },
                  validator: (value) => validatePhone(value!),
                ),
                SizedBox(height: size.height * 0.02),
                DatePicker(
                  key: _birthDateFormKey,
                  emptyText: "Data di Nascita (opzionale)",
                  firstDate: DateTime.utc(1900),
                  lastDate: DateTime.now(),
                  initialDate: widget.doctor?.birthDate,
                ),
                SizedBox(height: size.height * 0.02),
                ImagePickerTile(key: _imagePickerFormKey),
                SizedBox(height: size.height * 0.02),
                _buildCategoryForm(_category!, _categoryFormKey, size),
                SizedBox(height: size.height * 0.02),
                Container(
                  child:
                      _buildReasonCategory(_category!, _categoryReasonFormKey),
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  key: _noteFormKey,
                  initialValue: widget.doctor?.note,
                  decoration: const InputDecoration(
                    labelText: 'Note (opzionale)',
                  ),
                  minLines: 3,
                  maxLines: 3,
                  maxLength: 300,
                  onChanged: (value) => {
                    setState(() {
                      _note = value.trim();
                    })
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => {
                      if (_emailFormKey.currentState!.validate() &&
                          _nameFormKey.currentState!.validate() &&
                          _surnameFormKey.currentState!.validate() &&
                          _telephoneFormKey.currentState!.validate())
                        {onSubmit()}
                    },
                    child: Text(
                      widget.doctor != null ? "AGGIORNA MEDICO" : "CREA NUOVO MEDICO ",
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

  Widget _buildReasonCategory(String category, GlobalKey key) {
    if (category == "Fascia B") {
      return TextFormField(
        key: key,
        decoration: const InputDecoration(
          labelText: 'Motivo categoria',
        ),
        minLines: 3,
        maxLines: 3,
        maxLength: 300,
        onChanged: (value) => {
          setState(() {
            _categoryReason = value.trim();
          })
        },
      );
    } else {
      return Container();
    }
  }

  Widget _buildCategoryForm(String category, GlobalKey key, Size size) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Categoria: ",
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  fontSize: 18.0,
                  color: CustomColors.violaScuro,
                ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.04,
          ),
          Container(
            width: size.width * 0.40,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: CustomColors.violaScuro, width: 0.5),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButton<String>(
              value: category,
              key: key,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: const TextStyle(color: CustomColors.violaScuro),
              underline: const SizedBox(),
              onChanged: (String? newValue) {
                setState(() {
                  _category = newValue;
                });
              },
              items: <String>['Fascia A', 'Fascia B']
                  .map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      );
}
