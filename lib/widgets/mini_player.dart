import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/player_screen.dart';
import '../../blocs/player/player_bloc.dart';

class MiniPlayer extends StatelessWidget {
  final VoidCallback onSongTap;

  const MiniPlayer({Key? key, required this.onSongTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state is PlayerPlaying || state is PlayerPaused) {
          final song =
              state is PlayerPlaying
                  ? state.song
                  : (state as PlayerPaused).song;
          final isPlaying = state is PlayerPlaying;
          final playerBloc = BlocProvider.of<PlayerBloc>(context);
          final audioPlayer = playerBloc.audioPlayer;

          return GestureDetector(
            onTap: () {
              onSongTap();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SongDetailScreen()),
              ).then((_) => onSongTap());
            },
            child: Stack(
              children: [
                Container(
                  height: 80,
                  color: isDarkMode ? Colors.white30 : Colors.blueGrey[50],
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Image.network(
                        song.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          song.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.skip_previous,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        onPressed: () {
                          context.read<PlayerBloc>().add(PreviousSong());
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        onPressed: () {
                          if (isPlaying) {
                            context.read<PlayerBloc>().add(PauseSong(song));
                          } else {
                            context.read<PlayerBloc>().add(ResumeSong(song));
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.skip_next,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        onPressed: () {
                          context.read<PlayerBloc>().add(NextSong());
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: StreamBuilder<Duration>(
                    stream: audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration = audioPlayer.duration ?? Duration.zero;
                      final progress =
                          duration.inMilliseconds == 0
                              ? 0.0
                              : position.inMilliseconds /
                                  duration.inMilliseconds;

                      return LinearProgressIndicator(
                        value: progress,
                        minHeight: 2,
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.secondary,
                        ),
                      );
                    },
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
