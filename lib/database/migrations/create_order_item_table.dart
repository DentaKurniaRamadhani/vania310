import 'package:vania/vania.dart';

class CreateOrderItemTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orderitems', () {
      bigIncrements('order_item');
      primary('order_item');
      bigInt('order_num', unsigned: true);
      string('prod_id');
      integer('quantity');
      integer('size');
      timeStamps();
      foreign('order_num', 'orders', 'order_num');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orderitems');
  }
}
