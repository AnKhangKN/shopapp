import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/models/product_models.dart';
import 'package:shopapp/models/token_storage.dart';
import 'package:shopapp/screens/login/login_screen.dart';
import 'package:shopapp/services/product_services.dart';
import 'package:shopapp/widgets/card_in_home/product_card.dart';
import 'package:shopapp/services/user_services.dart';

import '../../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? user;
  Future<List<Product>>? _futureProducts;

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 22) {
      return "Good Evening";
    } else {
      return "Good night";
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    _futureProducts = ProductServices().getAllProducts();
  }

  List<Product> getUniqueCategoryProducts(List<Product> products) {
    final Map<String, Product> uniqueMap = {};

    for (var product in products) {
      final category = product.category.toLowerCase().trim();
      if (!uniqueMap.containsKey(category)) {
        uniqueMap[category] = product;
      }
    }

    return uniqueMap.values.toList();
  }

  List<Product> getBestSellerProducts(List<Product> products, {int limit = 10}) {
    // Sắp xếp theo trường soldCount giảm dần
    products.sort((a, b) => (b.soldCount ?? 0).compareTo(a.soldCount ?? 0));
    return products.take(limit).toList();
  }

  Future<void> fetchUserInfo() async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) return;

    try {
      final result = await UserServices().getUserInfo(accessToken: token);
      setState(() {
        user = result;
      });
    } catch (e) {
      print("Lỗi khi fetch user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(FeatherIcons.search),
            onPressed: () {
              final currentLocation = GoRouter.of(
                context,
              ).routerDelegate.currentConfiguration.uri.toString();
              context.go('/search?from=$currentLocation');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: user == null
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "${getGreeting()}, ${user?.userName ?? "User"}",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20,),

                    ElevatedButton(onPressed: () async {
                      await TokenStorage.clearToken();
                      context.go('/login');
                    }, child: Text('Đăng xuất')),

                    const SizedBox(height: 25),

                    Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Top Picks for you",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Recommended products",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed('product');
                                },
                                child: const Text(
                                  "View All",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 240,
                      child: FutureBuilder<List<Product>>(
                        future: ProductServices().getAllProducts(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Text('Lỗi: ${snapshot.error}');
                          }

                          final products = getUniqueCategoryProducts(snapshot.data!);
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: ProductCard(product: products[index]),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        "New From Nike",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () {
                        context.push('/discover/structure26');
                      },
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/structure26.png',
                            width: double.infinity,
                            height: 500,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shop Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 3,
                                        color: Colors.black45,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'structure 26'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 3,
                                        color: Colors.black45,
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(onPressed: () {
                                  context.push('/discover/structure26');
                                }, child: Text("Explore", style: TextStyle(color: Colors.black),)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        "Best Seller",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 240,
                      child: FutureBuilder<List<Product>>(
                        future: _futureProducts,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Text('Lỗi: ${snapshot.error}');
                          }

                          final products = getBestSellerProducts(snapshot.data!);

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: ProductCard(product: products[index]),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    // footer home
                    Container(
                      padding: EdgeInsets.only(top: 30, bottom: 60),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/logo_nike.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                          Text(
                            "Thank for being with us",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
