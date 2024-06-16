import 'dart:convert';

import 'package:crud/product.dart';
import 'package:flutter/material.dart';

import 'add_new_product_screen.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> products = [];
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  void getProduct() async {
    inProgress = true;
    setState(() {});
    Response response =
        await get(Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct'));
    //print(response.statusCode);
    //print(response.body);
    final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200 && decodedResponse['status'] == 'success') {
      products.clear();
      for (var e in decodedResponse['data']) {
        products.add(Product.toJson(e));
      }
    }
    inProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD'),
        actions: [
          IconButton(
            onPressed: () {
              getProduct();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: inProgress
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : ListView.separated(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          titlePadding: const EdgeInsets.only(left: 16),
                          contentPadding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 8),
                          title: Row(
                            children: [
                              const Text('Chose an action'),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close))
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                onTap: () {},
                                leading: const Icon(Icons.edit),
                                title: const Text('Edit'),
                              ),
                              const Divider(
                                height: 0,
                              ),
                              ListTile(
                                onTap: () {},
                                leading: const Icon(Icons.delete),
                                title: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  leading: Image.network(
                    products[index].image,
                    width: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image);
                    },
                  ),
                  title: Text(products[index].productName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product code: ${products[index].productCode}'),
                      Text('Quantity : ${products[index].quantity}'),
                      Text('Total price: ${products[index].totalPrice}'),
                    ],
                  ),
                  trailing: Text('${products[index].unitPrice}/p'),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNewProductScreen(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
