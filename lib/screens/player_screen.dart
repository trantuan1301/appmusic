import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/player/player_bloc.dart';

class SongDetailScreen extends StatefulWidget {
  const SongDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SongDetailScreenState createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat(); // Lặp vô tận để xoay liên tục
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Đang phát nhạc',
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 24),
        ),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            )),
      ),
      body: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is PlayerPlaying || state is PlayerPaused) {
            final song = state is PlayerPlaying
                ? state.song
                : (state as PlayerPaused).song;

            final isPlaying = state is PlayerPlaying;
            final isShuffling =
            state is PlayerPlaying ? state.isShuffling : false;
            final speed = state is PlayerPlaying ? state.speed : 1.0;
            final position = state is PlayerPlaying ? state.position : Duration.zero;
            final duration = state is PlayerPlaying ? state.duration : Duration.zero;
            final playerBloc = BlocProvider.of<PlayerBloc>(context);
            final audioPlayer = playerBloc.audioPlayer;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                Image.asset(
                'assets/play_eq1.png',
                width: 100,
                height: 100,),
                  SizedBox(height: 10),
                  // Ảnh tròn và xoay
                  RotationTransition(
                    turns: _rotationController,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade400, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          song.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  // Tên bài hát
                  Text(
                    song.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // Tên ca sĩ
                  Text(
                    song.artist,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 40),

                  StreamBuilder<Duration>(
                    stream: audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration = audioPlayer.duration ?? Duration.zero;

                      String formatTime(Duration time) {
                        String twoDigits(int n) => n.toString().padLeft(2, '0');
                        final minutes = twoDigits(time.inMinutes.remainder(60));
                        final seconds = twoDigits(time.inSeconds.remainder(60));
                        return "$minutes:$seconds";
                      }

                      return Column(
                        children: [
                          Slider(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            min: 0,
                            max: duration.inSeconds.toDouble(),
                            value: position.inSeconds.clamp(0, duration.inSeconds).toDouble(),
                            onChanged: (value) {
                              context.read<PlayerBloc>().add(
                                SeekSong(Duration(seconds: value.toInt())),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatTime(position),
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  formatTime(duration),
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(height: 30,),
                        ],
                      );
                    },
                  ),
                  // Nút Play/Pause
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          iconSize: 32,
                          icon: Icon(isShuffling ? Icons.shuffle_on : Icons.shuffle),
                          onPressed: () {
                            context.read<PlayerBloc>().add(ToggleShuffle());
                          },
                        ),
                        IconButton(
                          iconSize: 64,
                          icon: Icon(Icons.skip_previous),
                          onPressed: () {
                            context.read<PlayerBloc>().add(PreviousSong());
                          },
                        ),
                        IconButton(
                          iconSize: 64,
                          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                          onPressed: () {
                            if (isPlaying) {
                              context.read<PlayerBloc>().add(PauseSong(song));
                              _rotationController.stop();
                            } else {
                              context.read<PlayerBloc>().add(ResumeSong(song));
                              _rotationController.repeat();
                            }
                          },
                        ),
                        IconButton(
                          iconSize: 64,
                          icon: Icon(Icons.skip_next),
                          onPressed: () {
                            context.read<PlayerBloc>().add(NextSong());
                          },
                        ),
                        PopupMenuButton<double>(
                          icon: Icon(Icons.speed, size: 32,),
                          onSelected: (value) {
                            context.read<PlayerBloc>().add(ChangeSpeed(value));
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(child: Text('0.5x'), value: 0.5),
                            PopupMenuItem(child: Text('1x'), value: 1.0),
                            PopupMenuItem(child: Text('1.5x'), value: 1.5),
                            PopupMenuItem(child: Text('2x'), value: 2.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}