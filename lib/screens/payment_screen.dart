import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for LengthLimitingTextInputFormatter

class PaymentScreen extends StatefulWidget {
  final Map<String, String> initialData;
  const PaymentScreen({super.key, required this.initialData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late TextEditingController _ownerController;
  late TextEditingController _cardNumberController;
  late TextEditingController _expController;
  late TextEditingController _cvvController;
  
  int _selectedCardType = 0;

  @override
  void initState() {
    super.initState();
    _ownerController = TextEditingController(text: widget.initialData['owner']);
    _cardNumberController = TextEditingController(text: widget.initialData['number']);
    _expController = TextEditingController(text: widget.initialData['exp']);
    _cvvController = TextEditingController(text: widget.initialData['cvv']);
  }

  @override
  void dispose() {
    _ownerController.dispose();
    _cardNumberController.dispose();
    _expController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _saveCard() {
    // Regex checks for 01-12 slash 00-99
    final expRegex = RegExp(r"^(0[1-9]|1[0-2])\/?([0-9]{2})$"); 
    if (!expRegex.hasMatch(_expController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Expiry must be MM/YY (e.g. 12/24)")),
      );
      return;
    }

    if (_cardNumberController.text.length < 16) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Card number must be 16 digits")),
      );
      return;
    }
    
    if (_cvvController.text.length < 3) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CVV must be 3 digits")),
      );
      return;
    }

    // Return map
    Navigator.pop(context, {
      "owner": _ownerController.text,
      "number": _cardNumberController.text,
      "exp": _expController.text,
      "cvv": _cvvController.text,
      "type": "Visa Classic" //dummy info
    });
  }

  @override
  Widget build(BuildContext context) {
    const purpleColor = Color(0xFF9775FA);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[100],
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          "Add New Card",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Card Type Selectors
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCardTypeBtn(0, Icons.credit_card, Colors.orange),
                _buildCardTypeBtn(1, Icons.paypal, Colors.blue),
                _buildCardTypeBtn(2, Icons.account_balance, Colors.black),
              ],
            ),
            const SizedBox(height: 30),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Card Owner"),
                    _buildTextField(_ownerController, "Enter card owner name"),
                    const SizedBox(height: 15),

                    _buildLabel("Card Number"),
                    // Limit to 16 digits
                    _buildTextField(_cardNumberController, "Enter card number", isNumber: true, maxLength: 16),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("EXP"),
                              _buildTextField(_expController, "MM/YY", maxLength: 5),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("CVV"),
                              // Limit to 3 digits
                              _buildTextField(_cvvController, "123", isNumber: true, maxLength: 3),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Add Card Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: purpleColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _saveCard,
                child: const Text("Add Card", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCardTypeBtn(int index, IconData icon, Color color) {
    final isSelected = _selectedCardType == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedCardType = index),
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFE0CB) : Colors.grey[100], 
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: Colors.orange, width: 2) : null
        ),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isNumber = false, int? maxLength}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        // Use inputFormatters to strictly enforce limits
        inputFormatters: [
          if (isNumber) FilteringTextInputFormatter.digitsOnly,
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
        ],
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          counterText: "", // Hides the tiny character counter
        ),
      ),
    );
  }
}