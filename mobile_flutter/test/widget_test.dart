import 'package:flutter_test/flutter_test.dart';
import 'package:misinfoguard/main.dart';

void main() {
  testWidgets('App renders main screen with tab bar', (WidgetTester tester) async {
    await tester.pumpWidget(const MisinfoGuardApp());
    expect(find.text('MisinfoGuard'), findsOneWidget);
    expect(find.text('Feed'), findsOneWidget);
    expect(find.text('Analyze'), findsOneWidget);
    expect(find.text('Insights'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Tab navigation switches views', (WidgetTester tester) async {
    await tester.pumpWidget(const MisinfoGuardApp());
    await tester.tap(find.text('Settings'));
    await tester.pump();
    expect(find.text('Configuration'), findsOneWidget);
  });
}
