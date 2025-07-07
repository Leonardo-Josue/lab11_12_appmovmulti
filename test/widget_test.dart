import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_12/main.dart';  // Asegúrate de que el nombre del import sea correcto para tu proyecto
import 'package:flutter/cupertino.dart';

void main() {
  testWidgets('Profile screen allows date selection', (WidgetTester tester) async {
    // Construir la aplicación y lanzar el frame.
    await tester.pumpWidget(const MyApp());

    // Ingresar las credenciales y navegar al MenuScreen.
    await tester.enterText(find.byType(TextField).at(0), 'test@domain.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Navegar a la pantalla de Profile.
    await tester.tap(find.text('👤 Profile'));
    await tester.pump();

    // Verificar que la pantalla de perfil se muestra.
    expect(find.text('Perfil'), findsOneWidget);

    // Simular un tap en el ícono del calendario para seleccionar una fecha.
    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();  // Usar pumpAndSettle para asegurarse de que la transición haya terminado

    // Verificar que el popup de fecha aparece (específicamente verificamos que el CupertinoDatePicker esté presente).
    expect(find.byType(CupertinoDatePicker), findsOneWidget);
  });
}
