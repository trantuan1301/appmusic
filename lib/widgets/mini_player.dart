import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/player_screen.dart';
import '../../blocs/player/player_bloc.dart';

class MiniPlayer extends StatelessWidget {
  MiniPlayer({super.key, required this.onSongTap});
  final VoidCallback onSongTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state is PlayerPlaying || state is PlayerPaused) {
          final song =
              state is PlayerPlaying
                  ? state.song
                  : (state as PlayerPaused).song;
          final isPlaying = state is PlayerPlaying;
          final isShuffling =
              state is PlayerPlaying ? state.isShuffling : false;
          final speed = state is PlayerPlaying ? state.speed : 1.0;
          final position =
              state is PlayerPlaying ? state.position : Duration.zero;
          final duration =
              state is PlayerPlaying ? state.duration : Duration.zero;
          final playerBloc = BlocProvider.of<PlayerBloc>(context);
          final audioPlayer = playerBloc.audioPlayer;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SongDetailScreen()),
              );
            },
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: Colors.blueGrey[100],
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      height: 80,
                      child: Row(
                        children: [
                          Image.network(
                            song.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10),
                          Expanded(child: Text(song.title)),
                          IconButton(
                            icon: Icon(Icons.skip_previous),
                            onPressed: () {
                              context.read<PlayerBloc>().add(PreviousSong());
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                            onPressed: () {
                              if (isPlaying) {
                                context.read<PlayerBloc>().add(PauseSong(song));
                              } else {
                                context.read<PlayerBloc>().add(
                                  ResumeSong(song),
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.skip_next),
                            onPressed: () {
                              context.read<PlayerBloc>().add(NextSong());
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              isShuffling ? Icons.shuffle_on : Icons.shuffle,
                            ),
                            onPressed: () {
                              context.read<PlayerBloc>().add(ToggleShuffle());
                            },
                          ),
                          PopupMenuButton<double>(
                            icon: Icon(Icons.speed),
                            onSelected: (value) {
                              context.read<PlayerBloc>().add(
                                ChangeSpeed(value),
                              );
                            },
                            itemBuilder:
                                (_) => [
                                  PopupMenuItem(
                                    child: Text('0.5x'),
                                    value: 0.5,
                                  ),
                                  PopupMenuItem(child: Text('1x'), value: 1.0),
                                  PopupMenuItem(
                                    child: Text('1.5x'),
                                    value: 1.5,
                                  ),
                                  PopupMenuItem(child: Text('2x'), value: 2.0),
                                ],
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<Duration>(
                      stream: audioPlayer.positionStream,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        final duration = audioPlayer.duration ?? Duration.zero;

                        String formatTime(Duration time) {
                          String twoDigits(int n) =>
                              n.toString().padLeft(2, '0');
                          final minutes = twoDigits(
                            time.inMinutes.remainder(60),
                          );
                          final seconds = twoDigits(
                            time.inSeconds.remainder(60),
                          );
                          return "$minutes:$seconds";
                        }

                        return Column(
                          children: [
                            Slider(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              min: 0,
                              max: duration.inSeconds.toDouble(),
                              value:
                                  position.inSeconds
                                      .clamp(0, duration.inSeconds)
                                      .toDouble(),
                              onChanged: (value) {
                                context.read<PlayerBloc>().add(
                                  SeekSong(Duration(seconds: value.toInt())),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            SizedBox(height: 30),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                Positioned(
                  right: 8,
                  top: -8,
                  child: Container(
                    child: IconButton(
                      onPressed: () {
                        onSongTap();
                        context.read<PlayerBloc>().add(PauseSong(song));
                      },
                      icon: Icon(Icons.close),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
