import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TacheScreen extends StatefulWidget {
  const TacheScreen({super.key});

  @override
  _TacheScreenState createState() => _TacheScreenState();
}

class _TacheScreenState extends State<TacheScreen> {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();

  TimeOfDay? _selectedStartTime;
  DateTime? _selectedStartDate;
  TimeOfDay? _selectedEndTime;
  DateTime? _selectedEndDate;

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          _selectedStartTime = pickedTime;
        } else {
          _selectedEndTime = pickedTime;
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _selectedStartDate = pickedDate;
        } else {
          _selectedEndDate = pickedDate;
        }
      });
    }
  }

  Future<void> _ajouterTache() async {
    if (_titreController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _categorieController.text.isEmpty ||
        _selectedStartTime == null ||
        _selectedStartDate == null ||
        _selectedEndTime == null ||
        _selectedEndDate == null) {
      _showMessage("Veuillez remplir tous les champs.");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('taches').add({
        'titre': _titreController.text,
        'description': _descriptionController.text,
        'categorie': _categorieController.text,
        'date_debut': DateFormat('yyyy-MM-dd').format(_selectedStartDate!),
        'heure_debut': _selectedStartTime!.format(context),
        'date_fin': DateFormat('yyyy-MM-dd').format(_selectedEndDate!),
        'heure_fin': _selectedEndTime!.format(context),
        'statut': 'En cours',
        'cree_le': Timestamp.now(),
      });

      _showMessage("Tâche ajoutée avec succès !");
      _clearFields();
    } catch (e) {
      _showMessage("Erreur lors de l'ajout de la tâche : $e");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _clearFields() {
    _titreController.clear();
    _descriptionController.clear();
    _categorieController.clear();
    setState(() {
      _selectedStartTime = null;
      _selectedStartDate = null;
      _selectedEndTime = null;
      _selectedEndDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter Tache'),
        backgroundColor: const Color(0xFF491B6D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ajouter Tache",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTextField(_titreController, "Tache"),
              const SizedBox(height: 12),
              _buildTextField(_descriptionController, "Description"),
              const SizedBox(height: 12),
              _buildTextField(_categorieController, "Catégorie"),
              const SizedBox(height: 20),
              const Text("Date de début",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              _buildDateTimeRow(context, isStart: true),
              const SizedBox(height: 20),
              const Text("Date de fin",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              _buildDateTimeRow(context, isStart: false),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _ajouterTache,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    "Ajouter Tache",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDateTimeRow(BuildContext context, {required bool isStart}) {
    return Row(
      children: [
        IconButton(
          onPressed: () => _selectTime(context, isStart),
          icon: const Icon(Icons.access_time, color: Colors.deepPurple),
        ),
        Text(
          isStart && _selectedStartTime != null
              ? _selectedStartTime!.format(context)
              : !isStart && _selectedEndTime != null
                  ? _selectedEndTime!.format(context)
                  : "09:30",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => _selectDate(context, isStart),
          icon: const Icon(Icons.calendar_today, color: Colors.deepPurple),
        ),
        Text(
          isStart && _selectedStartDate != null
              ? DateFormat('EEE dd, MMMM, yyyy').format(_selectedStartDate!)
              : !isStart && _selectedEndDate != null
                  ? DateFormat('EEE dd, MMMM, yyyy').format(_selectedEndDate!)
                  : "${DateTime.now()}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
