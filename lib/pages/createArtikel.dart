import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/theme/appColors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../widgets/navigation.dart';

class BuatPage extends StatefulWidget {
  const BuatPage({super.key});

  @override
  State<BuatPage> createState() => _BuatPageState();
}

class _BuatPageState extends State<BuatPage> {
  XFile? image;

  List categories = [];
  int? selectedCategory;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  Future<void> getCategories() async {
    final response = await http.get(
      Uri.parse("http://localhost:3000/api/v1/categories"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        categories = data['data'];
      });
    } else {
      print("Kategori gagal diambil");
    }
  }

  Future<void> createPost(String status) async {
    if (titleController.text.trim().isEmpty) {
      print("Judul wajib diisi");
      return;
    }

    if (selectedCategory == null) {
      print("Kategori wajib dipilih");
      return;
    }

    if (contentController.text.trim().isEmpty) {
      print("Isi artikel wajib diisi");
      return;
    }

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("http://localhost:3000/api/v1/posts"),
    );

    request.fields["userId"] = "1";
    request.fields["categoryId"] = selectedCategory.toString();
    request.fields["title"] = titleController.text.trim();
    request.fields["content"] = contentController.text.trim();
    request.fields["status"] = status;

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath("image", image!.path),
      );
    }

    final response = await request.send();

    if (response.statusCode == 201) {
      print("Artikel berhasil dibuat");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              status == "Draft"
                  ? "Artikel disimpan sebagai Draft"
                  : "Artikel berhasil Published",
            ),
          ),
        );
      }
    } else {
      final responseBody = await response.stream.bytesToString();

      print("Artikel gagal dibuat");
      print(responseBody);
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
        title: const Text("Buat Artikel"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO
            const Text("Foto", style: TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: image == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text("+ Tambahkan Foto"),
                        ],
                      )
                    : Image.network(
                        image!.path,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // JUDUL
            const Text(
              "Judul",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Masukkan Judul...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // KATEGORI
            const Text(
              "Kategori",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<int>(
              value: selectedCategory,
              decoration: InputDecoration(
                hintText: "Pilih Kategori",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              items: categories.map<DropdownMenuItem<int>>((category) {
                return DropdownMenuItem<int>(
                  value: category['id'],
                  child: Text(category['name']),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Isi Artikel",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: contentController,
              maxLines: 15,
              decoration: InputDecoration(
                hintText: "Isi Artikel kamu di sini...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      createPost("Draft");
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: AppColors.navy),
                    ),
                    child: const Text(
                      "Draft",
                      style: TextStyle(color: AppColors.navy),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      createPost("Published");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy,
                    ),
                    child: const Text(
                      "Published",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(currentIndex: 2,),
    );
  }
}
