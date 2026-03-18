import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/project_model.dart';

const String _baseUrl = 'https://69bb23d10915748735b87f4d.mockapi.io/projects';
const String _cloudinaryUrl = 'https://api.cloudinary.com/v1_1/TU_CLOUD_NAME/image/upload';
const String _cloudinaryPreset = 'TU_PRESET_NAME';

Future<List<Project>> fetchProjects() async {
  final response = await http.get(Uri.parse(_baseUrl));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Project.fromJson(json)).toList();
  }
  throw Exception('Error al cargar los proyectos');
}

Future<bool> createProject(Project project) async {
  final response = await http.post(
    Uri.parse(_baseUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(project.toJson()),
  );
  return response.statusCode == 201 || response.statusCode == 200;
}

Future<String?> uploadToCloudinary(File image) async {
  final url = Uri.parse(_cloudinaryUrl);
  final request = http.MultipartRequest('POST', url)
    ..fields['upload_preset'] = _cloudinaryPreset
    ..files.add(await http.MultipartFile.fromPath('file', image.path));

  final response = await request.send();
  if (response.statusCode == 200) {
    final bytes = await response.stream.toBytes();
    final jsonRes = jsonDecode(String.fromCharCodes(bytes));
    return jsonRes['secure_url'];
  }
  return null;
}
