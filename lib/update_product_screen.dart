import 'dart:convert';

import 'package:crud/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateProductScreen extends StatefulWidget {
  final Product product;
  const UpdateProductScreen({super.key, required this.product});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
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


  @override
  void initState() {
    _productNameTEController.text = widget.product.productName;
    _productCodeTEController.text = widget.product.productCode;
    _quantityTEController.text = widget.product.quantity;
    _totalPriceTEController.text = widget.product.totalPrice;
    _unitPriceTEController.text = widget.product.unitPrice;
    _imageTEController.text = widget.product.image;
    super.initState();
  }


  void updateProduct() async {
    inProgress = true;
    if (mounted) {
      setState(() {});
    }
    Response response = await post(
      Uri.parse('https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}'),
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
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product update successfully')));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fail to update product. Try again!')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
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
                        updateProduct();
                      }
                    },
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: Colors.blue,
                    //   foregroundColor: Colors.white,
                    // ),
                    child: const Text('Update'),
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
