import 'package:flutter/material.dart';
import 'package:shopapp/models/cart_models.dart';

import '../../models/address_models.dart';

class CheckoutProvider extends ChangeNotifier {
  List<CartItem> _selectedItems = [];

  List<CartItem> get selectedItems => _selectedItems;
  ShippingAddress? _selectedAddress;

  ShippingAddress? get selectedAddress => _selectedAddress;

  void setShippingAddress(ShippingAddress address) {
    _selectedAddress = address;
    notifyListeners();
  }


  void setSelectedItems(List<CartItem> items) {
    _selectedItems = items;
    notifyListeners();
  }

  void clear() {
    _selectedItems = [];
    _selectedAddress = null;
    notifyListeners();
  }

}
