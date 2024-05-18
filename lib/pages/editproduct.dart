import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../services/product.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProductScreen extends StatefulWidget {
  final Product product;

  EditProductScreen({required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _productNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _typeController;
  File? _image; // Variable to store the selected image

  @override
  void initState() {
    super.initState();
    _productNameController =
        TextEditingController(text: widget.product.productName);
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _typeController = TextEditingController(text: widget.product.type);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
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
                    controller: _productNameController,
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
                    controller: _descriptionController,
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
                    controller: _priceController,
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
                    controller: _typeController,
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
                      ? Image.file(
                          _image!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : widget.product.image != null
                          ? Image.network(
                              widget.product.image!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : SizedBox(), // Show previous image if available
                  const SizedBox(height: 20),
                  _image != null
                      ? ElevatedButton(
                          onPressed: _removeImage,
                          child: const Text('Remove Image'),
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
                          String? imageUrl;
                          if (_image != null) {
                            imageUrl = await _uploadImageToFirebase(_image!);
                          }
                          Product updatedProduct = Product(
                            id: widget.product.id,
                            sellerId: widget.product.sellerId,
                            productName: _productNameController.text,
                            description: _descriptionController.text,
                            price: double.parse(_priceController.text),
                            type: _typeController.text,
                            image: imageUrl ?? widget.product.image,
                          );
                          await ProductService.updateProduct(
                              context, updatedProduct);
                          Navigator.pop(context, updatedProduct);
                        } catch (error) {
                          print('Failed to update product: $error');
                        }
                      }
                    },
                    child: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          const Color.fromARGB(255, 56, 169, 194),
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

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _typeController.dispose();
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

  Future<void> _removeImage() async {
    setState(() {
      _image = null;
    });
  }

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      final firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('products/${DateTime.now().millisecondsSinceEpoch}');

      await storageRef.putFile(imageFile);

      final String downloadURL = await storageRef.getDownloadURL();
      print(downloadURL);

      return downloadURL;
    } catch (error) {
      print('Failed to upload image to Firebase Storage: $error');
      return null;
    }
  }
}
