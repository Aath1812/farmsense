import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmsense/models/crop_log.dart';
import 'package:farmsense/viewmodels/providers.dart';
import 'package:intl/intl.dart';

class EditLogScreen extends ConsumerStatefulWidget {
  final CropLog cropLog;

  const EditLogScreen({Key? key, required this.cropLog}) : super(key: key);

  @override
  ConsumerState<EditLogScreen> createState() => _EditLogScreenState();
}

class _EditLogScreenState extends ConsumerState<EditLogScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cropTypeController;
  late TextEditingController _dateController;
  late TextEditingController _yieldAmountController;
  late TextEditingController _notesController;

  late String _cropType;
  late DateTime _selectedDate;
  late String _status;
  late double _yieldAmount;
  late String _notes;

  final List<String> _statuses = ['Sown', 'Growing', 'Harvested'];

  @override
  void initState() {
    super.initState();
    _cropType = widget.cropLog.cropType;
    _selectedDate = widget.cropLog.date;
    _status = widget.cropLog.status;
    _yieldAmount = widget.cropLog.yieldAmount;
    _notes = widget.cropLog.notes;

    _cropTypeController = TextEditingController(text: _cropType);
    _dateController = TextEditingController(text: DateFormat('MMM dd, yyyy').format(_selectedDate));
    _yieldAmountController = TextEditingController(text: _yieldAmount.toString());
    _notesController = TextEditingController(text: _notes);
  }

  @override
  void dispose() {
    _cropTypeController.dispose();
    _dateController.dispose();
    _yieldAmountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMM dd, yyyy').format(_selectedDate);
      });
    }
  }

  void _updateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // copyWith will now work because we updated the model
      final updatedLog = widget.cropLog.copyWith(
        cropType: _cropType,
        date: _selectedDate,
        notes: _notes,
        status: _status,
        yieldAmount: _yieldAmount,
      );

      ref.read(cropListProvider.notifier).updateCropLog(updatedLog);
      Navigator.of(context).pop();
    }
  }

  void _deleteCrop() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Crop Log'),
        // Fixed: Removed unnecessary braces inside string interpolation
        content: Text('Are you sure you want to delete $_cropType log?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(cropListProvider.notifier).deleteCropLog(widget.cropLog.id);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Crop Log'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _cropTypeController,
                decoration: const InputDecoration(
                  labelText: 'Crop Name',
                  hintText: 'e.g., Wheat, Corn',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a crop name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cropType = value!;
                },
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      hintText: DateFormat('MMM dd, yyyy').format(_selectedDate),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a date.';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Fixed: Swapped 'value' for 'initialValue' per deprecation warning
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                ),
                items: _statuses.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
                onSaved: (value) {
                  _status = value!;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _yieldAmountController,
                decoration: const InputDecoration(
                  labelText: 'Yield Amount (kg)',
                  hintText: 'e.g., 500.0',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a yield amount.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _yieldAmount = double.parse(value!);
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Any specific observations...',
                ),
                maxLines: 3,
                onSaved: (value) {
                  _notes = value!;
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _updateForm,
                child: const Text('Save Changes'),
              ),
              const SizedBox(height: 16.0),
              OutlinedButton(
                onPressed: _deleteCrop,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(color: Theme.of(context).colorScheme.error),
                ),
                child: const Text('Delete Log'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}