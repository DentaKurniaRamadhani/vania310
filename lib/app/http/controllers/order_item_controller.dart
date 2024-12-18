// ignore: implementation_imports
import 'package:api__3_1_0/app/models/order.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';
import 'package:api__3_1_0/app/models/orderitem.dart';
import 'package:vania/vania.dart';

class OrderItemController extends Controller {
  Future<Response> index() async {
    try {
      final orderitem = await Orderitem().query().get();
      return Response.json(orderitem);
    } catch (e) {
      return Response.json(400);
    }
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'order_num': 'required|max_length:100',
        'prod_id': 'required|max_length:255',
        'quantity': 'required|max_length:50',
        'size': 'required|max_length:50'
      }, {
        'order_num.required': 'Form nomor order harus di isi',
        'order_num.max_length': 'input nomor order max 100 karakter',
        'prod_id.required': 'Form id produk harus di isi',
        'prod_id.max_length': 'input id produk max 225 karakter',
        'quantity.required': 'Form quantity harus di isi',
        'quantity.max_length': 'input quantity max 50 karakter',
        'size.required': 'Form size harus di isi',
        'size.max_length': 'input size max 50 karakter'
      });
      final orderitem = request.input();
      final existingOrder = await Order()
          .query()
          .where('order_num', '=', orderitem['order_num'])
          .first();
      if (existingOrder == null) {
        return Response.json({'message': 'order'}, 409);
      }
      orderitem['created_at'] = DateTime.now().toIso8601String();
      await Orderitem().query().insert(orderitem);
      return Response.json(
          {'message': 'order berhasil ditambahkan', 'data': orderitem}, 201);
    } catch (e) {
      if (e is ValidationException) {
        final errorMessage = e.message;
        return Response.json({'error': errorMessage}, 400);
      } else {
        return Response.json(
            {'message': 'Terjadi kesalahan disisi server harap cobalagi nanti'},
            500);
      }
    }
  }

  Future<Response> show(int id) async {
    try {
      final orderitem =
          await Orderitem().query().where('order_item', '=', id).first();

      return Response.json({'success': true, 'data': orderitem});
    } catch (e) {
      return Response.json({
        'error': 'Bad Request',
        'message': e.toString(),
      });
    }
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    try {
      request.validate({
        'order_num': 'required|max_length:100',
        'prod_id': 'required|max_length:255',
        'quantity': 'required|max_length:50',
        'size': 'required|max_length:50'
      }, {
        'order_num.required': 'Form nomor order harus di isi',
        'order_num.max_length': 'input nomor order max 100 karakter',
        'prod_id.required': 'Form id produk harus di isi',
        'prod_id.max_length': 'input id produk max 225 karakter',
        'quantity.required': 'Form quantity harus di isi',
        'quantity.max_length': 'input quantity max 50 karakter',
        'size.required': 'Form size harus di isi',
        'size.max_length': 'input size max 50 karakter'
      });

      final orderitemData = request.input();

      if (orderitemData.containsKey('id')) {
        orderitemData['order_item'] = orderitemData['id'];
        orderitemData.remove('id');
      }
      print('data yang dikirim $orderitemData');
      orderitemData['updated_at'] = DateTime.now().toIso8601String();
      final orderitem =
          await Order().query().where('order_item', '=', id).first();

      if (orderitem == null) {
        return Response.json({
          'message': 'Order dengan ID $id tidak ditemukan.',
        }, 404);
      }
      await Order().query().where('order_item', '=', id).update(orderitemData);
      return Response.json({
        'message': 'data order berhasil di perbaharui',
        'data': orderitemData,
      }, 200);
    } catch (e) {
      if (e is ValidationException) {
        final errorMessage = e.message;
        return Response.json({'error': errorMessage}, 400);
      } else {
        return Response.json({
          'message':
              'Terjadi kesalahan disisi server. Harap coba kembali nanti',
        }, 500);
      }
    }
  }

  Future<Response> destroy(int id) async {
    try {
      final orderitem =
          await Orderitem().query().where('order_item', '=', id).delete();

      if (orderitem == 0) {
        return Response.json({
          'error': 'Not Found',
          'message': 'orderan dengan ID $id  tidak ditemukan',
        });
      }

      return Response.json({'message': 'order deleted successfully'});
    } catch (e) {
      return Response.json({
        'error': 'Bad Request',
        'message': e.toString(),
      });
    }
  }
}

final OrderItemController orderItemController = OrderItemController();
