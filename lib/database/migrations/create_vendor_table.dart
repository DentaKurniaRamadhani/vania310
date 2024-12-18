import 'package:vania/vania.dart';

class CreateVendorTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('vendors', () {
      bigIncrements('vend_id');
      primary('vend_id');
      string('vend_name');
      text('vend_address');
      text('vend_kota');
      string('vend_state');
      string('vend_zip');
      string('vend_country');
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('vendors');
  }
}
