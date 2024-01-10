#ifndef RESTAURANTFP_H_INCLUDED
#define RESTAURANTFP_H_INCLUDED
#include <iostream>
using namespace std;


//Relation
typedef struct relation_element *adr_relation;
struct relationList {
    adr_relation first_relation;
};


////////////////////////////////////////////////////////

//Menu
struct menu_infotype {
    string id_menu;
    string name_menu;
    int price_menu;
};
typedef struct menu_element *adr_menu;
struct menu_element {
    menu_infotype info_menu;
    adr_menu next_menu;
};
struct menuList {
    adr_menu first_menu;
};

////////////////////////////////////////////////////////

//Customer
struct customer_infotype {
    string id_customer;
    string name_customer;
};
typedef struct customer_element *adr_customer;
struct customer_element {
    customer_infotype info_customer;
    adr_customer next_customer;
    relationList menu;
};
struct customerList {
    adr_customer first_customer;
};

struct relation_element {
    adr_relation next_relation;
    adr_menu next_menu;
};
////////////////////////////////////////////////////////

//create list
void createListCustomer(customerList &C);
void createListMenu(menuList &M);
//no createListRelation because it is connected with customer list and menu list


//create element for the list
adr_customer createElementCustomer(customer_infotype x);
adr_menu createElementMenu(menu_infotype x);
adr_relation createElementRelation();


//insert element to the list
void insertLastCustomer(customerList &C, adr_customer P);
void insertLastMenu(menuList &M, adr_menu P);
void orderMenu(customerList &C, menuList &M, string id_customer, string menuName);


//delete element inside the list
void deleteCustomer(customerList &C, string customerName);
//void deleteMenu(customerList &C, menuList &M, string menuName);
void deleteOrder(customerList &C, relationList &R, string menuName, string customerName);
void deleteAllOrder(customerList &C, relationList &R, string customerName);


//search element inside the list
adr_customer searchCustomer(customerList C, string customerName);
adr_menu searchMenu(menuList M, string menuName);
adr_relation searchRelation(relationList R, adr_menu P);

//// search element inside the list from another list
void showCustomerBasedOnMenu(customerList C, menuList M, string menuName);
void showMenuBasedOnCustomer(customerList C, string customerName);


//display
void showAllOrder(customerList C);
void showAllCustomer(customerList C);
void showAllMenu(menuList M);
void totalPrice(customerList C, string customerName);





//extras
int showDashboard();

#endif // RESTAURANTFP_H_INCLUDED
