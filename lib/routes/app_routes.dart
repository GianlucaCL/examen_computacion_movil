// lib/routes/app_routes.dart

import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../screens/register_user_screen.dart';
import '../screens/home_screen.dart';

import '../screens/list_product_screen.dart';
import '../screens/edit_product_screen.dart';
import '../screens/product_detail_screen.dart';

import '../screens/categories_list_screen.dart';
import '../screens/category_form_screen.dart';
import '../screens/category_detail_screen.dart';

import '../screens/providers_list_screen.dart';
import '../screens/provider_form_screen.dart';
import '../screens/provider_detail_screen.dart';

import '../screens/cartscreen.dart';
import '../screens/error_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static const String products = '/products';
  static const String productForm = '/products/form';
  static const String productDetail = '/products/detail';

  static const String categories = '/categories';
  static const String categoryForm = '/categories/form';
  static const String categoryDetail = '/categories/detail';

  static const String providers = '/providers';
  static const String providerForm = '/providers/form';
  static const String providerDetail = '/providers/detail';

  static const String cart = '/cart';

  static const String initialRoute = login;

  static final Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterUserScreen(),
    home: (_) => const HomeScreen(),
    products: (_) => const ListProductScreen(),
    productForm: (_) => const EditProductScreen(),
    productDetail: (_) => const ProductDetailScreen(),
   
    categories: (_) => const CategoriesListScreen(),
    categoryDetail: (_) => const CategoryDetailScreen(),
    categoryForm: (_) => const CategoryFormScreen(),
    providers: (_) => const ProvidersListScreen(),
    providerForm: (_) => const ProviderFormScreen(),
    providerDetail: (_) => const ProviderDetailScreen(),
    cart: (_) => CartScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => const ErrorScreen());
  }
}
