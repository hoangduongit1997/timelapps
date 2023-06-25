import 'package:timelapps/all_imports.dart';

final StateProvider<int> selectedTimerRailIndexProvider =
    StateProvider<int>((StateProviderRef<int> ref) {
  return 0;
});

// This navigationrail holds multiple options for the user to select.
// The user can select themeMode, themeColor, circleColor, font, minutes/
// seconds and show timer or not. All values are stored in their respective
// Riverpod providers.
NavigationRail buildTimerNavigationRail(
  BuildContext context,
  WidgetRef ref,
) {
  return NavigationRail(
    selectedIndex: ref.watch(selectedTimerRailIndexProvider),
    onDestinationSelected: (int index) async {
      ref.read(selectedTimerRailIndexProvider.notifier).state = index;
      if (index == 0) {
        ref.read(isThemeLightProvider.notifier).state =
            !ref.watch(isThemeLightProvider);
      } else if (index == 1) {
        ref.read(isThemeGreenProvider.notifier).state =
            !ref.watch(isThemeGreenProvider);
      } else if (index == 2) {
        ref.read(isColorRedProvider.notifier).state =
            !ref.watch(isColorRedProvider);
      } else if (index == 3) {
        ref.read(isFontQuestrialProvider.notifier).state =
            !ref.watch(isFontQuestrialProvider);
      } else if (index == 4) {
        ref.read(isMinutesShownProvider.notifier).state =
            !ref.watch(isMinutesShownProvider);
      } else if (index == 5) {
        ref.read(isTimeShownProvider.notifier).state =
            !ref.watch(isTimeShownProvider);
      } else if (index == 6) {
        await showModalBottomSheet<AlertDialog>(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Other options',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.globe),
                    title: const Text('Language'),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Other languages coming soon!'),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {},
                        ),
                      ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.circleInfo),
                    title: const Text('About'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (BuildContext context) {
                            return const AboutScreen();
                          },
                        ),
                      );
                    },
                  ),
                ],
              );
            });
      }
    },
    labelType: NavigationRailLabelType.all,
    destinations: <NavigationRailDestination>[
      NavigationRailDestination(
        icon: ref.watch(isThemeLightProvider)
            ? const Icon(FontAwesomeIcons.sun)
            : const Icon(FontAwesomeIcons.moon),
        label: const Text('Mode'),
      ),
      NavigationRailDestination(
        icon: ref.watch(isThemeGreenProvider)
            ? const Icon(FontAwesomeIcons.tree)
            : const Icon(FontAwesomeIcons.wineGlass),
        label: const Text('Theme'),
      ),
      NavigationRailDestination(
        icon: ref.watch(isColorRedProvider)
            ? const Icon(FontAwesomeIcons.solidHeart)
            : const Icon(FontAwesomeIcons.leaf),
        label: const Text('Color'),
      ),
      NavigationRailDestination(
        icon: ref.watch(isFontQuestrialProvider)
            ? const Icon(FontAwesomeIcons.quora)
            : const Icon(FontAwesomeIcons.bold),
        label: const Text('Font'),
      ),
      NavigationRailDestination(
        icon: ref.watch(isMinutesShownProvider)
            ? const Icon(FontAwesomeIcons.m)
            : const Icon(FontAwesomeIcons.s),
        label: const Text('Duration'),
      ),
      NavigationRailDestination(
        icon: ref.watch(isTimeShownProvider)
            ? const Icon(FontAwesomeIcons.check)
            : const Icon(FontAwesomeIcons.xmark),
        label: const Text('Timer'),
      ),
      const NavigationRailDestination(
        icon: Icon(FontAwesomeIcons.gear),
        label: Text('Other'),
      ),
    ],
  );
}