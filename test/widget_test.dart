import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Certifique-se de que o caminho está correto para o seu arquivo main.dart

import 'package:consulta_reservas/main.dart'; // Certifique-se de que o caminho esteja correto

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // 1. Construa o widget do app e realize o pump
    await tester.pumpWidget(const MyApp()); // 'const' se o widget for imutável

    // 2. Verifique se o contador começa em 0
    expect(find.text('0'), findsOneWidget); // Verifica se '0' está na tela
    expect(find.text('1'), findsNothing); // Verifica se '1' não está na tela

    // 3. Toque no ícone '+' e faça o pump novamente
    await tester.tap(find.byIcon(Icons.add)); // Encontra o ícone e faz o toque
    await tester.pump(); // Atualiza a interface após a interação

    // 4. Verifique se o contador foi incrementado
    expect(find.text('0'), findsNothing); // Verifica que '0' não está mais na tela
    expect(find.text('1'), findsOneWidget); // Verifica se '1' agora está na tela
  });

  testWidgets('Navegação para a página de reservas', (WidgetTester tester) async {
    // 1. Construa o widget do app e realize o pump
    await tester.pumpWidget(const MyApp()); // 'const' se o widget for imutável

    // 2. Verifique se o botão de navegação está presente
    expect(find.text('Ir para Reservas'), findsOneWidget);

    // 3. Toque no botão 'Ir para Reservas'
    await tester.tap(find.text('Ir para Reservas'));
    await tester.pumpAndSettle(); // Aguarda a navegação e animações

    // 4. Verifique se a página de reservas foi carregada
    expect(find.text('Consulta de Reservas'), findsOneWidget);
  });
}
