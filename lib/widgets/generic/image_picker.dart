import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revee/utils/theme.dart';

class ImagePickerTile extends StatefulWidget {
  const ImagePickerTile({required Key key}) : super(key: key);

  @override
  ImagePickerTileState createState() => ImagePickerTileState();
}

class ImagePickerTileState extends State<ImagePickerTile> {
  File? selected;

  @override
  Widget build(BuildContext context) {
    Future<void> choseImage(ImageSource source) async {
      final XFile? image =
          await ImagePicker().pickImage(source: source, imageQuality: 40);

      final File file = File(image!.path);
      selected = file;
    }

    if (!mounted) return const SizedBox();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Carica immagine\n(opzionale) ",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4!.copyWith(
                fontSize: 15.0,
                color: CustomColors.violaScuro,
              ),
        ),
        MaterialButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: const <Widget>[
              Icon(
                Icons.camera_alt,
                color: CustomColors.revee,
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Camera',
                  style: TextStyle(color: CustomColors.neroRevee),
                ),
              ),
            ],
          ),
          onPressed: () async {
            // ignore: unnecessary_await_in_return
            return await choseImage(ImageSource.camera);
          },
        ),
        MaterialButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: const <Widget>[
              Icon(
                Icons.collections,
                color: CustomColors.revee,
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Galleria',
                  style: TextStyle(color: CustomColors.neroRevee),
                ),
              ),
            ],
          ),
          onPressed: () async {
            // ignore: unnecessary_await_in_return
            return choseImage(ImageSource.gallery);
          },
        ),
        if (selected == null)
          Container()
        else
          Card(
            child: Image.file(
              selected ?? File("assets/icons/doctor-icon.png"),
              height: 60,
            ),
          ),
      ],
    );
  }
}
