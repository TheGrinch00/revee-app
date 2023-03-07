import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:revee/models/user.dart';
import 'package:revee/providers/auth_provider.dart';

import 'package:revee/utils/theme.dart';

import 'package:revee/screens/statistics_screen.dart';

import 'package:revee/widgets/generic/animated_slide_opacity.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = "/profile";
  String get changePasswordTag => "change-password";

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthProvider>(context, listen: false).user;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CustomColors.violaScuro,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        foregroundColor: Colors.white,
        backgroundColor: CustomColors.violaScuro,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.02,
            horizontal: size.width * 0.1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSlideOpacity(
                milllisDuration: 800,
                child: _buildFirstSection(context, size, userData!),
              ),
              SizedBox(height: size.height * 0.04),
              AnimatedSlideOpacity(
                millisDelay: 100,
                milllisDuration: 800,
                child: _buildNameSection(context, size, userData),
              ),
              SizedBox(height: size.height * 0.04),
              AnimatedSlideOpacity(
                millisDelay: 200,
                milllisDuration: 800,
                child: _buildActionTile(
                  color: const Color(0xFFFF4DC4),
                  icon: Icons.insights_outlined,
                  title: "Statistiche",
                  deviceSizes: size,
                  onPressed: () => Navigator.of(context)
                      .pushNamed(StatisticsScreen.routeName),
                ),
              ),
              /*SizedBox(height: size.height * 0.02),
              AnimatedSlideOpacity(
                millisDelay: 250,
                milllisDuration: 800,
                child: Hero(
                  createRectTween: (begin, end) => CustomRectTween(
                    begin: begin!,
                    end: end!,
                  ),
                  tag: changePasswordTag,
                  child: Material(
                    color: Colors.transparent,
                    child: _buildActionTile(
                      color: const Color(0xFFFF80D5),
                      icon: Icons.vpn_key_outlined,
                      title: "Cambia password",
                      deviceSizes: size,
                      onPressed: () {
                        Navigator.of(context).push(
                          HeroDialogRoute(
                            builder: (BuildContext context) =>
                                ChangePasswordContainer(
                              heroTag: changePasswordTag,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              AnimatedSlideOpacity(
                millisDelay: 300,
                milllisDuration: 800,
                child: Hero(
                  tag: "settings",
                  child: _buildActionTile(
                    color: const Color(0xFFFFB3E6),
                    icon: Icons.settings,
                    title: "Impostazioni",
                    deviceSizes: size,
                    onPressed: () {
                    },
                  ),
                ),
              ),*/
              Expanded(child: Container()),
              AnimatedSlideOpacity(
                millisDelay: 500,
                milllisDuration: 800,
                child: _buildLogoutButton(context, size),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameSection(
    BuildContext context,
    Size size,
    ReveeUser userData,
  ) {
    final double fontSize = math.min(size.width * 0.1, 50);

    final List<Widget> name = List.unmodifiable([
      Text(
        userData.name,
        style: Theme.of(context).textTheme.headline2!.copyWith(
              color: Colors.white,
              fontSize: fontSize,
            ),
      ),
      const SizedBox(width: 10),
      Text(
        userData.surname,
        style: Theme.of(context).textTheme.headline2!.copyWith(
              color: Colors.white.withOpacity(0.5),
              fontSize: fontSize,
              fontWeight: FontWeight.w100,
            ),
      ),
    ]);

    if (size.height < 600) {
      return Row(
        children: name,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: name,
      );
    }
  }

  Widget _buildFirstSection(
    BuildContext context,
    Size size,
    ReveeUser userData,
  ) =>
      IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: math.min(size.width * 0.13, 50.0),
              backgroundColor: Colors.white,
              child: Text(
                "${userData.name.substring(0, 1)}${userData.surname.substring(0, 1)}",
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: CustomColors.violaScuro,
                      fontSize: math.min(size.width * 0.1, 50),
                    ),
              ),
            ),
            Expanded(child: Container()),
            const VerticalDivider(
              indent: 10,
              endIndent: 10,
              color: Colors.white,
            ),
            SizedBox(width: size.width * 0.05),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Creato",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                const Text(
                  "3 mesi fa",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildActionTile({
    required Color color,
    required IconData icon,
    required String title,
    required Size deviceSizes,
    required VoidCallback onPressed,
  }) {
    final circleRadius = math.min(deviceSizes.width * 0.05, 20.0);
    const boxRadius = 15.0;
    final iconSize = math.min(deviceSizes.width * 0.04, 15.0);

    return InkWell(
      borderRadius: BorderRadius.only(
        topRight: const Radius.circular(boxRadius),
        bottomRight: const Radius.circular(boxRadius),
        topLeft: Radius.circular(circleRadius),
        bottomLeft: Radius.circular(circleRadius),
      ),
      splashColor: Colors.white.withOpacity(0.1),
      onTap: onPressed,
      child: Row(
        children: [
          CircleAvatar(
            radius: circleRadius,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(
              icon,
              size: iconSize,
              color: color,
            ),
          ),
          SizedBox(width: math.min(deviceSizes.width * 0.05, 20)),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: math.min(deviceSizes.width * 0.05, 20),
            ),
          ),
          Expanded(child: Container()),
          Container(
            height: 2 * circleRadius,
            width: 2 * circleRadius,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(boxRadius),
            ),
            child: Icon(
              Icons.arrow_forward_ios_outlined,
              size: circleRadius * 0.75,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, Size deviceSizes) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    const boxRadius = 15.0;

    return InkWell(
      onTap: () {
        authProvider.logout().then(
              (_) => Navigator.of(context).pushNamedAndRemoveUntil(
                '/',
                (Route<dynamic> route) => false,
              ),
            );
      },
      borderRadius: BorderRadius.circular(boxRadius),
      splashColor: Colors.white.withOpacity(0.1),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: math.min(15, deviceSizes.width * 0.05),
          horizontal: math.min(20, deviceSizes.width * 0.05),
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(boxRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.logout,
              color: Colors.red,
              size: math.min(24, deviceSizes.width * 0.05),
            ),
            SizedBox(width: math.min(deviceSizes.width * 0.05, 20)),
            Text(
              "Esci",
              style: TextStyle(
                color: Colors.white,
                fontSize: math.min(deviceSizes.width * 0.05, 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
