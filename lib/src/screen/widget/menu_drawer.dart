import 'package:flutter/material.dart';

import '../settings_screen.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  Widget _createHeader(BuildContext context) {
    return const SizedBox(
      height: 100.0,
      child: DrawerHeader(
        padding: EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Stepy',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _createDrawerItem({
    IconData? icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return ListTile(
      visualDensity: const VisualDensity(
        horizontal: VisualDensity.minimumDensity,
      ),
      leading: icon != null ? Icon(icon) : null,
      title: Text(text),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          _createHeader(context),
          _createDrawerItem(
            icon: Icons.home,
            text: 'Daily Activity',
          ),
          _createDrawerItem(
            icon: Icons.calendar_month,
            text: 'Past Activities',
          ),
          _createDrawerItem(
            icon: Icons.emoji_events,
            text: 'Personal Records',
          ),
          const Divider(thickness: 1.0),
          _createDrawerItem(
            icon: Icons.settings,
            text: 'Settings',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              ),
            ),
          ),
          // TODO: Create an about page with description and licenses
          _createDrawerItem(
            icon: Icons.info,
            text: 'About',
            onTap: () {},
          ),
          // TODO: Get version code
          _createDrawerItem(text: 'v1.0.0'),
        ],
      ),
    );
  }
}
