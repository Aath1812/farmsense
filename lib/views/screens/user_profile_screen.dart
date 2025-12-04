import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmsense/viewmodels/providers.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _locationController;
  late TextEditingController _landSizeController;

  // Dropdown States
  String? _selectedAgeGroup;
  String? _selectedGender;
  String? _selectedEducation;
  String? _selectedLandUnit;
  String? _selectedSoilType;
  String? _selectedIrrigation;

  // Lists
  final List<String> _ageGroups = ['18-25', '26-40', '41-60', '60+'];
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _educationLevels = ['Primary', 'Secondary', 'Graduate', 'None'];
  final List<String> _landUnits = ['Acres', 'Hectares', 'Gunthas', 'Bigha'];
  final List<String> _soilTypes = ['Black (Kali)', 'Red (Lal)', 'Sandy', 'Clay'];
  final List<String> _irrigationTypes = ['Rain-fed', 'Well', 'Canal', 'Drip/Sprinkler'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _mobileController = TextEditingController();
    _locationController = TextEditingController();
    _landSizeController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _locationController.dispose();
    _landSizeController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'name': _nameController.text,
        'mobile': _mobileController.text,
        'location': _locationController.text,
        'age': _selectedAgeGroup ?? '26-40',
        'gender': _selectedGender ?? 'Male',
        'education': _selectedEducation ?? 'Secondary',
        'land_size': _landSizeController.text,
        'land_unit': _selectedLandUnit ?? 'Acres',
        'soil': _selectedSoilType ?? 'Black (Kali)',
        'irrigation': _selectedIrrigation ?? 'Rain-fed',
      };

      ref.read(userProfileProvider.notifier).updateProfileMap(updatedData);

      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);

    // Sync data if not editing
    if (!_isEditing) {
      _nameController.text = userProfile['name'] ?? '';
      _mobileController.text = userProfile['mobile'] ?? '';
      _locationController.text = userProfile['location'] ?? '';
      _landSizeController.text = userProfile['land_size'] ?? '';

      _selectedAgeGroup = _ageGroups.contains(userProfile['age']) ? userProfile['age'] : _ageGroups[1];
      _selectedGender = _genders.contains(userProfile['gender']) ? userProfile['gender'] : _genders[0];
      _selectedEducation = _educationLevels.contains(userProfile['education']) ? userProfile['education'] : _educationLevels[1];
      _selectedLandUnit = _landUnits.contains(userProfile['land_unit']) ? userProfile['land_unit'] : _landUnits[0];
      _selectedSoilType = _soilTypes.contains(userProfile['soil']) ? userProfile['soil'] : _soilTypes[0];
      _selectedIrrigation = _irrigationTypes.contains(userProfile['irrigation']) ? userProfile['irrigation'] : _irrigationTypes[0];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).primaryColor.withAlpha(30),
                  child: Icon(Icons.person, size: 60, color: Theme.of(context).primaryColor),
                ),
              ),
              const SizedBox(height: 24),

              // Personal Details
              _buildSectionHeader('Personal Details'),
              _buildTextField('Full Name', _nameController, Icons.person),
              const SizedBox(height: 12),
              _buildTextField('Mobile Number', _mobileController, Icons.phone, isNumber: true),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildDropdown('Age', _selectedAgeGroup, _ageGroups, (val) => _selectedAgeGroup = val)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildDropdown('Gender', _selectedGender, _genders, (val) => _selectedGender = val)),
                ],
              ),
              const SizedBox(height: 12),
              _buildDropdown('Education', _selectedEducation, _educationLevels, (val) => _selectedEducation = val),

              const SizedBox(height: 24),

              // Farm Details
              _buildSectionHeader('Farm Details'),
              _buildTextField('Farm Location', _locationController, Icons.location_on),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildTextField('Land Size', _landSizeController, Icons.landscape, isNumber: true)),
                  const SizedBox(width: 12),
                  Expanded(flex: 1, child: _buildDropdown('Unit', _selectedLandUnit, _landUnits, (val) => _selectedLandUnit = val)),
                ],
              ),
              const SizedBox(height: 12),
              _buildDropdown('Soil Type', _selectedSoilType, _soilTypes, (val) => _selectedSoilType = val),
              const SizedBox(height: 12),
              _buildDropdown('Irrigation', _selectedIrrigation, _irrigationTypes, (val) => _selectedIrrigation = val),

              const SizedBox(height: 32),

              if (_isEditing)
                ElevatedButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Profile'),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
          Divider(color: Theme.of(context).primaryColor.withAlpha(50), thickness: 2),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    if (_isEditing) {
      return TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        validator: (value) => value!.isEmpty ? '$label is required' : null,
      );
    } else {
      return _buildReadOnlyField(label, controller.text, icon);
    }
  }

  Widget _buildDropdown(String label, String? currentValue, List<String> items, Function(String?) onChanged) {
    if (_isEditing) {
      return DropdownButtonFormField<String>(
        initialValue: items.contains(currentValue) ? currentValue : null,
        isExpanded: true, // FIX: Prevents overflow by fitting text within width
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis, // FIX: Handles very long text gracefully
            ),
          );
        }).toList(),
        onChanged: (val) {
          setState(() {
            onChanged(val);
          });
        },
      );
    } else {
      return _buildReadOnlyField(label, currentValue ?? 'Not set', Icons.arrow_drop_down_circle_outlined);
    }
  }

  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(80),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 12),
          // FIX: Wrapped Column in Expanded to prevent right overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}