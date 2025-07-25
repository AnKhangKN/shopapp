import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/models/cart_models.dart';
import 'package:shopapp/services/cart_services.dart';
import 'package:provider/provider.dart';

import '../checkout/checkout_provider.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _cartServices = CartService();
  List<CartItem> _allCartItem = [];
  bool _loading = false;
  Set<String> _selectedItems = {};
  bool _isSelectAll = false;

  String _getCartItemKey(CartItem item) {
    return '${item.productId}_${item.color}_${item.size}';
  }

  double _getTotalSelectedPrice() {
    double total = 0;
    for (var item in _allCartItem) {
      if (_selectedItems.contains(_getCartItemKey(item))) {
        total += (item.price * item.quantity);
      }
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    fetchCarts();
  }

  void fetchCarts() async {
    setState(() {
      _loading = true;
    });

    try {
      final result = await _cartServices.getCartItem();

      setState(() {
        _allCartItem = result;
        _loading = false;
      });
    } catch (e) {
      print('Lỗi: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _updateQuantity(CartItem item, int newQuantity) async {
    try {
      await _cartServices.updateItemQuantity(
          item.productId, item.color, item.size!, newQuantity
      );
      fetchCarts(); // reload lại giỏ hàng
    } catch (e) {
      print("Lỗi cập nhật số lượng: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật thất bại")),
      );
    }
  }

  void _showQuantityModal(CartItem item) {
    int selectedQuantity = item.quantity;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.productName ?? "Sản phẩm",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: selectedQuantity > 1
                            ? () => setState(() => selectedQuantity--)
                            : null,
                        icon: const Icon(Icons.remove),
                      ),
                      Text('$selectedQuantity', style: const TextStyle(fontSize: 20)),
                      IconButton(
                        onPressed: () => setState(() => selectedQuantity++),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _updateQuantity(item, selectedQuantity);
                    },
                    child: const Text("Cập nhật số lượng"),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giỏ hàng")),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _allCartItem.isEmpty
              ? const Center(child: Text("Giỏ hàng trống"))
              : ListView.builder(
            itemCount: _allCartItem.length + 1, // +1 cho dòng "Chọn tất cả"
            itemBuilder: (context, index) {
              if (index == 0) {
                return CheckboxListTile(
                  value: _isSelectAll,
                  onChanged: (value) {
                    setState(() {
                      _isSelectAll = value ?? false;
                      if (_isSelectAll) {
                        _selectedItems = _allCartItem
                            .map((e) => _getCartItemKey(e))
                            .toSet();
                      } else {
                        _selectedItems.clear();
                      }
                    });
                  },
                  title: const Text("Chọn tất cả"),
                );
              }

              final item = _allCartItem[index - 1];
              final itemKey = _getCartItemKey(item);
              final isSelected = _selectedItems.contains(itemKey);

              return _buildCartItem(item, isSelected, (bool? selected) {
                setState(() {
                  if (selected == true) {
                    _selectedItems.add(itemKey);
                  } else {
                    _selectedItems.remove(itemKey);
                  }

                  // Cập nhật lại trạng thái "chọn tất cả"
                  _isSelectAll = _selectedItems.length == _allCartItem.length;
                });
              });
            },


          ),
        ),
      ),
      bottomNavigationBar: _allCartItem.isEmpty
          ? null
          : Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Tổng tiền
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tổng tiền:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${_getTotalSelectedPrice().toStringAsFixed(0)} đ',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
              ],
            ),
            const SizedBox(height: 10),

            /// Nút mua hàng
            ElevatedButton(
              onPressed: _selectedItems.isEmpty
                  ? null
                  : () {
                final selectedCartItems = _allCartItem.where((item) =>
                    _selectedItems.contains(_getCartItemKey(item))).toList();

                final checkoutProvider = context.read<CheckoutProvider>();
                checkoutProvider.setSelectedItems(selectedCartItems);

                context.pushNamed('checkout').then((result) {
                  if (result == 'refresh') {
                    fetchCarts(); // Gọi lại API để cập nhật giỏ hàng
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Mua hàng',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildCartItem(CartItem item, bool isSelected, Function(bool?) onChanged) {
    return Container(
      width: double.infinity,
      height: 100,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),


      child: GestureDetector(
        onTap: () => _showQuantityModal(item),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: onChanged,
            ),
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.grey[200],
                child: Image.network(
                  item.productImage != null
                      ? '${dotenv.env['API_BASE_URL']}/productImage/${item.productImage}'
                      : 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.productName ?? 'Tên sản phẩm',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Màu: ${item.color}, Size: ${item.size ?? "Không có"}'),
                    Text('Số lượng: ${item.quantity}'),
                    Text('Giá: ${item.price.toString()} đ'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
