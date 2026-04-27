import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Apps/core/provider/provider_user.dart';
import 'Apps/core/provider/provider_product.dart';
import 'Apps/core/provider/provider_cart_item.dart';
import 'Apps/core/provider/provider_user_management.dart';
import 'Apps/features/presentation/pages/splace.dart';
import 'Apps/features/presentation/pages/auth/loginview.dart';
import 'Apps/features/presentation/pages/auth/register_view.dart';
import 'Apps/features/presentation/pages/user/user_dashbord.dart';
import 'Apps/features/presentation/pages/user/fiture/fiture_product_list.dart';
import 'Apps/features/presentation/pages/user/fiture/fiture_history.dart';
import 'Apps/features/presentation/pages/user/fiture/fiture_profil.dart';
import 'Apps/features/presentation/pages/admin/admin_dashbord.dart';
import 'Apps/features/presentation/controller/controller_navbar_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider()..loadUserFromStorage(),
        ),
        ChangeNotifierProvider(create: (_) => TokoProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserManagementProvider()),

      ],
      child: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return MaterialApp(
            title: 'Tumbas App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
            initialRoute: '/',
            routes: {
              '/': (_) => const SpaleceLoginRegister(),
              '/login': (_) => const LoginView(),
              '/register': (_) => const Registerview(),
              '/dashboard': (_) =>
                  userProvider.isLoggedIn ? const Navbar() : const LoginView(),
              '/home_user': (_) => userProvider.isLoggedIn
                  ? const DashboardView()
                  : const LoginView(),
              '/products': (_) => userProvider.isLoggedIn
                  ? const ProdukListScreen()
                  : const LoginView(),
              '/transactions': (_) => userProvider.isLoggedIn
                  ? const UserRiwayatPage()
                  : const LoginView(),
              '/profile': (_) => userProvider.isLoggedIn
                  ? const ProfileScreen()
                  : const LoginView(),
              '/admin': (_) => userProvider.isLoggedIn
                  ? const AdminDashboardScreen()
                  : const LoginView(),
            },
          );
        },
      ),
    );
  }
}
