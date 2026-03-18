import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/project_model.dart';
import '../services/api_service.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _progressController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        imageQuality: 85,
      );
      if (photo != null) {
        setState(() {
          _imageFile = File(photo.path);
        });
      }
    } catch (e) {
      _showSnack('No se pudo acceder a la cámara.');
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final progressText = _progressController.text.trim();

    if (name.isEmpty || description.isEmpty || progressText.isEmpty) {
      _showSnack('Por favor completa todos los campos.');
      return;
    }

    final progress = int.tryParse(progressText);
    if (progress == null || progress < 0 || progress > 100) {
      _showSnack('El progreso debe ser un número entre 0 y 100.');
      return;
    }

    setState(() => _isLoading = true);

    String? imageUrl;
    if (_imageFile != null) {
      imageUrl = await uploadToCloudinary(_imageFile!);
      if (imageUrl == null) {
        _showSnack('No se pudo subir la imagen. Intenta de nuevo.');
        setState(() => _isLoading = false);
        return;
      }
    }

    final project = Project(
      id: '',
      name: name,
      description: description,
      progress: progress,
      imageUrl: imageUrl,
    );

    final success = await createProject(project);
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      _showSnack('Error al guardar el proyecto. Intenta de nuevo.');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Proyecto'),
        backgroundColor: const Color(0xFF1A73E8),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del proyecto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _progressController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Progreso (0 - 100)',
                border: OutlineInputBorder(),
                suffixText: '%',
              ),
            ),
            const SizedBox(height: 24),
            if (_imageFile != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _imageFile!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
            ],
            OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label:
                  Text(_imageFile == null ? 'Tomar foto' : 'Cambiar foto'),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A73E8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Guardar',
                        style: TextStyle(fontSize: 16)),
                  ),
          ],
        ),
      ),
    );
  }
}
