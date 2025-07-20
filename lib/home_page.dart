import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'config.dart';
import 'profile_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _visionController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isLoading = false;
  String _resultText = '';
  String _errorMessage = ''; 

  late final GenerativeModel _model; // Gemini model instance

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    // Gemini model ko initialize with API key 
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: GEMINI_API_KEY);

  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('Status: $val'),
      onError: (val) => print('Error: $val'),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) {
          setState(() {
            _visionController.text = val.recognizedWords;
          });
        },
        listenFor: const Duration(seconds: 30), 
        
      );
    } else {
      print("The user has denied the use of speech recognition.");
      
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _sendVision() async { 
    FocusScope.of(context).unfocus(); 
    final visionText = _visionController.text.trim();

    if (visionText.isNotEmpty) {
      
      setState(() {
        _isLoading = true;
        _resultText = '';
        _errorMessage = '';
      });

      try {
        // Gemini API call
        final content = [
  Content.text(
    'You are a smart travel planner. A user will tell you what they want.\n'
    'Based on that, generate a complete, realistic, and optimized travel itinerary.\n\n'
    'Include the following details in your response:\n'
    '1. Best way to reach the destination from user\'s city (assume city as Indore, India unless specified).\n'
    '2. Day-wise itinerary covering top attractions, local experiences, and hidden gems.\n'
    '3. Accommodation recommendations (mid-budget).\n'
    '4. Local transport options (bike rental, public transport, taxi, etc.).\n'
    '5. Top food places and local dishes to try each day.\n'
    '6. Estimated budget breakdown (travel, stay, food, entry tickets, local travel).\n'
    '7. Packing guide based on weather and location.\n'
    '8. Local tips, safety, and cultural advice.\n'
    '9. Any permits, ID cards, or rules to follow.\n'
    '10. Network availability and connectivity tips.\n\n'
    'Make it detailed but easy to understand. Be accurate with time and money estimates. Keep the tone friendly and informative.\n'
    'Respond in clean structured sections, with proper day-wise breakdown and total cost at the end.\n\n'
    'USER INPUT: ' + visionText)
];
        final response = await _model.generateContent(content); // API hit

        
        setState(() {
          _resultText = response.text ?? 'Sorry, no content was generated.';
        });
      } catch (e) {
        
        setState(() {
          _errorMessage = 'Failed to generate itinerary. Please try again. Error: ${e.toString()}';
          print('Error calling Gemini API: $e');
        });
      } finally {
        
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your trip vision or speak it.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const Icon(Icons.airplanemode_active_rounded, color: Colors.amber),
        title: const Text(
          'Itinera AI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "What's your vision for this trip?",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _visionController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "E.g. 7 days in Bali next April...",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isListening ? Icons.mic_off : Icons.mic,
                                color: Colors.green,
                              ),
                              onPressed: _toggleListening,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _sendVision, 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 2, 110, 61),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Create My Itinerary",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Expanded(
                          child: Center(
                            child: _isLoading
                                ? const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(height: 16),
                                      Text("Generating your itinerary..."),
                                    ],
                                  )
                                : _errorMessage.isNotEmpty 
                                    ? Text(
                                        _errorMessage,
                                        style: const TextStyle(color: Colors.red, fontSize: 16),
                                        textAlign: TextAlign.center,
                                      )
                                    : _resultText.isNotEmpty 
                                        ? SingleChildScrollView(
                                            child: Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.green[50],
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                _resultText,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(), 
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}