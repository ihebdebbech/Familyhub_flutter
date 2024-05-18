import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../services/product.dart';
import 'mainskeleton.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  File? _image; // Variable to store the selected image

  @override
  void dispose() {
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    typeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      // Get reference to the Firebase Storage bucket
      final firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('products/${DateTime.now().millisecondsSinceEpoch}');

      // Upload the file to Firebase Storage
      await storageRef.putFile(imageFile);

      // Get the download URL for the image
      final String downloadURL = await storageRef.getDownloadURL();
      print(downloadURL);

      return downloadURL;
    } catch (error) {
      print('Failed to upload image to Firebase Storage: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'), // Title for the form
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: productNameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Product Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Description is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Price is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: typeController,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Type is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _image != null
                      ? Column(
                          children: [
                            Image.file(
                              _image!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: _removeImage,
                                  child: const Text('Remove Image'),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: _pickImage,
                                  child: const Text('Change Image'),
                                ),
                              ],
                            ),
                          ],
                        )
                      : ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text('Select Image'),
                        ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String userId = prefs.getString('userId') ??
                              ''; // Retrieve userId from SharedPreferences
                          print('User ID: $userId');

                          // Upload image to Firebase Storage
                          final imageUrl = _image != null
                              ? await _uploadImageToFirebase(_image!)
                              : null;

                          // Create product object from form data
                          final Product product = Product(
                            id: "",
                            productName: productNameController.text,
                            description: descriptionController.text,
                            price: double.parse(priceController.text),
                            type: typeController.text,
                            sellerId: userId,
                            image: imageUrl, // Assign Firebase image URL
                          );

                          // Add product using ProductService
                          final addedProduct =
                              await ProductService.addProduct(context, product);

                          // Handle success
                          print('Product added successfully: $addedProduct');

                          // Show success dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Success'),
                                content:
                                    const Text('Product added successfully.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Mainskeleton(
                                            selectedIndex: 5,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (error) {
                          // Handle error
                          print('Failed to add product: $error');
                        }
                      }
                    },
                    child: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 56, 169, 194),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _removeImage() async {
    setState(() {
      _image = null;
    });
  }
}
