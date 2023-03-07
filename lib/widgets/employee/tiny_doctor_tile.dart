import 'package:flutter/material.dart';
import 'package:revee/models/doctor.dart';

class TinyDoctorTile extends StatelessWidget {
  const TinyDoctorTile({Key? key, required this.doctor}) : super(key: key);

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
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
                  child: (doctor.photoURL == null || doctor.photoURL == "")
                      ? Image.asset("assets/icons/doctor-icon.png")
                      : Image.network(
                          doctor.photoURL!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Column(
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
          ],
        ),
      ),
    );
  }
}
