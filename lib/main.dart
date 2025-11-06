import 'package:flutter/material.dart';
import 'package:sandwich_shop/repositories/order_repository.dart';

// Fallback styles in case `app_styles.dart` is empty during development.
// If you later define these in `app_styles.dart`, you can remove these.
const TextStyle heading1 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const TextStyle normalText = TextStyle(fontSize: 16);

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
  final String? label;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor = Colors.transparent,
    this.label,
  });
  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      child: Icon(icon),
    );

    // If a label was provided, expose it as a tooltip for accessibility
    if (label != null && label!.isNotEmpty) {
      return Tooltip(message: label!, child: button);
    }

    return button;
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
  late final OrderRepository _orderRepository;
  final TextEditingController _notesController = TextEditingController();
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;

  @override
  void initState() {
    super.initState();
    _orderRepository = OrderRepository(maxQuantity: widget.maxQuantity);
    _notesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  VoidCallback? _getIncreaseCallback() {
    if (_orderRepository.canIncrement) {
      return () => setState(_orderRepository.increment);
    }
    return null;
  }

  VoidCallback? _getDecreaseCallback() {
    if (_orderRepository.canDecrement) {
      return () => setState(_orderRepository.decrement);
    }
    return null;
  }

  void _onSandwichTypeChanged(bool value) {
    setState(() => _isFootlong = value);
  }

  void _onBreadTypeSelected(BreadType? value) {
    if (value != null) {
      setState(() => _selectedBreadType = value);
    }
  }

  List<DropdownMenuEntry<BreadType>> _buildDropdownEntries() {
    List<DropdownMenuEntry<BreadType>> entries = [];
    for (BreadType bread in BreadType.values) {
      DropdownMenuEntry<BreadType> newEntry = DropdownMenuEntry<BreadType>(
        value: bread,
        // Use the enum's displayName so labels are nicely capitalized
        // and show spaces instead of underscores (e.g. "Honey Oat").
        label: bread.displayName,
      );
      entries.add(newEntry);
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    String sandwichType = 'footlong';
    if (!_isFootlong) {
      sandwichType = 'six-inch';
    }

    String noteForDisplay;
    if (_notesController.text.isEmpty) {
      noteForDisplay = 'No notes added.';
    } else {
      noteForDisplay = _notesController.text;
    }

    return Scaffold(
      appBar: AppBar(title: Text('Sandwich Counter', style: heading1)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OrderItemDisplay(
              quantity: _orderRepository.quantity,
              itemType: sandwichType,
              breadType: _selectedBreadType,
              orderNote: noteForDisplay,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('six-inch', style: normalText),
                Switch(value: _isFootlong, onChanged: _onSandwichTypeChanged),
                Text('footlong', style: normalText),
              ],
            ),
            const SizedBox(height: 10),
            DropdownMenu<BreadType>(
              textStyle: normalText,
              initialSelection: _selectedBreadType,
              onSelected: _onBreadTypeSelected,
              dropdownMenuEntries: _buildDropdownEntries(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: TextField(
                key: const Key('notes_textfield'),
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Add a note (e.g., no onions)',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  onPressed: _getIncreaseCallback(),
                  icon: Icons.add,
                  label: 'Add',
                  backgroundColor: Colors.green,
                ),
                const SizedBox(width: 8),
                StyledButton(
                  onPressed: _getDecreaseCallback(),
                  icon: Icons.remove,
                  label: 'Remove',
                  backgroundColor: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;
  final BreadType breadType;
  final String? orderNote;
  final double width;

  const OrderItemDisplay({
    super.key,
    required this.quantity,
    required this.itemType,
    required this.breadType,
    this.orderNote,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$quantity $itemType sandwich(es) on ${breadType.displayName.toLowerCase()} bread:',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text('${'🥪' * quantity}', textAlign: TextAlign.center),
          if (orderNote != null && orderNote!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Note: $orderNote',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}
