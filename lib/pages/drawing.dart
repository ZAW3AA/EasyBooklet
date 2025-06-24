// ✅ تعديل يحل مشكلة عدم التلوين إلا بعد تدوير الشاشة
// باستخدام ValueNotifier بدل ChangeNotifier للرسم فقط

// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DrawingPoint {
  final Offset point;
  final Paint paint;
  DrawingPoint({required this.point, required this.paint});
}

class DrawingController {
  final List<DrawingPoint?> _points = [];
  final List<List<DrawingPoint?>> _history = [];
  final ValueNotifier<Color> selectedColor = ValueNotifier(Colors.red);
  final ValueNotifier<double> strokeWidth = ValueNotifier(4.0);
  final ValueNotifier<int> repaintTrigger = ValueNotifier(0); // جديد

  List<DrawingPoint?> get points => _points;

  void addPoint(DrawingPoint point) {
    _points.add(point);
    repaintTrigger.value++;
  }

  void endStroke() {
    _points.add(null);
    _saveToHistory();
    repaintTrigger.value++;
  }

  void clear() {
    _points.clear();
    _saveToHistory();
    repaintTrigger.value++;
  }

  void undo() {
    if (_history.isEmpty) return;
    _points.clear();
    _points.addAll(_history.removeLast());
    repaintTrigger.value++;
  }

  void _saveToHistory() {
    _history.add(List.from(_points));
    if (_history.length > 20) {
      _history.removeAt(0);
    }
  }
}

class DrawingScreen extends StatefulWidget {
  final String imagePath;
  const DrawingScreen({super.key, required this.imagePath});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final DrawingController _drawingController = DrawingController();
  final GlobalKey _repaintKey = GlobalKey();
  String? _savedImagePath;
  bool _isSaving = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'drawing_${widget.imagePath}';
      final path = prefs.getString(key);
      if (path != null && await File(path).exists()) {
        setState(() => _savedImagePath = path);
      }
    } catch (e) {
      debugPrint('Error loading saved image: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveDrawing() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final boundary =
          _repaintKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'drawing_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.png';
      final filePath = '${directory.path}/$fileName';
      await File(filePath).writeAsBytes(pngBytes);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('drawing_${widget.imagePath}', filePath);

      await _saveToGallery(pngBytes);

      setState(() => _savedImagePath = filePath);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ تم حفظ الصورة بنجاح')));
      }
    } catch (e) {
      debugPrint("Error saving image: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('❌ فشل في حفظ الصورة')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<bool> _requestStoragePermission() async {
    final status = await Permission.storage.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      final result = await Permission.storage.request();
      return result.isGranted;
    } else if (status.isPermanentlyDenied) {
      // التصريح مرفوض نهائيًا
      return false;
    }

    return false;
  }

  Future<void> _saveToGallery(Uint8List pngBytes) async {
    final hasPermission = await _requestStoragePermission();

    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ لازم تفعّل صلاحية التخزين من الإعدادات'),
          ),
        );
      }
      return;
    }

    try {
      final directory = Platform.isAndroid
          ? Directory('/storage/emulated/0/Pictures/MyDrawings')
          : await getApplicationDocumentsDirectory();

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final file = File(
        '${directory.path}/drawing_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.png',
      );
      await file.writeAsBytes(pngBytes);
    } catch (e) {
      debugPrint("Error saving to gallery: $e");
      rethrow;
    }
  }

  void _clearDrawing() {
    if (_drawingController.points.isEmpty) return;
    _drawingController.clear();
    setState(() => _savedImagePath = null);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('🧹 تم مسح الرسمة')));
  }

  void _addPoint(Offset globalPosition) {
    final box = _repaintKey.currentContext!.findRenderObject() as RenderBox;
    final point = box.globalToLocal(globalPosition);
    _drawingController.addPoint(
      DrawingPoint(
        point: point,
        paint: Paint()
          ..color = _drawingController.selectedColor.value
          ..strokeWidth = _drawingController.strokeWidth.value
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Coloring Book",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800],
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          ValueListenableBuilder(
            valueListenable: _drawingController.repaintTrigger,
            builder: (context, _, __) {
              return IconButton(
                icon: const Icon(Icons.undo),
                tooltip: "تراجع",
                onPressed: _drawingController.points.isEmpty
                    ? null
                    : _drawingController.undo,
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: _drawingController.repaintTrigger,
            builder: (context, _, __) {
              return IconButton(
                icon: const Icon(Icons.delete),
                tooltip: "مسح",
                onPressed: _drawingController.points.isEmpty
                    ? null
                    : _clearDrawing,
              );
            },
          ),
          IconButton(
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save),
            tooltip: "حفظ",
            onPressed: _isSaving ? null : _saveDrawing,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RepaintBoundary(
              key: _repaintKey,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: _savedImagePath != null
                        ? Image.file(
                            File(_savedImagePath!),
                            fit: BoxFit.contain,
                          )
                        : Image.asset(widget.imagePath, fit: BoxFit.contain),
                  ),
                  Positioned.fill(
                    child: GestureDetector(
                      onPanStart: (details) =>
                          _addPoint(details.globalPosition),
                      onPanUpdate: (details) =>
                          _addPoint(details.globalPosition),
                      onPanEnd: (_) => _drawingController.endStroke(),
                      child: ValueListenableBuilder(
                        valueListenable: _drawingController.repaintTrigger,
                        builder: (_, __, ___) {
                          return CustomPaint(
                            painter: DrawingPainter(
                              points: _drawingController.points,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(child: _ColorPalette(controller: _drawingController)),
        ],
      ),
    );
  }
}

class _ColorPalette extends StatelessWidget {
  final DrawingController controller;
  const _ColorPalette({required this.controller});

  @override
  Widget build(BuildContext context) {
    const colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.black,
      Colors.white,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: controller.strokeWidth,
            builder: (context, width, _) {
              return Slider(
                min: 1,
                max: 20,
                value: width,
                activeColor: controller.selectedColor.value,
                inactiveColor: Colors.grey[300],
                onChanged: (value) => controller.strokeWidth.value = value,
              );
            },
          ),
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return ValueListenableBuilder(
                  valueListenable: controller.selectedColor,
                  builder: (context, selectedColor, _) {
                    return GestureDetector(
                      onTap: () =>
                          controller.selectedColor.value = colors[index],
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: colors[index],
                          shape: BoxShape.circle,
                          border: selectedColor == colors[index]
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        width: selectedColor == colors[index] ? 40 : 36,
                        height: selectedColor == colors[index] ? 40 : 36,
                        child: selectedColor == colors[index]
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;
  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          points[i]!.point,
          points[i + 1]!.point,
          points[i]!.paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
