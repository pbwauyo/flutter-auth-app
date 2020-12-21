import 'package:auth_app/repos/memory_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArtifactSlider extends StatefulWidget{
  final String artifactId;
  final double initialValue;

  ArtifactSlider({@required this.artifactId, this.initialValue});

  @override
  _ArtifactSliderState createState() => _ArtifactSliderState();
}

class _ArtifactSliderState extends State<ArtifactSlider> {
  double _sliderValue = 0.0;

  final _memoryRepo = MemoryRepo();

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Positioned(
          top: 23.0,
          left: 15,
          child: Container(
            width: 120,
            height: 4.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey, Colors.green, Colors.blue, Colors.yellow],
                stops: [0.1, 0.4, 0.6, 0.8]
              ),
              borderRadius: BorderRadius.circular(8.0)
            ),
          ),
        ),

        Container(
          // margin: const EdgeInsets.only(left: 10),
          width: 150,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              valueIndicatorColor: Constants.SLIDER_LABEL_COLORS[_sliderValue],
              thumbColor: Constants.SLIDER_LABEL_COLORS[_sliderValue],
              activeTrackColor: Colors.transparent,
              inactiveTrackColor: Colors.transparent
            ),
            child: Slider(
              min: 0.0,
              max: 3.0,
              label: Constants.SLIDER_LABELS[_sliderValue],
              
              divisions: 3,
              value: _sliderValue, 
              onChanged: (newValue){
                setState(() {
                  _sliderValue = newValue;
                });
              },
              onChangeEnd: (newValue){
                //for now only memories can be rated
                _memoryRepo.updateMemoryRating(
                  memoryId: widget.artifactId, 
                  newRating: newValue
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}