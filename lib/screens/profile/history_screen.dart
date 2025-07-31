import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  void _fetchAllOrder() async {
    try {
      final orders = await _profileServices.getAllHistory();
      setState(() {
        _orders = orders;
      });
    } catch (e) {
      print('Lỗi: $e');
    }
  }

  Future<void> handleUpdateStatus(String orderId, String status) async {

    try {
      final res = await _profileServices.changeOrderStatus(orderId, status);

      if (res.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Cập nhật trạng thái đơn hàng thành công")),
          );
          Navigator.pop(context);

          // Cập nhật lại đơn hàng trong danh sách (nếu cần)
          _fetchAllOrder(); // hoặc cập nhật 1 item bằng setState nếu bạn muốn tối ưu
        }
      } else {
        throw Exception("Cập nhật thất bại với mã: ${res.statusCode}");
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Lỗi khi cập nhật: $error")));
      }

      print(error);
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
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text("Đơn hàng: ${order.id}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          "Tổng tiền: ${formatter.format(order.totalPrice)}",
                        ),
                        Text("Giao đến: ${order.shippingAddress.address}"),
                        Text("Thanh toán: ${order.paymentMethod}"),
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 40,
                                      height: 5,
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Chi tiết đơn hàng",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 12),
                                  Text("Mã đơn hàng: ${order.id}"),
                                  Text("Ngày đặt: ${DateFormat('dd/MM/yyyy – kk:mm').format(order.createdAt!)}"),
                                  order.deliveredAt != null
                                      ? Text("Ngày nhận: ${DateFormat('dd/MM/yyyy – kk:mm').format(order.deliveredAt!)}")
                                      : SizedBox.shrink(),

                                  const Divider(height: 24),
                                  Text(
                                    "Địa chỉ giao hàng: ${order.shippingAddress.address}",
                                  ),
                                  Text(
                                    "Phương thức thanh toán: ${order.paymentMethod}",
                                  ),
                                  const Divider(height: 24),
                                  Text(
                                    "Sản phẩm:",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  ...order.items.map(
                                    (item) => ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Image.network(
                                        '${dotenv.env['SHOW_IMAGE_BASE_URL']}/product/${item.productImage}',
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                      title: Text(item.productName),
                                      subtitle: Text(
                                        "Số lượng: ${item.quantity}",
                                      ),
                                      trailing: Text(
                                        formatter.format(item.price),
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 24),
                                  Text(
                                    "Tổng tiền: ${formatter.format(order.totalPrice)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  const Divider(height: 24),

                                  ElevatedButton(
                                    onPressed: order.status == "shipped"
                                        ? () => handleUpdateStatus(
                                            order.id,
                                            "delivered",
                                          )
                                        : null, // disable nếu không phải "shipped"
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: order.status == "shipped"
                                          ? Colors.blue
                                          : order.status == "delivered"
                                          ? Colors.grey
                                          : Colors.orange,
                                      foregroundColor: Colors.white,
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      order.status == "shipped"
                                          ? "Nhận hàng"
                                          : order.status == "delivered"
                                          ? "Đã nhận hàng"
                                          : "Đang chờ xử lý",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
