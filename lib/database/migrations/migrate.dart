import 'dart:io';
import 'package:vania/vania.dart';
import 'create_users_table.dart';
import 'create_customer_table.dart';
import 'create_order_table.dart';
import 'create_order_item_table.dart';
import 'create_product_note_table.dart';
import 'create_personal_acces_token_table.dart';
import 'create_vendor_table.dart';
import 'create_product_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
    await CreateUserTable().up();
    await CreateCustomerTable().up();
    await CreateOrderTable().up();
    await CreateVendorTable().up();
    await CreateProductTable().up();
    await CreateProductNoteTable().up();
    await CreateOrderItemTable().up();
    await CreatePersonalAccesTokenTable().up();
  }

  dropTables() async {
    await CreatePersonalAccesTokenTable().down();
    await CreateOrderItemTable().down();
    await CreateProductNoteTable().down();
    await CreateProductTable().down();
    await CreateVendorTable().down();
    await CreateOrderTable().down();
    await CreateCustomerTable().down();
    await CreateUserTable().down();
  }
}
