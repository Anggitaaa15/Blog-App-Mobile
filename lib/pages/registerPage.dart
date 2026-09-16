import 'package:flutter/material.dart';
import 'package:frontend/theme/appColors.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final numberContoller = TextEditingController();

  bool togglepass = true;
  bool rememberMe = false;
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),

              Image.asset(
                "assets/images/logo.png",
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),

              SizedBox(height: 50),

              SizedBox(
                width: 350,
                child: Text(
                  "Buat akun",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(
                width: 350,
                child: Text(
                  "Daftar untuk mulai menjelajahi artikel menarik.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ),

              SizedBox(height: 30),

              SizedBox(
                width: 350,
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Nama Pengguna",
                    hintText: "Masukkan Nama Pengguna",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),

              SizedBox(height: 10),

              SizedBox(
                width: 350,
                child: TextField(
                  controller: numberContoller,
                  decoration: InputDecoration(
                    labelText: "Nomor Telepon",
                    hintText: "+62 123 4567 8901",
                    prefixIcon: Icon(Icons.call),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),

              SizedBox(height: 10),

              SizedBox(
                width: 350,
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Kata Sandi",
                    hintText: "Masukkan Kata Sandi",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          togglepass = !togglepass;
                        });
                      },
                      icon: Icon(
                        togglepass
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: togglepass,
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),

              SizedBox(height: 10),

              SizedBox(
                width: 350,
                child: ElevatedButton(
                  onPressed: () {
                    String username = usernameController.text;

                    Navigator.pushReplacementNamed(
                      context,
                      "/beranda",
                      arguments: username,
                    );
                  },
                  child: Text(
                    "Daftar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah punya akun?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        "/login",
                      );
                    },
                    child: Text("Masuk"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}