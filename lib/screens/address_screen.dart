import 'package:flutter/material.dart';

class AddressScreen extends StatefulWidget {
  final Map<String, String> initialData;
  const AddressScreen({super.key, required this.initialData});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late TextEditingController _nameController;
  late TextEditingController _countryController;
  late TextEditingController _cityController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  bool _saveAsPrimary = true;

  @override
  void initState() {
    super.initState();
    // Initialize with passed data or defaults
    _nameController = TextEditingController(text: widget.initialData['name']);
    _countryController = TextEditingController(text: widget.initialData['country']);
    _cityController = TextEditingController(text: widget.initialData['city']);
    _phoneController = TextEditingController(text: widget.initialData['phone']);
    _addressController = TextEditingController(text: widget.initialData['address']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    // VALIDATION: Phone Number
    String phone = _phoneController.text.trim();
    // Strip non-digits for length check
    String digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (digits.length < 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone number must be at least 12 digits")),
      );
      return;
    }

    if (_nameController.text.isEmpty || _cityController.text.isEmpty || _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    // Return Data to Cart Screen
    Navigator.pop(context, {
      "name": _nameController.text,
      "country": _countryController.text,
      "city": _cityController.text,
      "phone": _phoneController.text,
      "address": _addressController.text,
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
          "Address",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Name"),
                    _buildTextField(_nameController, "Type your name"),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Country"),
                              _buildTextField(_countryController, "Country"),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("City"),
                              _buildTextField(_cityController, "City"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    _buildLabel("Phone Number"),
                    _buildTextField(_phoneController, "Type phone number", isNumber: true),
                    const SizedBox(height: 15),

                    _buildLabel("Address"),
                    _buildTextField(_addressController, "Type full address"),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Save as primary address", style: TextStyle(fontWeight: FontWeight.w600)),
                        Switch(
                          value: _saveAsPrimary,
                          activeColor: purpleColor,
                          onChanged: (val) => setState(() => _saveAsPrimary = val),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: purpleColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                ),
                onPressed: _saveAddress,
                child: const Text("Save Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isNumber = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }
}