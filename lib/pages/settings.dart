import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import '../services/pdf_extraction_service.dart';
import '../services/product_services.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Container(
        margin: const EdgeInsets.all(3),
        child: Image.asset('assets/images/OutCrop_Logo.png'),
      ),
      backgroundColor: const Color(0xFF5ce1e6),
      title: const Text('Settings'),
      centerTitle: true,
    );
  }
}

class SettingsBody extends StatelessWidget {
  final String selectedDate;
  final ValueChanged<String> onDateChanged;
  final bool isAdmin;

  const SettingsBody({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    this.isAdmin = false,
  });

  // Admin Function: Handles PDF selection, byte reading, and extraction
  Future<void> _handleAdminUpload(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, // Crucial for reading file content into memory
    );

    if (result != null) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final bytes = result.files.first.bytes;
        
        if (bytes == null) {
          throw Exception("Could not read file data. Try picking the file again.");
        }

        // 1. Extract data using the Dart port of your Python script
        final products = await PdfExtractionService.extractProducts(bytes);
        
        // Debug check for the console
        debugPrint("Extracted ${products.length} products from PDF");

        if (products.isEmpty) {
          throw Exception("No products were found in the PDF. Check if the format matches the script logic.");
        }

        // 2. Upload to Firestore using selectedDate as collection name
        await ProductService.uploadBatch(selectedDate, products);

        if (context.mounted) Navigator.pop(context); // Close loading

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Success! ${products.length} items added to $selectedDate"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (context.mounted) Navigator.pop(context); // Close loading
        debugPrint("UPLOAD ERROR: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Existing Date Picker - PRESERVED UNCHANGED
  Future<void> _pickDate(BuildContext context) async {
    final initialDate = DateTime.tryParse(selectedDate) ?? DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      final formatted =
          "${pickedDate.year.toString().padLeft(4, '0')}-"
          "${pickedDate.month.toString().padLeft(2, '0')}-"
          "${pickedDate.day.toString().padLeft(2, '0')}";

      onDateChanged(formatted);
    }
  }

  // Existing Logout - PRESERVED UNCHANGED
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Selected Price Date",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(selectedDate),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () => _pickDate(context),
              icon: const Icon(Icons.calendar_today),
              label: const Text("Change Date"),
            ),

            // Conditional Admin Panel UI
            if (isAdmin) ...[
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                "Admin Panel",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => _handleAdminUpload(context),
                icon: const Icon(Icons.upload_file),
                // Corrected string interpolation for selectedDate
                label: Text("Upload PDF to $selectedDate"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade50),
              ),
              Text(
                "Note: This overwrites the existing database for $selectedDate.",
                style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
              ),
            ],

            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}