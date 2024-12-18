import 'package:api__3_1_0/app/http/controllers/auth_controller.dart';
import 'package:api__3_1_0/app/http/controllers/customer_controller.dart';
import 'package:api__3_1_0/app/http/controllers/order_controller.dart';
import 'package:api__3_1_0/app/http/controllers/order_item_controller.dart';
import 'package:api__3_1_0/app/http/controllers/product_controller.dart';
import 'package:api__3_1_0/app/http/controllers/product_note_controller.dart';
import 'package:api__3_1_0/app/http/controllers/user_controller.dart';
import 'package:api__3_1_0/app/http/controllers/vendor_controller.dart';
import 'package:api__3_1_0/app/http/middleware/authenticate.dart';
import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');

    //customer
    Router.post('/customer', customerController.store);
    Router.get('/customer/{id}', customerController.show);
    Router.get('/customer', customerController.index);
    Router.put('/customer/{id}', customerController.update);
    Router.delete('/customer/{id}', customerController.destroy);
    //vendor
    Router.post('/vendor', vendorController.store);
    Router.get('/vendor/{id}', vendorController.store);
    Router.get('/vendor', vendorController.index);
    Router.put('/vendor{id}', vendorController.update);
    Router.delete('/vendor{id}', vendorController.destroy);

    //product
    Router.post('/product', productController.store);
    Router.get('/product/{id}', productController.show);
    Router.get('/product', productController.index);
    Router.put('/product/{id}', productController.update);
    Router.delete('/product/{id}', productController.destroy);

    //order
    Router.post('/order', orderController.store);
    Router.get('/order/{id}', productController.show);
    Router.get('/order', productController.index);
    Router.put('/order/{id}', productController.update);
    Router.delete('/order/{id}', productController.destroy);

    //orderitem
    Router.post('/orderitem', orderItemController.store);
    Router.get('/orderitem/{id}', productController.show);
    Router.get('/orderitem', productController.index);
    Router.put('/orderitem/{id}', productController.update);
    Router.delete('/ordeitemr/{id}', productController.destroy);

    //productnote
    Router.post('/productnote', productNoteController.store);
    Router.get('/productnote/{id}', productController.show);
    Router.get('/productnote', productController.index);
    Router.put('/productnote/{id}', productController.update);
    Router.delete('/productnote/{id}', productController.destroy);

    /// Login and Register
    Router.group(() {
      Router.post('register', authController.register);
      Router.post('login', authController.login);
      Router.get('me', authController.me);
    }, prefix: 'auth');

    /// User
    Router.group(() {
      Router.patch('update-password', userController.updatePassword);
      Router.get('', userController.index);
    }, prefix: 'user', middleware: [AuthenticateMiddleware()]);
  }
}
