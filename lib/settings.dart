import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  String _fullName = '';
  String _phoneNumber = '';
  String _dob = '';
  String _selectedLanguage = 'English';
  bool _cameraPermission = false;
  bool _microphonePermission = false;
  bool _locationPermission = false;

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Swahili',
    'Arabic'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final microphoneStatus = await Permission.microphone.status;
    final locationStatus = await Permission.location.status;

    if (mounted) {
      setState(() {
        _cameraPermission = cameraStatus.isGranted;
        _microphonePermission = microphoneStatus.isGranted;
        _locationPermission = locationStatus.isGranted;
      });
    }
  }

  Future<void> _loadUserData() async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        final data = await supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();

        if (mounted) {
          setState(() {
            _fullName = data['full_name'] ?? '';
            _phoneNumber = data['phone'] ?? '';
            _dob = data['dob'] ?? '';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading user data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E1BE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5E1BE),
        elevation: 0,
        title: Text(
          "App Settings",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.brown[700],
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.brown[700]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildAccountSettings(context),
          _buildPrivacySettings(context),
          _buildAvatarSettings(context),
          _buildNotificationSettings(context),
          _buildDevicePermissions(context),
          _buildLanguageSettings(context),
          _buildUpdateSettings(context),
        ],
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.person, color: Colors.brown[700]),
      title: Text(
        "Account",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.brown[700],
        ),
      ),
      children: [
        ListTile(
          title: const Text("Full Name"),
          subtitle: Text(_fullName.isNotEmpty ? _fullName : "Not set"),
          trailing: Icon(Icons.edit, color: Colors.brown[400]),
          onTap: () => _showEditDialog("Full Name", _fullName, (value) {
            setState(() => _fullName = value);
            _updateProfileData('full_name', value);
          }),
        ),
        ListTile(
          title: const Text("Phone Number"),
          subtitle: Text(_phoneNumber.isNotEmpty ? _phoneNumber : "Not set"),
          trailing: Icon(Icons.edit, color: Colors.brown[400]),
          onTap: () => _showEditDialog("Phone Number", _phoneNumber, (value) {
            setState(() => _phoneNumber = value);
            _updateProfileData('phone', value);
          }),
        ),
        ListTile(
          title: const Text("Date of Birth"),
          subtitle: Text(_dob.isNotEmpty ? _dob : "Not set"),
          trailing: Icon(Icons.edit, color: Colors.brown[400]),
          onTap: () => _showDatePicker(context),
        ),
      ],
    );
  }

  Widget _buildPrivacySettings(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.lock, color: Colors.brown[700]),
      title: Text(
        "Privacy",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.brown[700],
        ),
      ),
      children: [
        ListTile(
          title: const Text("Change Password"),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.brown[400], size: 16),
          onTap: () => _showChangePasswordDialog(context),
        ),
        ListTile(
          title: const Text("Two-Factor Authentication"),
          trailing: Switch(
            value: false,
            onChanged: (value) {},
            activeColor: Colors.brown,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarSettings(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.image, color: Colors.brown[700]),
      title: Text(
        "Avatar",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.brown[700],
        ),
      ),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.brown[300],
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                ),
                onPressed: () => _showAvatarOptions(context),
                child: const Text("Change Avatar", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDevicePermissions(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.perm_device_info, color: Colors.brown[700]),
      title: Text(
        "Device Permissions",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.brown[700],
        ),
      ),
      children: [
        ListTile(
          leading: Icon(Icons.camera_alt, color: Colors.brown[700]),
          title: const Text("Camera Access"),
          subtitle: const Text("Required for taking photos"),
          trailing: Switch(
            value: _cameraPermission,
            onChanged: (value) => _requestPermission(Permission.camera, value),
            activeColor: Colors.brown,
          ),
        ),
        ListTile(
          leading: Icon(Icons.mic, color: Colors.brown[700]),
          title: const Text("Microphone Access"),
          subtitle: const Text("Required for voice recordings"),
          trailing: Switch(
            value: _microphonePermission,
            onChanged: (value) => _requestPermission(Permission.microphone, value),
            activeColor: Colors.brown,
          ),
        ),
        ListTile(
          leading: Icon(Icons.location_on, color: Colors.brown[700]),
          title: const Text("Location Access"),
          subtitle: const Text("Required for location-based features"),
          trailing: Switch(
            value: _locationPermission,
            onChanged: (value) => _requestPermission(Permission.location, value),
            activeColor: Colors.brown,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSettings(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.language, color: Colors.brown[700]),
      title: Text(
        "App Language",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.brown[700],
        ),
      ),
      children: _languages.map((language) {
        return RadioListTile(
          title: Text(language),
          value: language,
          groupValue: _selectedLanguage,
          activeColor: Colors.brown,
          onChanged: (value) {
            setState(() => _selectedLanguage = value.toString());
          },
        );
      }).toList(),
    );
  }

  Widget _buildNotificationSettings(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.notifications, color: Colors.brown[700]),
      title: Text(
        "Notifications",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.brown[700],
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.brown[400], size: 16),
      onTap: () {},
    );
  }

  Widget _buildUpdateSettings(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.update, color: Colors.brown[700]),
      title: Text(
        "App Updates",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.brown[700],
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.brown[400], size: 16),
      onTap: () {},
    );
  }

  Future<void> _showEditDialog(
      String title, String currentValue, Function(String) onSave) async {
    final controller = TextEditingController(text: currentValue);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $title"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter $title"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.brown)),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: const Text("Save", style: TextStyle(color: Colors.brown)),
          ),
        ],
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.brown,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dob = "${picked.day}/${picked.month}/${picked.year}");
      await _updateProfileData('dob', _dob);
    }
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Current Password"),
            ),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Confirm New Password"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.brown)),
          ),
          TextButton(
            onPressed: () async {
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Passwords don't match")),
                );
                return;
              }
              try {
                await supabase.auth.updateUser(
                  UserAttributes(password: newPasswordController.text),
                );
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password updated successfully")),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error updating password: $e")),
                  );
                }
              }
            },
            child: const Text("Update", style: TextStyle(color: Colors.brown)),
          ),
        ],
      ),
    );
  }

  Future<void> _showAvatarOptions(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Choose from Gallery"),
            onTap: () {
              Navigator.pop(context);
              // Implement gallery picker
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Take a Photo"),
            onTap: () {
              Navigator.pop(context);
              // Implement camera
            },
          ),
          ListTile(
            leading: const Icon(Icons.face),
            title: const Text("Choose Default Avatar"),
            onTap: () {
              Navigator.pop(context);
              // Implement default avatar selector
            },
          ),
        ],
      ),
    );
  }

  Future<void> _requestPermission(Permission permission, bool enable) async {
    if (enable) {
      final status = await permission.request();
      if (mounted) {
        setState(() {
          switch (permission) {
            case Permission.camera:
              _cameraPermission = status.isGranted;
              break;
            case Permission.microphone:
              _microphonePermission = status.isGranted;
              break;
            case Permission.location:
              _locationPermission = status.isGranted;
              break;
            default:
              break;
          }
        });

        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Permission denied")),
          );
        }
      }
    } else {
      if (mounted) {
        setState(() {
          switch (permission) {
            case Permission.camera:
              _cameraPermission = false;
              break;
            case Permission.microphone:
              _microphonePermission = false;
              break;
            case Permission.location:
              _locationPermission = false;
              break;
            default:
              break;
          }
        });
      }

      if (Theme.of(context).platform == TargetPlatform.android) {
        openAppSettings();
      }
    }
  }

  Future<void> _updateProfileData(String field, String value) async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        await supabase
            .from('profiles')
            .update({field: value})
            .eq('id', user.id);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating $field: $e")),
        );
      }
    }
  }
}