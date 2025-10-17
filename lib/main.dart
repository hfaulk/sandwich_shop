import 'package:flutter/material.dart';

enum BreadType {
  white('White'),
  wheat('Wheat'),
  italian('Italian'),
  honey_oat('Honey Oat');

  const BreadType(this.displayName);
  final String displayName;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const OrderScreen(maxQuantity: 5),
    );
  }
}

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Color? backgroundColor;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      child: Icon(icon),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  String _note = '';
  String _selectedSandwichType = 'Footlong';
  BreadType _selectedBreadType = BreadType.white;
  final TextEditingController _noteController = TextEditingController();

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sandwich Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(
                  value: 'Footlong',
                  label: Text('Footlong'),
                ),
                ButtonSegment<String>(
                  value: 'Six-inch',
                  label: Text('Six-inch'),
                ),
              ],
              selected: {_selectedSandwichType},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedSandwichType = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 15),
            SegmentedButton<BreadType>(
              segments: const [
                ButtonSegment<BreadType>(
                  value: BreadType.white,
                  label: Text('White'),
                ),
                ButtonSegment<BreadType>(
                  value: BreadType.wheat,
                  label: Text('Wheat'),
                ),
                ButtonSegment<BreadType>(
                  value: BreadType.italian,
                  label: Text('Italian'),
                ),
                ButtonSegment<BreadType>(
                  value: BreadType.honey_oat,
                  label: Text('Honey Oat'),
                ),
              ],
              selected: {_selectedBreadType},
              onSelectionChanged: (Set<BreadType> newSelection) {
                setState(() {
                  _selectedBreadType = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 10),
            OrderItemDisplay(
              _quantity,
              _selectedSandwichType,
              _selectedBreadType,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Special requests',
                  hintText: 'e.g., no onions, extra pickles',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _note = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  onPressed: _quantity < widget.maxQuantity
                      ? _increaseQuantity
                      : null,
                  icon: Icons.add,
                ),
                StyledButton(
                  onPressed: _quantity > 0 ? _decreaseQuantity : null,
                  icon: Icons.remove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}

class OrderItemDisplay extends StatelessWidget {
  final String itemType;
  final int quantity;
  final BreadType breadType;
  final double width;

  const OrderItemDisplay(
    this.quantity,
    this.itemType,
    this.breadType, {
    super.key,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '$quantity $itemType sandwich(es) on ${breadType.displayName.toLowerCase()} bread: ${'🥪' * quantity}',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
