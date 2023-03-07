import 'package:flutter/material.dart';
import 'package:revee/screens/products_accordion_screen.dart';

import 'package:revee/screens/profile_screen.dart';
import 'package:revee/screens/doctors_screen.dart';
import 'package:revee/screens/expiring_doctors_screen.dart';
import 'package:revee/screens/hospitals_screen.dart';
import 'package:revee/screens/visits_screen.dart';

import 'package:revee/widgets/drawer/app_drawer_header.dart';
import 'package:revee/widgets/drawer/drawer_list_tile.dart';

class DrawerElementType {
  final Icon icon;
  final String name;
  final String route;

  const DrawerElementType({
    required this.icon,
    required this.name,
    required this.route,
  });
}

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  AppDrawer({required this.currentRoute});

  final elements = List<DrawerElementType>.unmodifiable([
    const DrawerElementType(
      icon: Icon(Icons.timer_outlined),
      name: "Da visitare",
      route: ExpiringDoctorsScreen.routeName,
    ),
    const DrawerElementType(
      icon: Icon(Icons.masks_outlined),
      name: "Medici",
      route: DoctorsScreen.routeName,
    ),
    const DrawerElementType(
      icon: Icon(Icons.apartment_rounded),
      name: "Strutture",
      route: HospitalsScreen.routeName,
    ),
    const DrawerElementType(
      icon: Icon(Icons.pending_actions_rounded),
      name: "Visite",
      route: VisitsScreen.routeName,
    ),
    const DrawerElementType(
      icon: Icon(Icons.sell_outlined),
      name: "Catalogo",
      route: ProductsAccordionPage.routeName,
    ),
    const DrawerElementType(
      icon: Icon(Icons.account_circle_outlined),
      name: "Profilo",
      route: ProfileScreen.routeName,
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/images/drawer-header-background.jpeg",
          ),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
        color: Colors.white,
      ),
      child: SafeArea(
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.transparent,
          ),
          child: Drawer(
            child: Column(
              children: [
                AppDrawerHeader(),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        ...elements
                            .map(
                              (elm) => DrawerListTile(
                                icon: elm.icon,
                                pageName: elm.name,
                                routeName: elm.route,
                                isSelected: elm.route == currentRoute,
                              ),
                            )
                            .toList(),
                      ],
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
}
