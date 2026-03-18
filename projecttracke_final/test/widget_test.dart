import 'package:flutter_test/flutter_test.dart';
import 'package:projecttracke/main.dart';

void main() {
  testWidgets('App arranca correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const ProjectTrackerApp());
    expect(find.text('Mis Proyectos'), findsOneWidget);
  });
}
