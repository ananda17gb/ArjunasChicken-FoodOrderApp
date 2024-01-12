import 'package:flutter/material.dart';

class RelationElement {
  RelationElement? nextRelation;
  MenuElement? nextMenu;
}

class RelationList {
  RelationElement? firstRelation;
}

class MenuInfoType {
  String nameMenu;
  double priceMenu;

  MenuInfoType(this.nameMenu, this.priceMenu);
}

class MenuElement {
  late MenuInfoType infoMenu;
  MenuElement? nextMenu;

  MenuElement(MenuInfoType x)
      : infoMenu = x,
        nextMenu = null;
}

class MenuList {
  MenuElement? firstMenu;
}

class CustomerInfoType {
  late String nameCustomer;

  CustomerInfoType(this.nameCustomer);
}

class CustomerElement {
  late CustomerInfoType infoCustomer;
  CustomerElement? nextCustomer;
  RelationList menu = RelationList();

  CustomerElement(CustomerInfoType x);
}

class CustomerList {
  CustomerElement? firstCustomer;
}

CustomerList createListCustomer() {
  return CustomerList()..firstCustomer = null;
}

MenuList createListMenu() {
  return MenuList()..firstMenu = null;
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CustomerList customerList = createListCustomer();
  final MenuList menuList = createListMenu();

  TextEditingController customerNameController = TextEditingController();
  TextEditingController menuNameController = TextEditingController();
  TextEditingController menuPriceController = TextEditingController();
  TextEditingController orderMenuNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Arjunas Chicken'),
        ),
        body: Column(
          children: [
            // First Column: Display menu
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text before the list of menu items
                Text(
                  'Our Menu:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Display menu items on the homepage
                if (menuList.firstMenu != null) ...[
                  for (MenuElement? current = menuList.firstMenu;
                      current != null;
                      current = current.nextMenu) ...[
                    ListTile(
                      title: Text(current.infoMenu.nameMenu),
                      subtitle:
                          Text('Price: Rp. ${current.infoMenu.priceMenu}'),
                    ),
                  ],
                ],
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Add Menu'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: menuNameController,
                                decoration:
                                    InputDecoration(labelText: 'Menu Name'),
                              ),
                              TextField(
                                controller: menuPriceController,
                                decoration: InputDecoration(labelText: 'Price'),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  // Call addMenu based on user input
                                  addMenu(MenuInfoType(
                                    menuNameController.text,
                                    double.tryParse(menuPriceController.text) ??
                                        0,
                                  ));
                                  menuNameController.clear();
                                  menuPriceController.clear();
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text('Add Menu'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Add Menu'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Place Order'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: customerNameController,
                                decoration:
                                    InputDecoration(labelText: 'Customer Name'),
                              ),
                              TextField(
                                controller: orderMenuNameController,
                                decoration:
                                    InputDecoration(labelText: 'Menu Name'),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  // Check if the customer already exists
                                  CustomerElement? existingCustomer =
                                      searchCustomer(customerList,
                                          customerNameController.text);

                                  if (existingCustomer != null) {
                                    // Customer already exists, update the order
                                    orderMenu(
                                        customerList,
                                        menuList,
                                        existingCustomer
                                            .infoCustomer.nameCustomer,
                                        orderMenuNameController.text);
                                  } else {
                                    // Customer doesn't exist, add a new customer
                                    addCustomer(CustomerInfoType(
                                        customerNameController.text));
                                    orderMenu(
                                        customerList,
                                        menuList,
                                        customerNameController.text,
                                        orderMenuNameController.text);
                                  }
                                  customerNameController.clear();
                                  orderMenuNameController.clear();
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text('Place Order'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Place Order'),
                ),
                Text(
                  'Orders:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Display orders on the homepage
                if (customerList.firstCustomer != null) ...[
                  for (CustomerElement? current = customerList.firstCustomer;
                      current != null;
                      current = current.nextCustomer) ...[
                    if (current.menu.firstRelation != null) ...[
                      for (RelationElement? r = current.menu.firstRelation;
                          r != null;
                          r = r.nextRelation) ...[
                        ListTile(
                          title: Text(
                              'Customer: ${current.infoCustomer.nameCustomer}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Order: ${r.nextMenu!.infoMenu.nameMenu}'),
                              Text(
                                  'Total Price: Rp. ${r.nextMenu!.infoMenu.priceMenu}'),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ],
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void addMenu(MenuInfoType menuInfo) {
    MenuElement menuElement = createElementMenu(menuInfo);
    insertLastMenu(menuList, menuElement);
    setState(() {}); // Trigger a rebuild of the UI
  }

  void addCustomer(CustomerInfoType customerInfo) {
    CustomerElement customerElement = createElementCustomer(customerInfo);
    insertLastCustomer(customerList, customerElement);
  }

  // void placeOrder(String customerName, String menuName) {
  //   CustomerElement? customer = searchCustomer(customerList, customerName);
  //   MenuElement? menu = searchMenu(menuList, menuName);

  //   if (customer != null && menu != null) {
  //     orderMenu(customerList, menuList, customerName, menuName);
  //   }
  // }

  void viewAllOrders() {
    showAllOrder(customerList);
  }

  MenuElement createElementMenu(MenuInfoType x) {
    return MenuElement(x)..nextMenu = null;
  }

  CustomerElement createElementCustomer(CustomerInfoType x) {
    return CustomerElement(x)
      ..nextCustomer = null
      ..menu.firstRelation = null
      ..infoCustomer = x; // Initialize infoCustomer here
  }

  void insertLastCustomer(CustomerList C, CustomerElement P) {
    if (C.firstCustomer == null) {
      C.firstCustomer = P;
    } else {
      CustomerElement? c = C.firstCustomer;
      while (c!.nextCustomer != null) {
        c = c.nextCustomer;
      }
      c.nextCustomer = P;
    }
  }

  void insertLastMenu(MenuList M, MenuElement P) {
    if (M.firstMenu == null) {
      M.firstMenu = P;
    } else {
      MenuElement? m = M.firstMenu;
      while (m!.nextMenu != null) {
        m = m.nextMenu;
      }
      m.nextMenu = P;
    }
  }

  CustomerElement? searchCustomer(CustomerList C, String nameCustomer) {
    CustomerElement? c = C.firstCustomer;
    while (c != null && c.infoCustomer.nameCustomer != nameCustomer) {
      c = c.nextCustomer;
    }
    return c;
  }

  MenuElement? searchMenu(MenuList M, String nameMenu) {
    MenuElement? m = M.firstMenu;
    while (m!.infoMenu.nameMenu != nameMenu && m.nextMenu != null) {
      m = m.nextMenu;
    }
    if (m.infoMenu.nameMenu == nameMenu) {
      return m;
    }
    return null;
  }

  void showAllOrder(CustomerList C) {
    CustomerElement? c = C.firstCustomer;
    while (c != null) {
      if (c.menu.firstRelation == null) {
        print("This person hasn't ordered anything");
      } else {
        RelationElement? r = c.menu.firstRelation;
        int i = 1;
        while (r != null) {
          print("$i. Customer Name: ${c.infoCustomer.nameCustomer}");
          print("   Menu Name\t: ${r.nextMenu!.infoMenu.nameMenu}");
          print("   Price\t: Rp. ${r.nextMenu!.infoMenu.priceMenu}");

          r = r.nextRelation;
          i++;
        }
      }
      c = c.nextCustomer;
    }
  }

  void orderMenu(
      CustomerList C, MenuList M, String nameCustomer, String nameMenu) {
    CustomerElement? c = searchCustomer(C, nameCustomer);
    MenuElement? m = searchMenu(M, nameMenu);
    if (c != null && m != null) {
      RelationElement r = createElementRelation();
      r.nextMenu = m;
      if (c.menu.firstRelation == null) {
        c.menu.firstRelation = r;
      } else {
        RelationElement? re = c.menu.firstRelation;
        while (re!.nextRelation != null) {
          re = re.nextRelation;
        }
        re.nextRelation = r;
      }
      setState(() {}); // Trigger a rebuild of the UI
    }
  }

  RelationElement createElementRelation() {
    return RelationElement()
      ..nextMenu = null
      ..nextRelation = null;
  }

  void showAllMenu(MenuList M) {
    MenuElement? m = M.firstMenu;
    int i = 1;
    while (m != null) {
      print("$i. Menu Name\t: ${m.infoMenu.nameMenu}");
      print("   Price\t: Rp. ${m.infoMenu.priceMenu}");
      i++;
      m = m.nextMenu;
    }
  }

  void showAllCustomer(CustomerList C) {
    CustomerElement? c = C.firstCustomer;
    int i = 1;
    while (c != null) {
      print("$i. Customer Name: ${c.infoCustomer.nameCustomer}");
      i++;
      c = c.nextCustomer;
    }
  }
}
