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
    VolumeController.instance.showSystemUI = true; // Hiển thị UI hệ thống
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
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt chung')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // kéo dài chiều ngang
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Âm lượng ứng dụng',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Slider(
              min: 0.0,
              max: 1.0,
              divisions: 10,
              value: _volume,
              label: (_volume * 100).round().toString(),
              onChanged: (value) => _setVolume(value),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Âm lượng hiện tại: ${(_volume * 100).round()}%',
              ),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tuỳ biến giao diện',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SwitchListTile(
              title: const Text('Chế độ tối', textAlign: TextAlign.left),
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
              contentPadding: const EdgeInsets.only(left: 0),
            ),
          ],
        ),
      ),
    );
  }
}
