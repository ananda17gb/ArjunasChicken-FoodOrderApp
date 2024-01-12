import 'dart:collection';
import 'package:flutter/material.dart';

// Model classes
class Customer {
  String customerName;
  LinkedList<Menu> menuList;
  LinkedList<Order> orderList;

  Customer(this.customerName)
      : menuList = LinkedList<Menu>(),
        orderList = LinkedList<Order>();
}

// Base class Menu
base class Menu extends LinkedListEntry<Menu> {
  String itemName;
  double price;

  Menu(this.itemName, {this.price = 0.0});
}

// Base class Order
base class Order extends LinkedListEntry<Order> {
  String orders;
  LinkedList<Menu> selectedMenus;

  Order(this.orders) : selectedMenus = LinkedList<Menu>();
}

// CheckBoxMenuItem widget
class CheckBoxMenuItem extends StatefulWidget {
  final Menu menu;
  final Function(bool) onChecked;

  CheckBoxMenuItem({required this.menu, required this.onChecked});

  bool isChecked() {
    return _CheckBoxMenuItemState().isChecked;
  }

  @override
  _CheckBoxMenuItemState createState() => _CheckBoxMenuItemState();
}

class _CheckBoxMenuItemState extends State<CheckBoxMenuItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value!;
              widget.onChecked(isChecked); // Notify the parent
            });
          },
        ),
        Text(widget.menu.itemName),
      ],
    );
  }
}

// UI representation
class MultiLinkedListUI extends StatefulWidget {
  @override
  _MultiLinkedListUIState createState() => _MultiLinkedListUIState();
}

class _MultiLinkedListUIState extends State<MultiLinkedListUI> {
  TextEditingController _menuController = TextEditingController();
  TextEditingController _orderController = TextEditingController();
  List<Customer> _customerList = []; // List of customers

  // Method to update MenuListUI
  void _updateMenuList() {
    setState(() {});
  }

  // Method to update OrderListUI
  void _updateOrderList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arjuna Chicken'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Commented out the MenuListUI section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu List:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                MenuListUI(_customerList, _removeMenu),
                SizedBox(height: 10),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer List:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                OrderListUI(_customerList, _removeCustomer),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _showAddMenuDialog(context),
            tooltip: 'Add Menu',
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => _showAddOrderDialog(context),
            tooltip: 'Add Order',
            child: Icon(Icons.shopping_cart),
          ),
        ],
      ),
    );
  }

  _showAddMenuDialog(BuildContext context) {
    TextEditingController _customerNameController = TextEditingController();
    TextEditingController _menuController = TextEditingController();
    TextEditingController _priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Menu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _menuController,
                decoration: InputDecoration(labelText: 'Menu Name'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Menu Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  Customer customer = Customer(_customerNameController.text);
                  customer.menuList.add(Menu(
                    _menuController.text,
                    price: double.parse(_priceController.text),
                  ));
                  _customerList.add(customer);
                });
                Navigator.of(context).pop(); // Close the dialog
                // Update MenuListUI
                _updateMenuList();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  _showAddOrderDialog(BuildContext context) {
    TextEditingController _customerNameController = TextEditingController();
    TextEditingController _orderNameController = TextEditingController();

    List<CheckBoxMenuItem> checkBoxMenuItems = [];

    _customerList.forEach((customer) {
      customer.menuList.forEach((menu) {
        checkBoxMenuItems.add(CheckBoxMenuItem(
          menu: menu,
          onChecked: (bool) {},
        ));
      });
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Order'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _customerNameController,
                    decoration: InputDecoration(labelText: 'Customer Name'),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: checkBoxMenuItems,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      Customer customer =
                          Customer(_customerNameController.text);

                      checkBoxMenuItems.forEach((item) {
                        if (item.isChecked()) {
                          customer.menuList.add(item.menu);
                        }
                      });

                      Order order = Order(_orderNameController.text);
                      order.selectedMenus.addAll(customer.menuList);
                      customer.orderList.add(order);

                      _customerList.add(customer);
                    });
                    Navigator.of(context).pop(); // Close the dialog
                    // Update OrderListUI
                    _updateOrderList();
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _removeMenu(Customer customer) {
    setState(() {
      _customerList.remove(customer);
    });
  }

  void _removeCustomer(Customer customer) {
    setState(() {
      _customerList.remove(customer);
    });
  }
}

class MenuListUI extends StatelessWidget {
  final List<Customer> customerList;
  final Function(Customer) onRemove;

  MenuListUI(this.customerList, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: customerList
              ?.map((customer) => MenuUI(customer, onRemove))
              ?.toList() ??
          [],
    );
  }
}

class MenuUI extends StatelessWidget {
  final Customer customer;
  final Function(Customer) onRemove;

  MenuUI(this.customer, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return customer.menuList.isNotEmpty
        ? Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(customer.menuList.first.itemName),
              ),
              TextButton(
                onPressed: () => onRemove(customer),
                child: Icon(
                  Icons.delete,
                ),
              ),
            ],
          )
        : Container(); // If menuList is empty, return an empty container
  }
}

class OrderListUI extends StatelessWidget {
  final List<Customer> customerList;
  final Function(Customer) onRemove;

  OrderListUI(this.customerList, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: customerList
              .map((customer) => OrderUI(customer, onRemove, _onMenuChecked))
              .toList() ??
          [],
    );
  }

  // Function to handle selected menu items
  void _onMenuChecked(bool isChecked, Menu menu) {
    // Implement your logic here
    if (isChecked) {
      // Do something when the menu is checked
      print('Menu checked: ${menu.itemName}');
    } else {
      // Do something when the menu is unchecked
      print('Menu unchecked: ${menu.itemName}');
    }
  }
}

class OrderUI extends StatefulWidget {
  final Customer customer;
  final Function(Customer) onRemove;
  final void Function(bool isChecked, Menu menu) onMenuChecked;

  OrderUI(this.customer, this.onRemove, this.onMenuChecked);

  @override
  _OrderUIState createState() => _OrderUIState();
}

class _OrderUIState extends State<OrderUI> {
  void _onMenuChecked(bool isChecked, Menu menu) {
    setState(() {
      if (isChecked) {
        widget.customer.orderList.last.selectedMenus.add(menu);
      } else {
        widget.customer.orderList.last.selectedMenus.remove(menu);
      }
    });
    widget.onMenuChecked(isChecked, menu);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.customer.customerName.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children: [
                Text('Customer: ${widget.customer.customerName}'),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => widget.onRemove(widget.customer),
                ),
              ],
            ),
          ),
        // if (widget.customer.customerName.isNotEmpty &&
        //     widget.customer.orderList.isNotEmpty)
        //   ...widget.customer.orderList
        //       .map((order) => OrderDetailsUI(order, _onMenuChecked))
        //       .toList(),
        if (widget.customer.customerName.isNotEmpty &&
            widget.customer.orderList.isEmpty)
          Text("No orders yet."),
      ],
    );
  }
}

// class OrderDetailsUI extends StatelessWidget {
//   final Order order;
//   final void Function(bool isChecked, Menu menu) onMenuChecked;

//   OrderDetailsUI(this.order, this.onMenuChecked);

//   @override
//   Widget build(BuildContext context) {
//     double totalPrice = order.selectedMenus.isNotEmpty
//         ? order.selectedMenus
//             .map((menu) => menu.price)
//             .reduce((value, element) => value + element)
//         : 0.0;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 32.0),
//           child: Text('Ordered Menu Items:'),
//         ),
//         order.selectedMenus.isNotEmpty
//             ? Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: order.selectedMenus
//                     .map((menu) => Text(
//                         '${menu.itemName} - \$${menu.price.toStringAsFixed(2)}'))
//                     .toList(),
//               )
//             : Text("No items in this order."),
//         Padding(
//           padding: const EdgeInsets.only(left: 32.0),
//           child: Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
//         ),
//         Divider(),
//       ],
//     );
//   }
// }

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiLinkedListUI(),
    ),
  );
}
