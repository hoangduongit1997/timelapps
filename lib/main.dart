import 'dart:async';

import 'package:timelapps/all_imports.dart';
import 'package:timelapps/responsive_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MainEntry()));
}

class MainEntry extends ConsumerWidget {
  const MainEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Timelapps',
      theme: ref.watch(themeLightProvider),
      darkTheme: ref.watch(themeDarkProvider),
      themeMode: ref.watch(themeModeProvider),
      home: const ResponsiveLayout(),
    );
  }
}
