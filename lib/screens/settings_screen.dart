import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_controller/volume_controller.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const SettingsScreen({Key? key, required this.onThemeChanged})
    : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _volume = 0.5;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    VolumeController.instance.showSystemUI = true;
    _getVolume();
    _loadThemePreference();
  }

  Future<void> _getVolume() async {
    double volume = await VolumeController.instance.getVolume();
    setState(() {
      _volume = volume;
    });
  }

  void _setVolume(double volume) {
    VolumeController.instance.setVolume(volume);
    setState(() {
      _volume = volume;
    });
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  void _toggleDarkMode(bool isDarkMode) async {
    setState(() {
      _isDarkMode = isDarkMode;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    widget.onThemeChanged(isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.settings, size: 24),
            SizedBox(width: 8),
            Text(
              'Cài đặt chung',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(Icons.volume_up, 'Âm lượng ứng dụng'),
          const SizedBox(height: 8),
          Slider(
            min: 0.0,
            max: 1.0,
            divisions: 10,
            value: _volume,
            label: '${(_volume * 100).round()}%',
            onChanged: _setVolume,
            activeColor: Colors.deepPurpleAccent,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Âm lượng hiện tại: ${(_volume * 100).round()}%',
              style: TextStyle(color: textColor),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(thickness: 1),
          const SizedBox(height: 24),
          _buildSectionTitle(Icons.nightlight_round, 'Tuỳ biến giao diện'),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Chế độ tối'),
            secondary: const Icon(Icons.dark_mode),
            value: _isDarkMode,
            onChanged: _toggleDarkMode,
            contentPadding: const EdgeInsets.only(left: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    final color = Theme.of(context).colorScheme.secondary;
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
