import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/models/models_user_management.dart';
import '../../../../core/provider/provider_user.dart';
import '../../../../core/provider/provider_user_management.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userProvider =
      Provider.of<UserProvider>(context, listen: false);

      final userManagement =
      Provider.of<UserManagementProvider>(context, listen: false);


    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserManagementProvider>(context);

    final filteredUsers = provider.users.where((u) {
      return u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.email.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("User Management"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => provider.fetchUsers(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: Column(
        children: [
          // 🔍 SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cari user...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // 📊 INFO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _infoCard("Total", provider.users.length, Colors.blue),
                const SizedBox(width: 10),
                _infoCard("Admin", provider.adminUsers.length, Colors.red),
                const SizedBox(width: 10),
                _infoCard("User", provider.normalUsers.length, Colors.green),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 📋 LIST
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                ? Center(child: Text(provider.error!))
                : filteredUsers.isEmpty
                ? const Center(child: Text("Data tidak ditemukan"))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      return _userCard(filteredUsers[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 🔹 CARD USER
  Widget _userCard(UserManagementModel user) {
    final isAdmin = user.role == 'admin';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        leading: CircleAvatar(
          radius: 24,
          backgroundColor: isAdmin ? Colors.red : Colors.blue,
          child: Text(
            user.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),

        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Text(user.email),

        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Chip(
              label: Text(
                isAdmin ? "Admin" : "User",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: isAdmin ? Colors.red : Colors.green,
            ),
          ],
        ),

        onTap: () => _showDetail(user),
      ),
    );
  }

  // 🔹 DETAIL BOTTOM SHEET
  void _showDetail(UserManagementModel user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final isAdmin = user.role == 'admin';

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: isAdmin ? Colors.red : Colors.blue,
                child: Text(
                  user.name[0].toUpperCase(),
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Chip(
                label: Text(
                  isAdmin ? "Administrator" : "User",
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: isAdmin ? Colors.red : Colors.green,
              ),

              const SizedBox(height: 20),

              _detailItem(Icons.email, "Email", user.email),
              _detailItem(
                Icons.calendar_today,
                "Created",
                user.createdAt ?? "-",
              ),
              _detailItem(Icons.update, "Updated", user.updatedAt ?? "-"),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tutup"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 🔹 DETAIL ITEM
  Widget _detailItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Text("$title : "),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // 🔹 INFO CARD
  Widget _infoCard(String title, int value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              "$value",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
