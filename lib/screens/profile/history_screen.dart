import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopapp/services/profile_services.dart';

import '../../models/order_models.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Order>? _orders;
  final _profileServices = ProfileServices();
  final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  void _fetchAllOrder () async {
    try {
      final orders = await _profileServices.getAllHistory();
      setState(() {
        _orders = orders;
      });
    } catch (e) {
      print('Lỗi: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAllOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lịch sử mua hàng")),
      body: _orders == null
          ? const Center(child: CircularProgressIndicator())
          : _orders!.isEmpty
          ? const Center(child: Text("Bạn chưa có đơn hàng nào."))
          : ListView.builder(
        itemCount: _orders!.length,
        itemBuilder: (context, index) {
          final order = _orders![index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text("Đơn hàng: ${order.id}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text("Tổng tiền: ${formatter.format(order.totalPrice)}"),
                  Text("Giao đến: ${order.shippingAddress.address}"),
                  Text("Thanh toán: ${order.paymentMethod}"),
                ],
              ),
              isThreeLine: true,
              onTap: () {
                // Nếu bạn có trang chi tiết đơn hàng thì chuyển hướng tại đây
              },
            ),
          );
        },
      ),
    );
  }

}
