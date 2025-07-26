import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/checkout/checkout_provider.dart';
import 'package:shopapp/services/checkout_services.dart';
import '../../models/address_models.dart';
import '../../models/cart_models.dart';

enum PaymentMethod { cod, bankTransfer, eWallet }

enum ShippingType { fast, standard }

extension ShippingPrice on ShippingType {
  int get price {
    switch (this) {
      case ShippingType.fast:
        return 30000;
      case ShippingType.standard:
        return 15000;
    }
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.cod;
  final TextEditingController _noteController = TextEditingController();
  final NumberFormat _formatter = NumberFormat("#,##0", "vi_VN");
  ShippingType _selectedShippingPrice = ShippingType.standard;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  double _calculateTotal(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  Future<void> showAddressModal({
    required BuildContext context,
    required List<ShippingAddress> addresses,
    required Function(ShippingAddress) onSelected,
  }) async {
    List<ShippingAddress> addressList = List.from(addresses); // Tạo bản sao để cập nhật trong modal

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Chọn địa chỉ giao hàng',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: addressList.length,
                    itemBuilder: (context, index) {
                      final address = addressList[index];
                      return ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text('${address.address}, ${address.city}'),
                        subtitle: Text('SĐT: ${address.phone}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Xác nhận"),
                                content:
                                const Text("Bạn có chắc muốn xóa địa chỉ này?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text("Hủy"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(ctx).pop();

                                      try {
                                        await CheckoutServices().deleteAddress(
                                          address.phone,
                                          address.address,
                                          address.city,
                                        );
                                        setModalState(() {
                                          addressList.removeAt(index);
                                        });

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content:
                                          Text("Xóa địa chỉ thành công!"),
                                        ));
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Lỗi khi xóa địa chỉ: $e"),
                                        ));
                                      }
                                    },
                                    child: const Text(
                                      "Xóa",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          onSelected(address);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                  const Divider(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push('/add-address');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Thêm địa chỉ mới"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Future<void> _createOrder() async {
    final checkoutProvider = Provider.of<CheckoutProvider>(
      context,
      listen: false,
    );
    final selectedAddress = checkoutProvider.selectedAddress;
    final selectedItems = checkoutProvider.selectedItems;

    if (selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn địa chỉ giao hàng")),
      );
      return;
    }

    try {
      await CheckoutServices().createOrder(
        shippingAddress: selectedAddress.toJson(),
        items: selectedItems.map((item) => item.toJson()).toList(),
        orderNote: _noteController.text,
        totalPrice:
            _calculateTotal(selectedItems) + _selectedShippingPrice.price,
        shippingPrice: _selectedShippingPrice.price,
        paymentMethod: _selectedMethod.name,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Tạo đơn hàng thành công")));

      // TODO: Clear cart, navigate v.v
      checkoutProvider.clear();

      context.pop('refresh');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi khi tạo đơn hàng: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkoutProvider = Provider.of<CheckoutProvider>(context);
    final selectedItems = checkoutProvider.selectedItems;
    final selectedAddress = checkoutProvider.selectedAddress;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop('refresh'),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Thanh toán"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                try {
                  final userAddresses = await CheckoutServices()
                      .getShippingAddresses();

                  if (userAddresses.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Chưa có địa chỉ'),
                        content: const Text(
                          'Vui lòng thêm địa chỉ trước khi thanh toán.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => context.pushNamed('addAddress'),
                            child: const Text('Thêm địa chỉ'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Đóng'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    showAddressModal(
                      context: context,
                      addresses: userAddresses,
                      onSelected: (ShippingAddress selected) {
                        checkoutProvider.setShippingAddress(selected);
                      },
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi khi lấy địa chỉ: $e')),
                  );
                }
              },
              child: Text(
                selectedAddress != null
                    ? 'Thay đổi địa chỉ'
                    : 'Chọn/Thêm địa chỉ',
              ),
            ),

            if (selectedAddress != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Địa chỉ giao hàng:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("SĐT: ${selectedAddress.phone}"),
                    Text("${selectedAddress.address}, ${selectedAddress.city}"),
                  ],
                ),
              ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        ...selectedItems.map(
                          (item) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),

                            child: ListTile(
                              leading: Image.network(
                                '${dotenv.env['API_BASE_URL']}/productImage/${item.productImage}' ??
                                    'https://www.tiffincurry.ca/wp-content/uploads/2021/02/default-product.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(item.productName ?? 'Tên sản phẩm'),
                              subtitle: Text('Số lượng: ${item.quantity}'),
                              trailing: Text(
                                '${_formatter.format(item.price * item.quantity)} đ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          margin: EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Tổng tiền",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${_formatter.format(_calculateTotal(selectedItems))} đ",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                            controller: _noteController,
                            decoration: const InputDecoration(
                              labelText: "Ghi chú",
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Column(
                          children: [
                            const Text(
                              'Phương thức vận chuyển',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            RadioListTile<ShippingType>(
                              title: Text("Vận chuyển tiêu chẩn: 15.000 đ"),
                              value: ShippingType.standard,
                              groupValue: _selectedShippingPrice,
                              onChanged: (value) => setState(
                                () => _selectedShippingPrice = value!,
                              ),
                            ),
                            RadioListTile<ShippingType>(
                              title: Text("Vận chuyển nhanh: 30.000 đ"),
                              value: ShippingType.fast,
                              groupValue: _selectedShippingPrice,
                              onChanged: (value) => setState(
                                () => _selectedShippingPrice = value!,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey), // đường viền
                      borderRadius: BorderRadius.circular(8), // bo góc
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Phương thức thanh toán:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RadioListTile<PaymentMethod>(
                          title: const Text('Thanh toán khi nhận hàng (COD)'),
                          value: PaymentMethod.cod,
                          groupValue: _selectedMethod,
                          onChanged: (value) =>
                              setState(() => _selectedMethod = value!),
                        ),
                        RadioListTile<PaymentMethod>(
                          title: const Text('Chuyển khoản ngân hàng'),
                          value: PaymentMethod.bankTransfer,
                          groupValue: _selectedMethod,
                          onChanged: (value) =>
                              setState(() => _selectedMethod = value!),
                        ),
                      ],
                    ),
                  ),

                  // RadioListTile<PaymentMethod>(
                  //   title: const Text('Ví điện tử'),
                  //   value: PaymentMethod.eWallet,
                  //   groupValue: _selectedMethod,
                  //   onChanged: (value) =>
                  //       setState(() => _selectedMethod = value!),
                  // ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Tổng tiền:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${_formatter.format(_calculateTotal(selectedItems) + _selectedShippingPrice.price)} đ",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: selectedItems.isEmpty || selectedAddress == null
                        ? null
                        : _createOrder,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text("Thanh toán"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
