import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import 'address_screen.dart';
import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  //STORE FULL ADDRESS INFO 
  Map<String, String> _addressData = {
    "name": "NameTest", //dummy data
    "country": "Country",
    "city": "City",
    "phone": "+1234567890",
    "address": "Address 1234",
  };

  //STORE FULL PAYMENT INFO
  Map<String, String> _paymentData = {
    "owner": "NameTest", //dummy data
    "number": "1234567890",
    "exp": "24/24",
    "cvv": "776",
    "type": "Visa Classic" 
  };

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final items = cart.items.values.toList();
    
    const backgroundColor = Color(0xFFF8F9FA);
    const purpleColor = Color(0xFF9775FA);
    const darkText = Color(0xFF1D1E20);

    //format the display strings
    String displayAddress = "${_addressData['address']}, ${_addressData['city']}";
    String displayCard = _paymentData['number']!.length > 4 
        ? "**** ${_paymentData['number']!.substring(_paymentData['number']!.length - 4)}" 
        : _paymentData['number']!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          "Cart",
          style: TextStyle(color: darkText, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text("Your Cart is Empty", style: TextStyle(fontSize: 18, color: Colors.grey)),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Cart Items List
                        ...items.map((item) => _buildCartItem(item, cart)),

                        const SizedBox(height: 10),

                        // 2. Delivery Address Section
                        _buildSectionHeader("Delivery Address", () async {
                           // PASS DATA TO SCREEN
                           final result = await Navigator.push(
                             context, 
                             MaterialPageRoute(
                               builder: (context) => AddressScreen(initialData: _addressData)
                             )
                           );
                           
                           // UPDATE STATE IF SAVE WAS PRESSED
                           if (result != null && result is Map<String, String>) {
                             setState(() {
                               _addressData = result;
                             });
                           }
                        }),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Container(
                              width: 50, height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                                image: const DecorationImage(
                                  image: NetworkImage("https://i.imgur.com/L1T5c8p.png"), 
                                  fit: BoxFit.cover
                                )
                              ),
                              child: const Icon(Icons.location_on, color: Colors.redAccent),
                            ),
                            const SizedBox(width: 15),
                             Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(displayAddress, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  Text(_addressData['city']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                            const Icon(Icons.check_circle, color: Colors.green, size: 28)
                          ],
                        ),

                        const SizedBox(height: 25),

                        // 3. Payment Method Section
                        _buildSectionHeader("Payment Method", () async {
                           // PASS DATA TO SCREEN
                           final result = await Navigator.push(
                             context, 
                             MaterialPageRoute(
                               builder: (context) => PaymentScreen(initialData: _paymentData)
                             )
                           );
                           
                           // UPDATE STATE IF SAVE WAS PRESSED
                           if (result != null && result is Map<String, String>) {
                             setState(() {
                               _paymentData = result;
                             });
                           }
                        }),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Container(
                              width: 50, height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(child: Text("VISA", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.blue, fontStyle: FontStyle.italic))),
                            ),
                            const SizedBox(width: 15),
                             Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_paymentData['type']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  Text(displayCard, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                            const Icon(Icons.check_circle, color: Colors.green, size: 28)
                          ],
                        ),

                        // 4. Order Info
                        const SizedBox(height: 25),
                        const Text("Order Info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 15),
                        _buildOrderInfoRow("Subtotal", "\$${cart.totalAmount.toStringAsFixed(2)}"),
                        const SizedBox(height: 10),
                        _buildOrderInfoRow("Shipping cost", "\$10.00"),
                        const SizedBox(height: 10),
                        _buildOrderInfoRow("Total", "\$${(cart.totalAmount + 10).toStringAsFixed(2)}", isTotal: true),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),

                // CHECKOUT BUTTON
                Container(
                  width: double.infinity,
                  color: backgroundColor,
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      _showCheckoutDialog(context, cart);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purpleColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    child: const Text("Checkout", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
    );
  }

  //Build a single cart item
  Widget _buildCartItem(CartItem item, CartProvider cart) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 80, height: 80,
              color: Colors.grey[100],
              child: Image.network(
                item.imageUrl, 
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const Icon(Icons.broken_image),
              ),
            ),
          ),
          const SizedBox(width: 15),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  "\$${item.price}", 
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(height: 10),
                
                // Quantity Arrows
                Row(
                  children: [
                    InkWell(
                      onTap: () => cart.removeSingleItem(item.productId),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
                        child: const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                         final dummyProduct = Product(
                           id: item.productId,
                           title: item.title,
                           price: item.price,
                           description: "",
                           imageUrl: item.imageUrl,
                         );
                         cart.addItem(dummyProduct);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
                        child: const Icon(Icons.keyboard_arrow_up, size: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          // Delete Button
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.grey),
            onPressed: () {
               cart.removeSingleItem(item.productId); 
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Icon(Icons.chevron_right, color: Colors.grey)
        ],
      ),
    );
  }

  Widget _buildOrderInfoRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isTotal ? Colors.black : Colors.grey, fontSize: 15, fontWeight: isTotal? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: isTotal ? FontWeight.bold : FontWeight.w600)),
      ],
    );
  }

  void _showCheckoutDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Order Confirmed!"),
        content: const Text("Your order has been placed successfully."),
        actions: [
          TextButton(
            onPressed: () {
              cart.clearCart();
              Navigator.of(ctx).pop(); 
              Navigator.of(context).pop();
            },
            child: const Text("Okay"),
          )
        ],
      ),
    );
  }
}