import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  double _volume = 0.5;
  double _balance = 0.0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _audioPlayer.setVolume(_volume);
    _audioPlayer.setBalance(_balance);
  }

  void _updateVolume(double volume) {
    setState(() {
      _volume = volume;
    });
    _audioPlayer.setVolume(_volume);
  }

  void _updateBalance(double balance) {
    setState(() {
      _balance = balance;
    });
    _audioPlayer.setBalance(_balance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Volume', style: TextStyle(fontSize: 18)),
            Slider(
              value: _volume,
              onChanged: _updateVolume,
              min: 0,
              max: 1,
              divisions: 10,
              label: '${(_volume * 100).round()}%',
            ),
            SizedBox(height: 20),
            Text('Balance (Left - Right)', style: TextStyle(fontSize: 18)),
            Slider(
              value: _balance,
              onChanged: _updateBalance,
              min: -1,
              max: 1,
              divisions: 20,
              label: _balance < 0
                  ? 'Left ${(_balance * -100).toStringAsFixed(0)}%'
                  : _balance > 0
                  ? 'Right ${(_balance * 100).toStringAsFixed(0)}%'
                  : 'Center',
            ),
          ],
        ),
      ),
    );
  }
}