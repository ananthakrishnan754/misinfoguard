import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' hide GlassCard, GlassContainer;
import 'theme/monochrome_glass.dart';
import 'components/liquid_tab_bar.dart';
import 'components/glass_card.dart';
import 'views/feed_view.dart';
import 'views/detail_view.dart';
import 'views/dashboard_view.dart';
import 'views/settings_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();
  runApp(LiquidGlassWidgets.wrap(
    child: const MisinfoGuardApp(),
    adaptiveQuality: true,
    theme: misinfoGuardGlassTheme,
  ));
}

class MisinfoGuardApp extends StatefulWidget {
  const MisinfoGuardApp({super.key});

  @override
  State<MisinfoGuardApp> createState() => _MisinfoGuardAppState();
}

class _MisinfoGuardAppState extends State<MisinfoGuardApp> {
  bool _isDark = false;

  void _toggleTheme() {
    setState(() => _isDark = !_isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MisinfoGuard',
      debugShowCheckedModeBanner: false,
      theme: MGTheme.lightTheme,
      darkTheme: MGTheme.darkTheme,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: MainScreen(onThemeToggle: _toggleTheme, isDark: _isDark),
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final post = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => DetailView(post: post),
          );
        }
        return null;
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDark;

  const MainScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDark,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TabItem _selectedTab = TabItem.feed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: LiquidTabBar(
        selectedTab: _selectedTab,
        onTabSelected: (tab) => setState(() => _selectedTab = tab),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedTab) {
      case TabItem.feed:
        return const FeedView();
      case TabItem.analyze:
        return _buildAnalyzeView();
      case TabItem.insights:
        return const DashboardView();
      case TabItem.settings:
        return SettingsView(
          onThemeToggle: widget.onThemeToggle,
          isDark: widget.isDark,
        );
    }
  }

  Widget _buildAnalyzeView() {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Analyze')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(HIGSpacing.md),
          child: GlassCard(
            title: 'Manual Analysis',
            subtitle: 'Paste text or URL to analyze any content',
            icon: Icons.search,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Paste article text or URL...',
                    hintStyle: TextStyle(
                      color: dark ? DarkColors.tertiaryLabel : LightColors.tertiaryLabel,
                    ),
                    filled: true,
                    fillColor: dark ? DarkColors.glassBg : LightColors.glassBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: dark ? DarkColors.glassBorder : LightColors.glassBorder,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  maxLines: 5,
                  style: TextStyle(
                    color: dark ? DarkColors.label : LightColors.label,
                  ),
                ),
                const SizedBox(height: HIGSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Analysis queued. Check the Feed for results.')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dark ? DarkColors.primary : LightColors.primary,
                      foregroundColor: dark ? DarkColors.background : LightColors.background,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Analyze'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
