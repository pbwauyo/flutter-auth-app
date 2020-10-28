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
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          valueIndicatorColor: Constants.SLIDER_LABEL_COLORS[_sliderValue]
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
              print("VALUE: $newValue");
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
    );
  }
}