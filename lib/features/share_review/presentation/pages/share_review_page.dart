import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/airline.dart';
import '../../domain/entities/airport.dart';
import '../bloc/share_review_bloc.dart';
import '../bloc/share_review_event.dart';
import '../bloc/share_review_state.dart';
import '../widgets/dropdown_search_field.dart';
import '../widgets/star_rating_input.dart';

class ShareReviewPage extends StatefulWidget {
  const ShareReviewPage({super.key});

  @override
  State<ShareReviewPage> createState() => _ShareReviewPageState();
}

class _ShareReviewPageState extends State<ShareReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  final _imagePicker = ImagePicker();

  File? _selectedImage;
  Airport? _selectedDepartureAirport;
  Airport? _selectedArrivalAirport;
  Airline? _selectedAirline;
  String _selectedClass = 'Economy';
  DateTime? _selectedDate;
  double _rating = 0.0;

  final List<String> _flightClasses = ['Economy', 'Business', 'First'];

  // Store loaded airports and airlines for dropdowns
  List<Airport> _airports = [];
  List<Airline> _airlines = [];

  @override
  void initState() {
    super.initState();
    // Load initial airports and airlines
    final bloc = context.read<ShareReviewBloc>();
    bloc.add(const LoadAirportsEvent(search: ''));
    bloc.add(const LoadAirlinesEvent(search: ''));
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitReview() {
    if (_formKey.currentState!.validate()) {
      final reviewData = {
        'departureAirport': _selectedDepartureAirport?.iataCode,
        'arrivalAirport': _selectedArrivalAirport?.iataCode,
        'airline': _selectedAirline?.iataCode,
        'class': _selectedClass,
        'date': _selectedDate?.toIso8601String(),
        'rating': _rating,
        'review': _reviewController.text,
        'image': _selectedImage?.path,
      };

      context.read<ShareReviewBloc>().add(SubmitReviewEvent(reviewData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Share'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocListener<ShareReviewBloc, ShareReviewState>(
        listener: (context, state) {
          if (state is ReviewSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Review submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ShareReviewError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AirportsLoaded) {
            setState(() {
              _airports = state.airports;
            });
          } else if (state is AirlinesLoaded) {
            setState(() {
              _airlines = state.airlines;
            });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Upload
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 12),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                  children: const [
                                    TextSpan(text: 'Drop Your Image Here Or '),
                                    TextSpan(
                                      text: 'Browse',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // Departure Airport
                DropdownSearchField<Airport>(
                  labelText: 'Departure Airport',
                  value: _selectedDepartureAirport,
                  displayText: (airport) =>
                      '${airport.iataCode} - ${airport.airportName}',
                  onChanged: (airport) {
                    setState(() {
                      _selectedDepartureAirport = airport;
                    });
                  },
                  onSearch: (query) {
                    context.read<ShareReviewBloc>().add(
                          LoadAirportsEvent(search: query),
                        );
                  },
                  itemBuilder: (airport) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${airport.iataCode} - ${airport.airportName}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        if (airport.cityName != null)
                          Text(
                            '${airport.cityName}, ${airport.countryName}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select departure airport';
                    }
                    return null;
                  },
                  items: _airports,
                ),

                const SizedBox(height: 16),

                // Arrival Airport
                DropdownSearchField<Airport>(
                  labelText: 'Arrival Airport',
                  value: _selectedArrivalAirport,
                  displayText: (airport) =>
                      '${airport.iataCode} - ${airport.airportName}',
                  onChanged: (airport) {
                    setState(() {
                      _selectedArrivalAirport = airport;
                    });
                  },
                  onSearch: (query) {
                    context.read<ShareReviewBloc>().add(
                          LoadAirportsEvent(search: query),
                        );
                  },
                  itemBuilder: (airport) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${airport.iataCode} - ${airport.airportName}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        if (airport.cityName != null)
                          Text(
                            '${airport.cityName}, ${airport.countryName}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select arrival airport';
                    }
                    return null;
                  },
                  items: _airports,
                ),

                const SizedBox(height: 16),

                // Airline
                DropdownSearchField<Airline>(
                  labelText: 'Airline',
                  value: _selectedAirline,
                  displayText: (airline) =>
                      '${airline.iataCode} - ${airline.airlineName}',
                  onChanged: (airline) {
                    setState(() {
                      _selectedAirline = airline;
                    });
                  },
                  onSearch: (query) {
                    context.read<ShareReviewBloc>().add(
                          LoadAirlinesEvent(search: query),
                        );
                  },
                  itemBuilder: (airline) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${airline.iataCode} - ${airline.airlineName}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        if (airline.country != null)
                          Text(
                            airline.country!,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select airline';
                    }
                    return null;
                  },
                  items: _airlines,
                ),

                const SizedBox(height: 16),

                // Class Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedClass,
                  decoration: const InputDecoration(
                    labelText: 'Class',
                  ),
                  items: _flightClasses.map((String flightClass) {
                    return DropdownMenuItem<String>(
                      value: flightClass,
                      child: Text(flightClass),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _selectedClass = value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 16),

                // Review Text
                TextFormField(
                  controller: _reviewController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Write your message...',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please write your review';
                    }
                    if (value.trim().length < 10) {
                      return 'Review must be at least 10 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Travel Date and Rating Row
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Text(
                                _selectedDate != null
                                    ? DateFormat('MMM dd, yyyy')
                                        .format(_selectedDate!)
                                    : 'Travel Date',
                                style: TextStyle(
                                  color: _selectedDate != null
                                      ? Colors.black
                                      : Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rating',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        StarRatingInput(
                          rating: _rating,
                          onRatingChanged: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Submit Button
                BlocBuilder<ShareReviewBloc, ShareReviewState>(
                  builder: (context, state) {
                    final isLoading = state is ShareReviewLoading;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
