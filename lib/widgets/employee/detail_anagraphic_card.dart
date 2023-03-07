import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/providers/doctor_provider.dart';
import 'package:revee/screens/doctor_create_screen.dart';
import 'package:revee/utils/theme.dart';
import 'package:revee/widgets/generic/light_box_shadow.dart';
import 'package:revee/widgets/generic/pulsating_badge.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:revee/models/doctor.dart';

class DetailAnagraphicCard extends StatelessWidget {
  const DetailAnagraphicCard({Key? key}) : super(key: key);

  String? encodeQueryParameters(Map<String, String>? params) {
    if (params == null) return null;

    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  Widget buildContactInfo({
    required String scheme,
    required String path,
    Map<String, String>? queryParams,
    required IconData icon,
    required String info,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () async {
        final url = Uri(
          scheme: scheme,
          path: path.replaceAll(" ", ""),
          query: encodeQueryParameters(queryParams),
        );

        if (await canLaunch(url.toString())) {
          launch(url.toString());
        } else {
          throw 'Could not launch ${url.toString()}';
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 10),
          Text(
            info,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarRadius = MediaQuery.of(context).size.width * 0.12;
    const String noteNotFound =
        "Non sono state registrate annotazioni per questo medico";

    return Consumer<DoctorProvider>(
      builder: (context, provider, child) {
        if (provider.detailDoctor == null) {
          Navigator.of(context).pop();
        }

        final doctor = provider.detailDoctor!;

        final bool hasAnnotations =
            doctor.note != null && (doctor.note?.isNotEmpty ?? false);
        final bool hasProfilePicture = doctor.photoURL != null &&
            (doctor.photoURL?.isNotEmpty ?? false) &&
            doctor.photoURL != "string";
        final bool hasPhoneNumber = doctor.phoneNumber != null &&
            (doctor.phoneNumber?.isNotEmpty ?? false);
        final bool hasEmail = doctor.email.isNotEmpty;

        return SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  SizedBox(height: avatarRadius),
                  LightBoxShadow(
                    child: Card(
                      margin: EdgeInsets.zero,
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                IconButton(
                                  onPressed: () async {
                                    if (doctor.isEditable) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CreateNewDoctorScreen(doctor: doctor),
                                        ),
                                      );
                                    }
                                  },
                                  icon: doctor.isEditable ? const Icon(Icons.edit) : Container(),
                                  color: CustomColors.revee,
                                ),

                                if (doctor.status != DoctorStatus.VISITED)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: PulsatingBadge(
                                      color: doctor.gravityColor,
                                    ),
                                  ),
                              ],
                            ),

                            SizedBox(
                              height: doctor.status != DoctorStatus.VISITED
                                  ? avatarRadius - 24
                                  : avatarRadius + 10,
                            ),
                            Text(
                              "${doctor.name} ${doctor.surname}".toLowerCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(
                                fontSize: 25.0,
                                color: CustomColors.violaScuro,
                                fontFeatures: const [
                                  FontFeature.enable('smcp'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            if (hasPhoneNumber)
                              buildContactInfo(
                                scheme: "tel",
                                path: doctor.phoneNumber!,
                                icon: Icons.phone,
                                info: doctor.phoneNumber!,
                                context: context,
                              ),
                            const SizedBox(height: 2.0),
                            if (hasEmail)
                              buildContactInfo(
                                scheme: "mailto",
                                path: doctor.email,
                                icon: Icons.email_outlined,
                                info: doctor.email,
                                context: context,
                              ),
                            const SizedBox(height: 16.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                hasAnnotations ? doctor.note! : noteNotFound,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 12.0,
                                      color: CustomColors.violaScuro
                                          .withOpacity(0.65),
                                    ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 2 * avatarRadius,
                height: 2 * avatarRadius,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0x20241D2D),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: Center(
                  child: hasProfilePicture
                      ? CircleAvatar(
                          radius: avatarRadius * 0.95,
                          backgroundImage: NetworkImage(doctor.photoURL!),
                        )
                      : CircleAvatar(
                          radius: avatarRadius * 0.95,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              const AssetImage("assets/icons/doctor-icon.png"),
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
