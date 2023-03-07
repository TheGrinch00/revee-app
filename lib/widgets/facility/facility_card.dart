import 'package:flutter/material.dart';
import 'package:revee/screens/hospital_create_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:revee/utils/theme.dart';
import 'package:revee/models/facility.dart';

class FacilityCard extends StatelessWidget {
  const FacilityCard({Key? key, required this.facility}) : super(key: key);

  final Facility facility;

  bool get hasPhoneNumber =>
      facility.phoneNumber != null &&
      (facility.phoneNumber?.isNotEmpty ?? false);

  bool get hasEmail =>
      facility.email != null && (facility.email?.isNotEmpty ?? false);

  bool get hasWebsite =>
      facility.website != null && (facility.website?.isNotEmpty ?? false);

  bool get hasAtLeastOneContact => hasPhoneNumber || hasEmail || hasWebsite;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final contactElementStyle = textTheme.bodyText1!.copyWith(
      decoration: TextDecoration.underline,
      color: CustomColors.revee,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );

    final infoTextStyle = textTheme.bodyText2!.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: const Color(0xFF727272),
    );

    return Card(
      elevation: 3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: hasAtLeastOneContact
                ? ExpansionTile(
                    title: Text(
                      facility.name,
                      style: textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.violaScuro,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            facility.facilityType.name,
                            style: infoTextStyle,
                          ),
                          Text(
                            facility.address,
                            style: infoTextStyle,
                          ),
                        ],
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 6.0,
                        ),
                        width: double.infinity,
                        child: Text(
                          'Contatti',
                          style: textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.violaScuro,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 6.0,
                              horizontal: 8.0,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (hasPhoneNumber)
                                ContactsBlock(
                                  icon: Icons.phone,
                                  contactInformation: facility.phoneNumber,
                                  style: contactElementStyle,
                                  url: "tel: ${facility.phoneNumber}",
                                ),
                              if (hasEmail)
                                ContactsBlock(
                                  icon: Icons.mail_outlined,
                                  contactInformation: facility.email,
                                  style: contactElementStyle,
                                  url: "mailto: ${facility.email}",
                                ),
                              if (hasWebsite)
                                ContactsBlock(
                                  icon: Icons.link,
                                  contactInformation: facility.website,
                                  style: contactElementStyle,
                                  url: facility.website!,
                                ),
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                : Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          facility.name,
                          style: textTheme.headline3!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.violaScuro,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                facility.facilityType.name,
                                style: infoTextStyle,
                              ),
                              Text(
                                facility.address,
                                style: infoTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          if(facility.isEditable)
            IconButton(
              onPressed: () async {
                if (facility.isEditable) {
                  await Navigator.of(context).pushNamed(
                    CreateNewFacilityScreen.routeName,
                    arguments: CreateNewFacilityArguments(facility),
                  );
                }
              },
              icon: const Icon(Icons.edit),
              color: CustomColors.revee,
            )
        ],
      ),
    );
  }
}

class ContactsBlock extends StatelessWidget {
  final IconData icon;
  final String? contactInformation;
  final TextStyle style;
  final String url;

  const ContactsBlock({
    required this.icon,
    required this.contactInformation,
    required this.style,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: CustomColors.revee,
            size: 14,
          ),
          const SizedBox(
            width: 6.0,
          ),
          GestureDetector(
            onTap: () async {
              final canLaunchUrl = await canLaunch(url);
              if (canLaunchUrl) {
                await launch(url);
              }
            },
            child: Text(
              contactInformation ?? "N/D",
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}
