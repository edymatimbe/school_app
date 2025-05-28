import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerTextField extends StatefulWidget {
  const DatePickerTextField({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DatePickerTextFieldState createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<DatePickerTextField> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'), // opcional
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _dateController,
      readOnly: true, // impede o teclado de aparecer
      decoration: InputDecoration(
        icon: Icon(Icons.calendar_today),
        labelText: "Data de Nascimento",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onTap: () => _selectDate(context),
    );
  }
}
