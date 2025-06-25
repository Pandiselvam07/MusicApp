import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/features/home/repository/home_repository.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final TextEditingController artistController = TextEditingController();
  final TextEditingController songNameController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selectedAudio;

  @override
  void dispose() {
    artistController.dispose();
    songNameController.dispose();
    super.dispose();
  }

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Upload Song')),
        actions: [
          IconButton(
            onPressed: () async {
              await HomeRepository().uploadSong(
                song: selectedAudio!,
                thumbnail: selectedImage!,
              );
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: selectImage,
                child: selectedImage != null
                    ? SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        ),
                      )
                    : DottedBorder(
                        options: RectDottedBorderOptions(
                          strokeCap: StrokeCap.round,
                          color: Pallete.borderColor,
                          dashPattern: [8, 4],
                          strokeWidth: 2.5,
                        ),
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.folder_open_outlined, size: 40),
                              SizedBox(height: 15),
                              Text(
                                'Select the thumbnail for your song',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 40),
              selectedAudio != null
                  ? AudioWave(path: selectedAudio!.path)
                  : CustomTextField(
                      hintText: 'Pick Song',
                      controller: null,
                      readOnly: true,
                      onTap: selectAudio,
                    ),
              const SizedBox(height: 20),
              CustomTextField(hintText: 'Artist', controller: artistController),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: 'Song name',
                controller: artistController,
              ),
              const SizedBox(height: 20),
              ColorPicker(
                showColorName: true,
                pickersEnabled: {ColorPickerType.wheel: true},
                color: selectedColor,
                onColorChanged: (Color color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
