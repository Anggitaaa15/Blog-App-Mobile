import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/theme/appColors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../widgets/mobileStatusBar.dart';

class EditArtikelPage extends StatefulWidget {
  final Map post;

  const EditArtikelPage({
    super.key,
    required this.post,
  });

  @override
  State<EditArtikelPage> createState() => _EditArtikelPageState();
}

class _EditArtikelPageState extends State<EditArtikelPage> {
  XFile? image;

  List categories = [];
  int? selectedCategory;
  String selectedStatus = "Published";

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

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

  Future<void> updatePost(String status) async {
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
      "PATCH",
      Uri.parse(
        "http://localhost:3000/api/v1/posts/${widget.post['id']}",
      ),
    );

    request.fields["categoryId"] = selectedCategory.toString();
    request.fields["title"] = titleController.text.trim();
    request.fields["content"] = contentController.text.trim();
    request.fields["status"] = status;

    if (image != null) {
      String extension = image!.name.split('.').last.toLowerCase();

      String subtype;

      if (extension == "png") {
        subtype = "png";
      } else if (extension == "jpg" || extension == "jpeg") {
        subtype = "jpeg";
      } else {
        subtype = "jpeg";
      }

      final bytes = await image!.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          "image",
          bytes,
          filename: image!.name,
          contentType: MediaType("image", subtype),
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      print("Artikel berhasil diperbarui");

      if (mounted) {
        Navigator.pop(context, true);
      }
    } else {
      final responseBody = await response.stream.bytesToString();

      print("Artikel gagal diperbarui");
      print(responseBody);
    }
  }

  @override
  void initState() {
    super.initState();

    titleController.text = widget.post['title'] ?? "";
    contentController.text = widget.post['content'] ?? "";

    selectedCategory = widget.post['categoryId'];
    selectedStatus = widget.post['status'] ?? "Published";

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
    return Column(
      children: [
        MobileStatusBar(),

        Expanded(
          child: Scaffold(
            backgroundColor: Colors.white,

            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
              title: const Text("Edit Artikel"),
            ),

            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Foto",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(),
                      ),
                      child: image != null
                          ? Image.network(
                              image!.path,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : widget.post['imageUrl'] != null
                              ? Image.network(
                                  widget.post['imageUrl'],
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : const Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 10),
                                    Text("+ Tambahkan Foto"),
                                  ],
                                ),
                    ),
                  ),

                  const SizedBox(height: 20),

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
                            updatePost("Draft");
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                              color: AppColors.navy,
                            ),
                          ),
                          child: const Text(
                            "Draft",
                            style: TextStyle(
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            updatePost("Published");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.navy,
                          ),
                          child: const Text(
                            "Published",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}