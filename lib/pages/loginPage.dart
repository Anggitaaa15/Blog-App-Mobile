import 'package:flutter/material.dart';
import 'package:frontend/pages/registerPage.dart';
import 'package:frontend/theme/appColors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

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
                  "Selamat Datang",
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 24, 
                    fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(
                width: 350,
                child: Text(
                  "Masuk untuk melanjutkan perjalanan membaca dan berbagi cerita.",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),

              SizedBox(height: 30),

              SizedBox(
                width: 350,
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Nama Pengguna",
                    hintText: "Masukkan username",
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
                        togglepass ? Icons.visibility_off : Icons.visibility,
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

              SizedBox(height: 8),

              SizedBox( 
                width: 350,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Lupa Kata Sandi?",
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 12
                    ),
                  ),
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
                    "Masuk",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    "Tidak mempunyai akun?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    child: Text("Daftar"),
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
