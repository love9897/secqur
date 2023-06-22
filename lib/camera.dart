import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secqur/homePage.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  CameraController? _cameraController;
  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  CameraController? _controller;
  XFile? _imageFile;

  CameraController? get controller => _controller;
  XFile? get imageFile => _imageFile;

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(cameras[0], ResolutionPreset.medium);
      await _controller!.initialize();
      setState(() {
        _isLoading = false;
      });
    }
  }

  int pictureCount = 0;
  

  Future<void> takePicture() async {
    if (_controller!.value.isInitialized) {
      try {
        final image = await _controller!.takePicture();
        _imageFile = XFile(image.path);

        setState(() {
          pictureCount++;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MyHomePage(),
            settings: RouteSettings(
                arguments: {'image': _imageFile, 'pictureCount': pictureCount}),
          ),
        );
      } catch (e) {
        print('Error capturing image: $e');
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(controller!),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 80),
                    child: FloatingActionButton(
                        heroTag: FloatingActionButton,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.circle),
                        onPressed: () {
                          takePicture();
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
