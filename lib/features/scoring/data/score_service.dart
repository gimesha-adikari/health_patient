import '../../../core/api.dart';

class ScoreService {
  Future<String> enqueue(String patientId) async {
    final res = await dio.post('/jobs/score-now', data: {'patient_id': patientId});
    return res.data['jobId'].toString();
  }

  Future<Map<String, dynamic>> status(String jobId) async {
    final res = await dio.get('/jobs/$jobId');
    return Map<String, dynamic>.from(res.data as Map);
  }
}
