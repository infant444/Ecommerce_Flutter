import 'package:e_commerce_admin/container/additional_confirm.dart';
import 'package:e_commerce_admin/controllers/firestore_services.dart';
import 'package:e_commerce_admin/model/promo_Banner.model.dart';
import 'package:flutter/material.dart';

class PromosBannerPage extends StatefulWidget {
  const PromosBannerPage({super.key});

  @override
  State<PromosBannerPage> createState() => _PromosBannerPageState();
}

class _PromosBannerPageState extends State<PromosBannerPage> {
  bool _isInitialized = false;
  bool _isPromo = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        final arguments = ModalRoute.of(context)?.settings.arguments;
        if (arguments != null && arguments is Map<String, dynamic>) {
          _isPromo = arguments["Promo"] ?? true;
          print("Promo $_isPromo");
        }
        _isInitialized = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isPromo ? "Promos" : "Banner"),
      ),
      body: _isInitialized
          ? StreamBuilder(
              stream: FirestoreServices().readPromos(_isPromo),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<PromoBanner> promos =
                      PromoBanner.fromJsonList(snapshot.data!.docs)
                          as List<PromoBanner>;

                  if (promos.isEmpty) {
                    return Center(
                      child:
                          Text("No ${_isPromo ? "Promos" : "Banners"} found"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: promos.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("What you want to do"),
                                      content: Text(
                                          "Delete action cannot be undone"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AdditionalConfirm(
                                                          text:
                                                              "Are you sure you want to delete this",
                                                          onYes: () {
                                                            Navigator.pop(
                                                                context);
                                                            FirestoreServices()
                                                                .deletePromo(
                                                                    id: promos[
                                                                            index]
                                                                        .id,
                                                                    isPromo:
                                                                        _isPromo);
                                                          },
                                                          onNo: () {
                                                            Navigator.pop(
                                                                context);
                                                          }));
                                            },
                                            child: Text("Delete")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pushNamed(
                                                  context, "/update_promo",
                                                  arguments: {
                                                    "promo": _isPromo,
                                                    "detail": promos[index]
                                                  });
                                            },
                                            child: Text("Update")),
                                      ],
                                    ));
                          },
                          leading: Container(
                            height: 50,
                            width: 50,
                            child: Image.network(
                              promos[index].image,
                              fit: BoxFit.contain,
                            ),
                          ),
                          title: Text(
                            promos[index].title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(promos[index].category),
                          trailing: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "/update_promo",
                                    arguments: {
                                      "promo": _isPromo,
                                      "detail": promos[index]
                                    });
                              },
                              icon: Icon(Icons.edit_outlined)),
                        );
                      },
                    );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              })
          : SizedBox(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/update_promo",
              arguments: {"promo": _isPromo});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
