import 'package:flutter/material.dart';
import '../../../../core/utils/order_utils.dart';

class OrderByModal extends StatefulWidget {
  final String selectedAttribute;
  final String selectedDirection;
  final Function(String, String) onOrderSelected;

  const OrderByModal({
    super.key,
    required this.selectedAttribute,
    required this.selectedDirection,
    required this.onOrderSelected,
  });

  @override
  _OrderByModalState createState() => _OrderByModalState();
}

class _OrderByModalState extends State<OrderByModal> {
  late String currentAttribute;
  late String currentDirection;

  @override
  void initState() {
    super.initState();
    currentAttribute = widget.selectedAttribute.isEmpty ? pokemonOrderList[0] : widget.selectedAttribute;
    currentDirection = widget.selectedDirection.isEmpty ? pokemonOrderDirectionList[0] : widget.selectedDirection;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pokemonOrderList.length * pokemonOrderDirectionList.length,
      itemBuilder: (context, index) {
        final attributeIndex = index ~/ pokemonOrderDirectionList.length;
        final directionIndex = index % pokemonOrderDirectionList.length;

        final attribute = pokemonOrderList[attributeIndex];
        final direction = pokemonOrderDirectionList[directionIndex];
        final isSelected = currentAttribute == attribute && currentDirection == direction;

        return ListTile(
          title: Text('${direction == 'asc' ? '↑' : '↓'} $attribute'),
          leading: Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected ? Colors.red : Colors.grey,
          ),
          onTap: () {
            setState(() {
              currentAttribute = attribute;
              currentDirection = direction;
            });
            widget.onOrderSelected(attribute, direction); // Notifica ambos parámetros
            Navigator.pop(context); // Cierra el modal
          },
        );
      },
    );
  }
}