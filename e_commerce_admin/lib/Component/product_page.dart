import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:e_commerce_admin/container/additional_confirm.dart';
import 'package:e_commerce_admin/controllers/firestore_services.dart';
import 'package:e_commerce_admin/model/product.model.dart';
import 'package:e_commerce_admin/provider/admin.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    String symbol = getCurrencySymbol("INR");
    print(symbol);
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: Consumer<AdminProvider>(builder: (context, value, child) {
        List<Product> product = Product.fromJsonList(value.Product);
        if (product.isEmpty) {
          return Center(
            child: Text("No product Found :("),
          );
        }
        return ListView.builder(
            itemCount: product.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.pushNamed(context, "/view-product",
                      arguments: product[index]);
                },
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("What you want to do"),
                            content: Text("Delete action cannot be undone"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, "/add-product",
                                        arguments: product[index]);
                                  },
                                  child: Text("Update Product")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (context) => AdditionalConfirm(
                                            text:
                                                "Are you sure you want to delete this",
                                            onYes: () {
                                              Navigator.pop(context);
                                              FirestoreServices().deleteProduct(
                                                  id: product[index].id);
                                            },
                                            onNo: () {
                                              Navigator.pop(context);
                                            }));
                                  },
                                  child: Text("delete Product"))
                            ],
                          ));
                },
                leading: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.network(
                    product[index].image,
                    fit: BoxFit.contain,
                  ),
                ),
                title: Text(
                  product[index].name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$symbol ${product[index].new_price.toString()}",
                    ),
                    Container(
                        padding: EdgeInsets.all(4),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          product[index].category.toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/add-product",
                          arguments: product[index]);
                    },
                    icon: Icon(Icons.edit_outlined)),
              );
            });
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/add-product");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
