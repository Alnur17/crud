import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final TextEditingController _productNameTEController =
      TextEditingController();
  final TextEditingController _productCodeTEController =
      TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();

  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  bool inProgress = false;

  void addProduct() async {
    inProgress = true;
    if (mounted) {
      setState(() {});
    }
    Response response = await post(
      Uri.parse('https://crud.teamrabbil.com/api/v1/CreateProduct'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          "Img": _imageTEController.text.trim(),
          "ProductCode": _productCodeTEController.text.trim(),
          "ProductName": _productNameTEController.text.trim(),
          "Qty": _quantityTEController.text.trim(),
          "TotalPrice": _totalPriceTEController.text.trim(),
          "UnitPrice": _unitPriceTEController.text.trim(),
        },
      ),
    );

    inProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.statusCode == 200) {
      final decodeBody = jsonDecode(response.body);
      if (decodeBody['status'] == 'success') {
        if (mounted) {
          _productNameTEController.clear();
          _productCodeTEController.clear();
          _quantityTEController.clear();
          _totalPriceTEController.clear();
          _unitPriceTEController.clear();
          _imageTEController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product added successfully')));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fail to add product. Try again!')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formState,
            child: Column(
              children: [
                TextFormField(
                  controller: _productNameTEController,
                  decoration: const InputDecoration(
                    hintText: 'Product Name',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter your product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _productCodeTEController,
                  decoration: const InputDecoration(
                    hintText: 'Product Code',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter your product Code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _quantityTEController,
                  decoration: const InputDecoration(
                    hintText: 'Quantity',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter your quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _totalPriceTEController,
                  decoration: const InputDecoration(
                    hintText: 'Total Price',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter your total price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _unitPriceTEController,
                  decoration: const InputDecoration(
                    hintText: 'Unit Price',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter your unit price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _imageTEController,
                  decoration: const InputDecoration(
                    hintText: 'Image',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter your product image';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: inProgress ? const Center(child: CircularProgressIndicator()) : ElevatedButton(
                    onPressed: () {
                      if (_formState.currentState!.validate()) {
                        addProduct();
                      }
                    },
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: Colors.blue,
                    //   foregroundColor: Colors.white,
                    // ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
