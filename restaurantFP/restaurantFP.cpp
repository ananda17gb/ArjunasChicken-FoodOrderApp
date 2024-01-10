#import "restaurantFP.h"

//create list
void createListCustomer(customerList &C){
    C.first_customer = NULL;
}
void createListMenu(menuList &M){
    M.first_menu = NULL;
}


//create element for the list
adr_customer createElementCustomer(customer_infotype x){
    adr_customer c = new customer_element;
    c->info_customer.name_customer = x.name_customer;
    c->info_customer.id_customer = x.id_customer;
    c->next_customer = NULL;
    c->menu.first_relation = NULL;
    return c;
}
adr_menu createElementMenu(menu_infotype x){
    adr_menu m = new menu_element;
    m->info_menu.name_menu = x.name_menu;
    m->info_menu.id_menu = x.id_menu;
    m->info_menu.price_menu = x.price_menu;
    m->next_menu = NULL;
    return m;
}
adr_relation createElementRelation(){
    adr_relation r = new relation_element;
    r->next_menu= NULL;
    r->next_relation= NULL;
    return r;
}


//insert element to the list
void insertLastCustomer(customerList &C, adr_customer P){
    if (C.first_customer == NULL){
        C.first_customer = P;
    }else {
        adr_customer c = C.first_customer;
        while (c->next_customer != NULL){
            c = c->next_customer;
        }
        c->next_customer = P;
    }
}
void insertLastMenu(menuList &M, adr_menu P){
    if (M.first_menu == NULL){
        M.first_menu = P;
    }else {
        adr_menu m = M.first_menu;
        while (m->next_menu != NULL){
            m = m->next_menu;
        }
        m->next_menu = P;
    }
}
void orderMenu(customerList &C, menuList &M, string name_customer, string name_menu){
    adr_customer c = searchCustomer(C, name_customer);
    adr_menu m = searchMenu(M, name_menu);
    if (c != NULL && m != NULL){
        adr_relation r = createElementRelation();
        r->next_menu = m;
        if (c->menu.first_relation == NULL){
            c->menu.first_relation = r;
        }else{
            adr_relation re = c->menu.first_relation;
            while (re->next_relation != NULL){
                re = re->next_relation;
            }
            re->next_relation = r;
        }
    }
}


//delete element inside the list
void deleteCustomer(customerList &C, string name_customer) {
    adr_customer c = searchCustomer(C, name_customer);

    if (c != NULL) {
        if (c == C.first_customer) {
            adr_customer p = c->next_customer;
            c->next_customer = NULL;
            C.first_customer = p;
        } else if (c->next_customer == NULL) {
            adr_customer p = C.first_customer;
            while (p->next_customer != c) {
                p = p->next_customer;
            }
            p->next_customer = NULL;
        } else {
            adr_customer p = C.first_customer;
            while (p->next_customer != c) {
                p = p->next_customer;
            }
            p->next_customer = c->next_customer;
            c->next_customer = NULL;
        }
        delete c;
    }
}
void deleteOrder(customerList &C, relationList &R, string name_menu, string name_customer){
    adr_customer c = searchCustomer(C,name_customer);
    if (c != NULL && c->menu.first_relation != NULL){
        adr_relation r = c->menu.first_relation;
        adr_relation r1 = c->menu.first_relation;
        while (r->next_relation!=NULL && r->next_menu->info_menu.name_menu != name_menu){
            r1 = r;
            r = r->next_relation;
        }
        if (r->next_relation!=NULL && r->next_menu->info_menu.name_menu == name_menu){
            if(r == c->menu.first_relation && r->next_relation == NULL){
                c->menu.first_relation = NULL;
                r->next_menu = NULL;
            }else if (r == c->menu.first_relation && r->next_relation != NULL){
                c->menu.first_relation = r->next_relation;
                r->next_relation = NULL;
                r->next_menu = NULL;
            }else if (r->next_relation == NULL) {
                r1->next_relation=NULL;
                r ->next_menu = NULL;
            }else {
                r1->next_relation = r->next_relation;
                r->next_relation = NULL;
                r->next_menu = NULL;
            }
            delete r;
        }
    }
}

void deleteAllOrder(customerList &C, relationList &R, string name_customer){
    adr_customer c = searchCustomer(C,name_customer);
    adr_relation p;
    while (c->menu.first_relation != NULL){
        p = c->menu.first_relation;
        c->menu.first_relation = c->menu.first_relation->next_relation;
        p = NULL;
    }
}

//search element inside the list
adr_customer searchCustomer(customerList C, string name_customer){
    adr_customer c = C.first_customer;
    while (c->info_customer.name_customer != name_customer && c->next_customer != NULL){
        c = c->next_customer;
    }
    if (c->info_customer.name_customer == name_customer){
        return c;
    }
    return NULL;
}
adr_menu searchMenu(menuList M, string name_menu){
    adr_menu m = M.first_menu;
    while (m->info_menu.name_menu != name_menu && m->next_menu != NULL){
        m = m->next_menu;
    }
    if (m->info_menu.name_menu == name_menu){
        return m;
    }
    return NULL;
}
adr_relation searchRelation(relationList R, adr_menu P){
    adr_relation r = R.first_relation;
    while (r->next_menu != P && r->next_relation != NULL){
        r = r->next_relation;
    }
    if (r->next_menu == P){
        return r;
    }
    return NULL;
}

////display
void showCustomerBasedOnMenu(customerList C, menuList M, string name_menu){
    adr_relation r;
    adr_customer c = C.first_customer;
    int i = 1;
    while (c!= NULL){
        r = searchRelation(c->menu, searchMenu(M,name_menu));
        if (r != NULL){
            cout << i << ". "<< "Customer Name: "<<c->info_customer.name_customer << endl;
            cout << "   " << "Customer ID\t: "<<c->info_customer.id_customer << endl;
            i++;
        }else {
            cout << "No customer order this menu" << endl;
        }
        c = c->next_customer;
    }
}
void showMenuBasedOnCustomer(customerList C, string name_customer){
    adr_customer c = searchCustomer(C, name_customer);
    int i = 1;
    if (c != NULL){
        if (c->menu.first_relation != NULL){
            adr_relation r = c->menu.first_relation;
            while (r != NULL){
                cout << i << ". " << "Menu Name\t: " <<r->next_menu->info_menu.name_menu << endl;
                cout << "   " << "Menu Price\t: " << r->next_menu->info_menu.price_menu << endl;
                r = r->next_relation;
                i++;
            }
        }
    }else {
        cout << "There is no customer with that name" << endl;
    }
}
void showAllOrder(customerList C){
    adr_customer c = C.first_customer;
    while (c != NULL){
        if (c->menu.first_relation == NULL){
            cout << "This person haven't order anything" << endl;
        }else {
            adr_relation r = c->menu.first_relation;
            int i = 1;
            while (r!= NULL){
                cout << i << ". "<< "Customer ID\t: "<< c->info_customer.id_customer << endl;
                cout << "   "<< "Customer Name: "<< c->info_customer.name_customer << endl;
                cout << "   "<< "Menu ID\t: "<< r->next_menu->info_menu.id_menu << endl;
                cout << "   "<< "Menu Name\t: "<< r->next_menu->info_menu.name_menu << endl;
                cout << "   "<< "Price\t: "<< r->next_menu->info_menu.price_menu << endl;

                r = r->next_relation;
            }
        }
        c = c->next_customer;
    }
}
void showAllCustomer(customerList C){
    adr_customer c = C.first_customer;
    int i = 1;
    while (c != NULL){
        cout << i << ". " << "Customer Name: " << c->info_customer.name_customer << endl;
        cout << "   " << "Customer ID\t: " << c->info_customer.id_customer << endl;
        i++;
        c = c->next_customer;
    }
}
void showAllMenu(menuList M){
    adr_menu m = M.first_menu;
    int i = 1;
    while (m != NULL){
        cout << i << ". " << "Menu ID\t: " << m->info_menu.id_menu <<endl;
        cout << "   " << "Menu Name\t: " << m->info_menu.name_menu << endl;
        cout << "   " << "Price\t: " << m->info_menu.price_menu << endl;
        i++;
        m = m->next_menu;
    }
}

void totalPrice(customerList C, string name_customer){
    adr_customer c = searchCustomer(C, name_customer);
    int i = 0;
    int total = 0;
    if (c != NULL){
        if (c->menu.first_relation != NULL){
            adr_relation r = c->menu.first_relation;
            while (r != NULL){
                total = total + r->next_menu->info_menu.price_menu;
                r = r->next_relation;
                i++;
            }
            cout << "Total Menu : " << i << endl;
            cout << "Total Price : " << total << endl;
        }
    }else {
        cout << "There is no customer with that name" << endl;
    }
}

int showDashboard(){
    int answer;
    cout << "1. Add Menu" << endl;
    cout << "2. Add Customer" << endl;
    cout << "3. Add Order (optional)" << endl;
    cout << "4. Delete Customer ((Make sure to do option 5 first!))" << endl;
    cout << "5. Delete Order" << endl;
    cout << "6. Show Menu" << endl;
    cout << "7. Show Customer" << endl;
    cout << "8. Show Customer Order" << endl;
    cout << "9. Show Menu From a Customer" << endl;
    cout << "10. Show Customer Who Ordered a Certain Menu" << endl;
    cout << "11. Show Receipt" << endl;
    cout << "12. Exit Program" << endl;
    cout << "Choose an option: ";
    cin >> answer;
    return answer;
}
