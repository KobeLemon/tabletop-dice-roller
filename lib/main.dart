import "package:flutter/material.dart";

import "package:english_words/english_words.dart";
import 'package:ionicons/ionicons.dart';
import "package:provider/provider.dart";

void main() {
  runApp(const MyApp());
}

// ==================== Start of Overall App Class/State ==================== //
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MyAppState(),
      child: MaterialApp(
        title: "Flutter Codelab",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  WordPair current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  List<WordPair> favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void clearAllFavorites() {
    if (favorites.isNotEmpty) {
      favorites.clear();
    }
  }
  
}
// ==================== End of Overall App Class/State ==================== //

// ==================== Start of Home Page Class/State ==================== //
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
  const MyHomePage({super.key});
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const RollDicePage();
        break;
      case 1:
        page = const FavoritesPage();
        break;
      default:
        throw UnimplementedError("no widget for $selectedIndex");
    }

    return mainLayoutBuilder(page);
  }
// ==================== End of Home Page Class/State ==================== //

// ==================== Start of Main Layout Builder ==================== //
  LayoutBuilder mainLayoutBuilder(Widget page) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        body: Row(
          children: [
            // Main Content
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
        bottomNavigationBar: bottomNavBar()
      );
    });
  }

  // Main Bottom Navigation Bar
  NavigationBar bottomNavBar() {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          selectedIndex = index;
        });
      },
      indicatorColor: Colors.amber,
      selectedIndex: selectedIndex,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Ionicons.home),
          label: 'Home',
        ),
        // NavigationDestination(
        //   icon: Icon(Ionicons.dice),
        //   label: 'Add Dice',
        // ),
        // NavigationDestination(
        //   icon: Icon(Ionicons.add_circle_sharp),
        //   label: 'Add Modifiers',
        // ),
        NavigationDestination(
          icon: Icon(Ionicons.time),
          label: 'Roll History',
        ),
      ],
    );
  }

  // Main NavigationRail
  NavigationRail mainNavRail(BoxConstraints constraints) {
    return NavigationRail(
      extended: constraints.maxWidth >= 600,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text("Home"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.favorite),
          label: Text("Favorites"),
        ),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: (int value) {
        setState(() {
          selectedIndex = value;
        });
      },
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_sharp),
            label: 'Notifications',
          ),
        ],
      );
    //   body: <Widget>[
    //     /// Home page
    //     Card(
    //       shadowColor: Colors.transparent,
    //       margin: const EdgeInsets.all(8.0),
    //       child: SizedBox.expand(
    //         child: Center(
    //           child: Text(
    //             'Home page',
    //             style: theme.textTheme.titleLarge,
    //           ),
    //         ),
    //       ),
    //     ),

    //     /// Notifications page
    //     const Padding(
    //       padding: EdgeInsets.all(8.0),
    //       child: Column(
    //         children: <Widget>[
    //           Card(
    //             child: ListTile(
    //               leading: Icon(Icons.notifications_sharp),
    //               title: Text('Notification 1'),
    //               subtitle: Text('This is a notification'),
    //             ),
    //           ),
    //           Card(
    //             child: ListTile(
    //               leading: Icon(Icons.notifications_sharp),
    //               title: Text('Notification 2'),
    //               subtitle: Text('This is a notification'),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),

    //     /// Messages page
    //     ListView.builder(
    //       reverse: true,
    //       itemCount: 2,
    //       itemBuilder: (BuildContext context, int index) {
    //         if (index == 0) {
    //           return Align(
    //             alignment: Alignment.centerRight,
    //             child: Container(
    //               margin: const EdgeInsets.all(8.0),
    //               padding: const EdgeInsets.all(8.0),
    //               decoration: BoxDecoration(
    //                 color: theme.colorScheme.primary,
    //                 borderRadius: BorderRadius.circular(8.0),
    //               ),
    //               child: Text(
    //                 'Hello',
    //                 style: theme.textTheme.bodyLarge!
    //                     .copyWith(color: theme.colorScheme.onPrimary),
    //               ),
    //             ),
    //           );
    //         }
    //         return Align(
    //           alignment: Alignment.centerLeft,
    //           child: Container(
    //             margin: const EdgeInsets.all(8.0),
    //             padding: const EdgeInsets.all(8.0),
    //             decoration: BoxDecoration(
    //               color: theme.colorScheme.primary,
    //               borderRadius: BorderRadius.circular(8.0),
    //             ),
    //             child: Text(
    //               'Hi!',
    //               style: theme.textTheme.bodyLarge!
    //                   .copyWith(color: theme.colorScheme.onPrimary),
    //             ),
    //           ),
    //         );
    //       },
    //     ),
    //   ][currentPageIndex],
    // );
  }
}


// ==================== End of Main Layout Builder ==================== //

// ==================== Start of App Pages ==================== //

// ============= Start of Home Generator Page ============= //
class RollDicePage extends StatelessWidget {
  const RollDicePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    MyAppState appState = context.watch<MyAppState>();
    WordPair pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WordPairCard(pair: pair),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ToggleFavsBtn(appState: appState, icon: icon),
              const SizedBox(width: 10),
              NextWordPairBtn(appState: appState),
            ],
          ),
          ClearFavsBtn(appState: appState),
        ],
      ),
    );
  }
}
// ============= End of Home Generator Page ============= //

// ============= Start of Favorites Page ============= //
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    MyAppState appState = context.watch<MyAppState>();
    List<WordPair> favorites = appState.favorites;
    ThemeData theme = Theme.of(context);
    TextStyle titleStyle = theme.textTheme.displayMedium!;
    TextStyle wordPairStyle = theme.textTheme.displaySmall!
        .copyWith(color: theme.colorScheme.onPrimary);

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text("No favorites yet", style: titleStyle,),
      );
    }
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(8), 
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.colorScheme.primary, width: 5)),
            ),
            child: Center(
              child: Text("Favorites", style: titleStyle,)
            ),
          ),
          const SizedBox(height: 30,),
          // ClearFavsBtn(appState: appState),
          // SizedBox(height: 30,),
          for (WordPair fav in favorites) ...[
            Card(
              color: theme.colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    fav.asLowerCase,
                    style: wordPairStyle,
                    semanticsLabel: "${fav.first} ${fav.second}")
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}
// ============= Start of Favorites Page ============= //

// ==================== End of App Pages ==================== //


// ==================== Start of App Items ==================== //
class WordPairCard extends StatelessWidget {
  const WordPairCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  // WordPairCard Widget
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase,
            style: style, semanticsLabel: "${pair.first} ${pair.second}"),
      ),
    );
  }
}

class NextWordPairBtn extends StatelessWidget {
  const NextWordPairBtn({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        appState.getNext();
      },
      child: const Text("Next"),
    );
  }
}

class ToggleFavsBtn extends StatelessWidget {
  const ToggleFavsBtn({
    super.key,
    required this.appState,
    required this.icon,
  });

  final MyAppState appState;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        appState.toggleFavorite();
      },
      icon: Icon(icon),
      label: const Text("Like"),
    );
  }
}
class ClearFavsBtn extends StatelessWidget {
  const ClearFavsBtn({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
      appState.clearAllFavorites();
    }, 
    icon: const Icon(Icons.delete),
    label: const Text("Clear All Favorites"));
  }
}
// ==================== End of App Items ==================== //
