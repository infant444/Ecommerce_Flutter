// ignore_for_file: dead_code, prefer_const_constructors

import 'package:e_commerce_admin/container/additional_confirm.dart';
import 'package:e_commerce_admin/controllers/firestore_services.dart';
import 'package:e_commerce_admin/model/categories.model.dart';
import 'package:e_commerce_admin/provider/admin.provider.dart';
import 'package:e_commerce_admin/sub_Component/modify_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
      ),
      body: Consumer<AdminProvider>(builder: (context, value, child) {
        List<Category> categories = Category.fromJsonList(value.categories);
        if (value.categories.isEmpty) {
          return Center(
            child: Text("No Categories Found :("),
          );
        }
        return ListView.builder(
          itemCount: value.categories.length,
          itemBuilder: (context, index) {
            return ListTile(
                leading: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.network(categories[index].img == null ||
                          categories[index].img == ""
                      ? "https://plus.unsplash.com/premium_photo-1675747966994-fed6bb450c31?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8cGxhaW4lMjBiYWNrZ3JvdW5kc3xlbnwwfHwwfHx8MA%3D%3D"
                      : categories[index].img),
                ),
                title: Text(
                  categories[index].name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("What you want to do"),
                            content: Text("Delete action cannot be undone"),
                            actions: [
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
                                              FirestoreServices()
                                                  .deleteCategories(
                                                      id: categories[index].id);
                                            },
                                            onNo: () {
                                              Navigator.pop(context);
                                            }));
                                  },
                                  child: Text("Delete Category")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (context) => ModifyCategory(
                                              isUpdating: true,
                                              categoryId: categories[index].id,
                                              priority:
                                                  categories[index].priority,
                                              image: categories[index].img,
                                              name: categories[index].name,
                                            ));
                                  },
                                  child: Text("Update Category")),
                            ],
                          ));
                },
                subtitle: Text("Priority : ${categories[index].priority}"),
                trailing: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => ModifyCategory(
                                isUpdating: true,
                                categoryId: categories[index].id,
                                priority: categories[index].priority,
                                image: categories[index].img,
                                name: categories[index].name,
                              ));
                    },
                    icon: Icon(Icons.edit_outlined)));
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => ModifyCategory(
                  isUpdating: false, categoryId: "", priority: 0));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
