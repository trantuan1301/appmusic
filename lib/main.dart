import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;

  const MyApp({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  // Method to access the state of MyApp from child widgets
  static _MyAppState? of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme(bool isDarkMode) async {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SongBloc(SongRepository())..add(FetchSongs()),
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
        debugShowCheckedModeBanner: false,
        title: 'Music Player',
        theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
        darkTheme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
        themeMode: _themeMode,
        home: SplashScreen(
          onThemeChanged: toggleTheme,
        ),
      ),
    );
  }
}

class HomeWrapper extends StatelessWidget {
  final Function(bool) onThemeChanged;

  const HomeWrapper({Key? key, required this.onThemeChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        if (state is SongLoaded) {
          final List<Song> songs = state.songs;
          // ✅ Load danh sách bài hát vào PlayerBloc
          context.read<PlayerBloc>().add(PlayerLoadSong(songs));
          return HomeScreen(onThemeChanged: onThemeChanged);
        }
        if (state is SongError) {
          return Scaffold(body: Center(child: Text('Error loading songs')));
        }

        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}