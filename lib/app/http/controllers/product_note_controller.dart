// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';
import 'package:api__3_1_0/app/models/product.dart';
import 'package:api__3_1_0/app/models/productnote.dart';
import 'package:vania/vania.dart';

class ProductNoteController extends Controller {
  Future<Response> index() async {
    try {
      final productnote = await Productnote().query().get();
      return Response.json(productnote);
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
        'prod_id': 'required|max_length:100',
        'note_date': 'required|max_length:255',
        'note_text': 'required|max_length:50'
      }, {
        'prod_id.required': 'Form nomor order harus di isi',
        'prod_id.max_length': 'input nomor order max 100 karakter',
        'note_date.required': 'Form id produk harus di isi',
        'note_date.max_length': 'input id produk max 225 karakter',
        'note_text.required': 'Form harus di isi',
        'note_text.max_length': 'input max 50 karakter'
      });
      final productnote = request.input();
      final existingProduct = await Product()
          .query()
          .where('prod_id', '=', productnote['prod_id'])
          .first();
      if (existingProduct == null) {
        return Response.json({'message': 'produk note'}, 409);
      }
      productnote['created_at'] = DateTime.now().toIso8601String();
      await Productnote().query().insert(productnote);
      return Response.json(
          {'message': 'Produk berhasil ditambahkan', 'data': productnote}, 201);
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
      final productnote =
          await Productnote().query().where('note_id', '=', id).first();

      return Response.json({'success': true, 'data': productnote});
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
        'prod_id': 'required|max_length:100',
        'note_date': 'required|max_length:255',
        'note_text': 'required|max_length:50'
      }, {
        'prod_id.required': 'Form produk id order harus di isi',
        'prod_id.max_length': 'input produk id order max 100 karakter',
        'note_date.required': 'Form tanggal note harus di isi',
        'note_date.max_length': 'input tanggalnote max 225 karakter',
        'note_text.required': 'Form text note di isi',
        'note_text.max_length': 'input text max 50 karakter'
      });
      //mengambil input data yang customer yang akan di update
      final productnoteData = request.input();

      if (productnoteData.containsKey('id')) {
        productnoteData['order_num'] = productnoteData['id'];
        productnoteData.remove('id');
      }
      print('data yang dikirim $productnoteData');
      productnoteData['updated_at'] = DateTime.now().toIso8601String();
      final productnote =
          await Productnote().query().where('note_id', '=', id).first();

      if (productnote == null) {
        return Response.json({
          'message': 'Order dengan ID $id tidak ditemukan.',
        }, 404);
      }
      await Productnote()
          .query()
          .where('note_id', '=', id)
          .update(productnoteData);
      return Response.json({
        'message': 'data order berhasil di perbaharui',
        'data': Productnote,
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
    return Response.json({});
  }
}

final ProductNoteController productNoteController = ProductNoteController();
