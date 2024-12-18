// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';
import 'package:api__3_1_0/app/models/customer.dart';
import 'package:api__3_1_0/app/models/order.dart';
import 'package:vania/vania.dart';

class OrderController extends Controller {
  Future<Response> index() async {
    try {
      final order = await Order().query().get();
      return Response.json(order);
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
        'order_date': 'required|max_length:100',
        'cust_id': 'required|max_length:255',
      }, {
        'order_date.required': 'Form name harus di isi',
        'order_date.max_length': 'input nama max 100 karakter',
        'cust_id.required': 'Form alamat harus di isi',
        'cust_id.max_length': 'input alamat max 225 karakter'
      });
      final order = request.input();
      final existingOrder = await Customer()
          .query()
          .where('cust_id', '=', order['cust_id'])
          .first();
      if (existingOrder == null) {
        return Response.json(
            {'message': 'Produk dengan nama ini sudah ada'}, 409);
      }
      order['created_at'] = DateTime.now().toIso8601String();
      await Order().query().insert(order);
      return Response.json({'message': 'order', 'data': order}, 201);
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
      final order = await Order().query().where('order_num', '=', id).first();

      return Response.json({'success': true, 'data': order});
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
        'order_date': 'required|max_length:100',
        'cust_id': 'required|max_length:255',
      }, {
        'order_date.required': 'Form date harus di isi',
        'order_date.max_length': 'input date max 100 karakter',
        'cust_id.required': 'Form id customer harus di isi',
        'cust_id.max_length': 'input id customer max 225 karakter'
      });
      //mengambil input data yang customer yang akan di update
      final orderData = request.input();

      if (orderData.containsKey('id')) {
        orderData['order_num'] = orderData['id'];
        orderData.remove('id');
      }
      print('data yang dikirim $orderData');
      orderData['updated_at'] = DateTime.now().toIso8601String();
      final order = await Order().query().where('order_num', '=', id).first();

      if (order == null) {
        return Response.json({
          'message': 'Order dengan ID $id tidak ditemukan.',
        }, 404);
      }
      await Order().query().where('order_num', '=', id).update(orderData);
      return Response.json({
        'message': 'data order berhasil di perbaharui',
        'data': orderData,
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
      final order = await Order().query().where('order_num', '=', id).delete();

      if (order == 0) {
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

final OrderController orderController = OrderController();
