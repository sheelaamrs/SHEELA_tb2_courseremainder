import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tb2hive_sheela/model/student.dart';

//@author Sheela Mutiara Sukma(41822010093)

class EditStudentDialog extends StatefulWidget {
  final Student student;

  const EditStudentDialog({required this.student});

  @override
  _EditStudentDialogState createState() => _EditStudentDialogState();
}

class _EditStudentDialogState extends State<EditStudentDialog> {
  late TextEditingController nameController;
  late TextEditingController nimController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.student.name);
    nimController = TextEditingController(text: widget.student.nim);
    phoneController = TextEditingController(text: widget.student.phone);
    emailController = TextEditingController(text: widget.student.email);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update student information',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              _buildTextField('Student Name', TextInputType.text),
              _buildTextField('NIM', TextInputType.number),
              _buildTextField('Phone', TextInputType.phone),
              _buildTextField('Email', TextInputType.emailAddress),
              SizedBox(height: 12.0),
              Row(
                children: [
                  Expanded(
                    flex: 2, // Set flex pada tombol "Update"
                    child: _buildUpdateButton(),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    flex: 1, // Set flex pada tombol "Cancel"
                    child: _buildCancelButton(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: TextField(
        controller: label == 'Student Name'
            ? nameController
            : label == 'NIM'
            ? nimController
            : label == 'Nomor Telepon'
            ? phoneController
            : emailController,
        decoration: InputDecoration(
          labelText: label,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF1C8069)),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: EdgeInsets.only(bottom: 5.0),
        ),
        keyboardType: inputType,
      ),
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: () {
        updateStudent();
        Navigator.pop(context, true);
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFF1F),
      ),
      child: Text(
        'UPDATE',
        style: TextStyle(color: Colors.black87),
      ),
    );
  }

  Widget _buildCancelButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFF1F),
      ),
      child: Text(
        'CANCEL',
        style: TextStyle(color: Colors.black87),
      ),
    );
  }

  void updateStudent() async {
    final box = Hive.box<Student>('students');

    // Mendapatkan indeks objek Student dalam box
    final index = box.values.toList().indexWhere((element) => element == widget.student);

    // Memperbarui objek Student di box
    await box.putAt(
      index,
      Student(
        name: nameController.text,
        nim: nimController.text,
        phone: phoneController.text,
        email: emailController.text,
      ),
    );
  }
}
