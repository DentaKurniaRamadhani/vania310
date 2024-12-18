import 'package:vania/vania.dart';

class CreateOrderTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orders', () {
      bigIncrements('order_num');
      primary('order_num');
      date('order_date');
      bigInt('cust_id', unsigned: true);
      timeStamps();
      foreign('cust_id', 'customers', 'cust_id');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orders');
  }
}
