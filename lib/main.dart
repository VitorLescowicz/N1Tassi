import 'package:flutter/material.dart';

void main() {
  runApp(ShoppingListApp());
}

class ShoppingListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      theme: ThemeData(
        primaryColor: Color(0xFFF5A489), // Cor laranja da paleta
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Color(0xFFEF8184), // Cor vermelha da paleta
        ),
        scaffoldBackgroundColor: Color(0xFFEFE2BF), // Cor bege da paleta
      ),
      home: ShoppingListScreen(),
    );
  }
}

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<Map<String, String>> shoppingList = [];

  final TextEditingController _itemController = TextEditingController();
  String _selectedCategory = 'Alimentos';

  // Função para adicionar um item à lista
  void _addItemToList(String item, String category) {
    setState(() {
      shoppingList.add({'item': item, 'categoria': category});
    });
  }

  // Exibir o diálogo para adicionar um novo item
  Future<void> _showAddItemDialog(BuildContext context) async {
    _itemController.clear(); // Limpa o campo de texto

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // O usuário precisa clicar no botão
      builder: (BuildContext context) {
        String newItem = '';
        String newCategory = _selectedCategory;

        return AlertDialog(
          title: Text('Adicionar Item'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _itemController,
                    decoration: InputDecoration(labelText: 'Nome do item'),
                  ),
                  DropdownButton<String>(
                    value: newCategory,
                    items: ['Alimentos', 'Higiene', 'Bebidas']
                        .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        newCategory = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
            TextButton(
              child: Text('Adicionar'),
              onPressed: () {
                if (_itemController.text.isNotEmpty) {
                  _addItemToList(_itemController.text, newCategory);
                  Navigator.of(context).pop(); // Fecha o diálogo após adicionar
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: shoppingList.length,
              itemBuilder: (context, index) {
                return Card(
                  color: shoppingList[index]['categoria'] == 'Alimentos'
                      ? Color(0xFFF5A489) // Cor laranja para Alimentos
                      : shoppingList[index]['categoria'] == 'Higiene'
                      ? Color(0xFFA76378) // Cor roxa para Higiene
                      : Color(0xFFA8C896), // Cor verde para Bebidas
                  child: ListTile(
                    title: Text(shoppingList[index]['item']!),
                    subtitle: Text(shoppingList[index]['categoria']!),
                    trailing: IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        setState(() {
                          shoppingList.removeAt(index); // Remove o item
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.secondary, // Cor vermelha
      ),
    );
  }
}
