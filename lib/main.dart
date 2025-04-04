import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music_app/screens/splash_screen.dart';
import 'blocs/auth/auth_cubit.dart';
import 'blocs/favorite/favorite_bloc.dart';
import 'blocs/song/song_bloc.dart';
import 'blocs/player/player_bloc.dart';
import 'models/song_model.dart';
import 'repositories/song_repository.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SongRepository songRepository = SongRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SongBloc(songRepository)..add(FetchSongs()),
        ),
        BlocProvider<PlayerBloc>(
          create: (_) => PlayerBloc([]),
        ),
        BlocProvider<FavoriteBloc>(
          create: (context) => FavoriteBloc(
            BlocProvider.of<PlayerBloc>(context),
          ),
        ),
        BlocProvider(create: (_) => AuthCubit(FirebaseAuth.instance)),
      ],
      child: MaterialApp(
        title: 'Music Player',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SplashScreen(),
      ),
    );
  }
}
class HomeWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        if (state is SongLoaded) {
          final List<Song> songs = state.songs;
          // ✅ Load danh sách bài hát vào PlayerBloc
          context.read<PlayerBloc>().add(PlayerLoadSong(songs));
          return HomeScreen();
        }
        if (state is SongError) {
          return Scaffold(body: Center(child: Text('Error loading songs')));
        }

        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}