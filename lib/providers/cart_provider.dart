import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];
  List<ProductModel> _products = [];
  List<OrderHistory> _orders = [];

  List<CartItem> get cartItems => _cartItems;
  List<ProductModel> get products => _products;
  List<OrderHistory> get orders => _orders;

  double get subtotal =>
      _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get ongkir => _cartItems.isEmpty ? 0.0 : 15000.0;
  double get totalPembayaran => subtotal + ongkir;
  int get totalItemCount =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  Future<void> fetchProducts() async {
    _products = await DBHelper.getProducts();
    notifyListeners();
  }

  Future<void> addProduct(ProductModel product) async {
    await DBHelper.insertProduct(product);
    await fetchProducts();
  }

  Future<void> addToCart(ProductModel product) async {
    int index = _cartItems.indexWhere((item) => item.name == product.name);
    if (index >= 0) {
      _cartItems[index].quantity += 1;
    } else {
      _cartItems.add(
        CartItem(
          name: product.name,
          price: product.price,
          quantity: 1,
          imageUrl: product.imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(CartItem item, int newQuantity) {
    int index = _cartItems.indexOf(item);
    if (index != -1) {
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void removeItem(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  Future<void> fetchHistory() async {
    _orders = await DBHelper.getOrders();
    notifyListeners();
  }

  Future<void> checkout() async {
    if (_cartItems.isEmpty) return;

    OrderHistory newOrder = OrderHistory(
      totalPrice: totalPembayaran,
      date: DateTime.now().toString().split(' ')[0],
    );

    await DBHelper.insertOrder(newOrder);
    _cartItems.clear();
    await fetchHistory();
    notifyListeners();
  }
}