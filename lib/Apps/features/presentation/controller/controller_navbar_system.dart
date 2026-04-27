import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amicons/amicons.dart';

// Import Providers
import '../../../core/provider/provider_user.dart';

// Import Pages
import '../pages/user/user_dashbord.dart';
import '../pages/user/fiture/fiture_product_list.dart';
import '../pages/user/fiture/fiture_history.dart';
import '../pages/user/fiture/fiture_profil.dart';
import '../pages/admin/admin_dashbord.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final isAdmin = userProvider.userRole == 'admin';

    final userNavbarConfig = RoleNavbarConfig(
      pages: const [
        DashboardView(),
        ProdukListScreen(),
        UserRiwayatPage(),
        ProfileScreen(),
      ],
      navItems: userNavItems,
    );

    final adminNavbarConfig = RoleNavbarConfig(
      pages: const [
        AdminDashboardScreen(),
        ProdukListScreen(),
        ProfileScreen(),
      ],
      navItems: adminNavItems,
    );

    final RoleNavbarConfig config = isAdmin ? adminNavbarConfig : userNavbarConfig;

    if (config.pages.isEmpty ||
        config.navItems.isEmpty ||
        config.pages.length != config.navItems.length) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_currentIndex >= config.pages.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: config.pages),
      bottomNavigationBar: BottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: config.navItems,
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavItem> items;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      items: List.generate(items.length, (index) {
        final item = items[index];
        return BottomNavigationBarItem(
          icon: Icon(item.lightIcon),
          activeIcon: Icon(item.boldIcon),
          label: item.label,
        );
      }),
    );
  }
}

// Configuration classes
class RoleNavbarConfig {
  final List<Widget> pages;
  final List<NavItem> navItems;

  RoleNavbarConfig({required this.pages, required this.navItems});
}

class NavItem {
  final String label;
  final IconData lightIcon;
  final IconData boldIcon;

  NavItem({required this.label, required this.lightIcon, required this.boldIcon});
}

// Navigation items definition
final List<NavItem> userNavItems = [
  NavItem(
    lightIcon: Amicons.iconly_home,
    boldIcon: Amicons.iconly_home_fill,
    label: "Home",
  ),
  NavItem(
    lightIcon: Amicons.vuesax_money,
    boldIcon: Amicons.vuesax_money_fill,
    label: "Product",
  ),
  NavItem(
    lightIcon: Amicons.iconly_notification_2_sharp,
    boldIcon: Amicons.iconly_notification_2_sharp_fill,
    label: "History",
  ),
  NavItem(
    lightIcon: Amicons.iconly_profile_sharp,
    boldIcon: Amicons.iconly_profile_sharp_fill,
    label: "Profile",
  ),
];

final List<NavItem> adminNavItems = [
  NavItem(
    lightIcon: Amicons.iconly_home,
    boldIcon: Amicons.iconly_home_fill,
    label: "Dashboard",
  ),
  NavItem(
    lightIcon: Amicons.vuesax_money,
    boldIcon: Amicons.vuesax_money_fill,
    label: "Product",
  ),
  NavItem(
    lightIcon: Amicons.iconly_profile_sharp,
    boldIcon: Amicons.iconly_profile_sharp_fill,
    label: "Profile",
  ),
];
