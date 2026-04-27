import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/widget/alerts/alert_message.dart';
import '../../../../core/service/service_user.dart';

class Registerview extends StatefulWidget {
  const Registerview({super.key});

  @override
  State<Registerview> createState() => _RegisterviewState();
}

class _RegisterviewState extends State<Registerview> {
  ServiceUser userService = ServiceUser();
  final formKey = GlobalKey<FormState>();
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool showPass = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: const Text(
                          "Daftar Akun",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: Text(
                          "Buat akun baru untuk mulai belanja",
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          // Name Field
                          FadeInUp(
                            duration: const Duration(milliseconds: 1200),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Nama Lengkap",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    hintText: "Enter your full name",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.grey.shade400),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.grey.shade400),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                  ),
                                  validator: (value) => (value == null || value.isEmpty) ? "Nama wajib diisi" : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Email Field
                          FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Email",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: "Enter your email",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.grey.shade400),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.grey.shade400),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                  ),
                                  validator: (value) => (value == null || !value.contains('@')) ? "Email tidak valid" : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Password Field
                          FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Password",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: showPass,
                                  decoration: InputDecoration(
                                    hintText: "Enter your password",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.grey.shade400),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.grey.shade400),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showPass = !showPass;
                                        });
                                      },
                                      icon: Icon(showPass ? Icons.visibility_off : Icons.visibility),
                                    ),
                                  ),
                                  validator: (value) => (value == null || value.length < 6) ? "Password minimal 6 karakter" : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1500),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: const EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.black),
                        ),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: isLoading ? null : () async {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                var data = {
                                  "name": nameController.text.trim(),
                                  "email": emailController.text.trim(),
                                  "password": passwordController.text,
                                };
                                var result = await userService.registerUser(data);
                                setState(() {
                                  isLoading = false;
                                });
                                // ignore: unnecessary_null_comparison
                                if (result != null && result.status == true) {
                                  if (mounted) {
                                    AlertMassage().showAlert(context, result.message, true);
                                    Future.delayed(const Duration(seconds: 1), () {
                                      if (mounted) Navigator.pushReplacementNamed(context, '/login');
                                    });
                                  }
                                } else {
                                  if (mounted) {
                                    AlertMassage().showAlert(context, result.message, false);
                                  }
                                }
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                                if (mounted) {
                                  AlertMassage().showAlert(context, "Terjadi kesalahan: $e", false);
                                }
                              }
                            }
                          },
                          color: Colors.yellowAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "Daftar Sekarang",
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                                ),
                        ),
                      ),
                    ),
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1600),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Sudah punya akun?", style: TextStyle(fontSize: 15)),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            "Masuk",
                            style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1200),
                child: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/img/background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
