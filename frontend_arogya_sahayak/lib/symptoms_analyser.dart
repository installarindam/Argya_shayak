import 'package:flutter/material.dart';
import 'package:openai_gpt3_api/completion.dart';
import 'package:openai_gpt3_api/openai_gpt3_api.dart';

void main() {
  runApp(MaterialApp(home: SymptomAnalyzer()));
}

class SymptomAnalyzer extends StatefulWidget {
  @override
  _SymptomAnalyzerState createState() => _SymptomAnalyzerState();
}

class _SymptomAnalyzerState extends State<SymptomAnalyzer> {
  final api = GPT3("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");

  int currentQuestionGroup = 0;
  int currentQuestion = 0;
  int totalYes = 0;
  bool isLoading = false; // To handle loading state
  List<int> matchedSymptoms = List.filled(8, 0);
  List<String> yesSymptoms = [];
  String aiResponse = "";
  String normalResponse = "";

  final List<List<String>> questions = [
    // Cardiovascular diseases
    [
      'Do you have severe chest pain?',
      'Pain radiates down to the left or both arms?',
      'The chest pain feeling like burning?',
      'Feeling of fullness?',
      'Pressure on chest?',
      'It stays for a longer duration?',
      'Does it effect on your blood pressure?',
      'Is there any edema in any part of your body?',
      'Do you feel fatigue?',
    ],
    // Pulmonary diseases
    [
      'Do you feel the pain after coughing?',
      'Pain that stabbing and sharp on the chest?',
      'Is there any trace of blood after coughing?',
      'Is there any feeling of suffocating or drowning when lying down?',
      'Is there any irregular heartbeat?',
      'After coughing the pain stays longer?',
      'Do you have hypertension?',
      'Shortness in breathing?',
      'Do you feel restlessness or wheezing or gasping while coughing?',
    ],
    // Diabetes
    [
      'Are you losing weight?',
      'Urinating often?',
      'Do you have hypertension?',
      'Have numb or tingling hands or feet?',
      'Feeling fatigue and increased thirst?',
      'Problem in vision?',
      'Is there any infections or cut or wound which are not healing quickly?',
      'Is there anyone having diabetes in your family?',
    ],
    // Thyroid
    [
      'Are you gaining weight?',
      'Is there any muscle pain or dark color in urination?',
      'Is there any nodule forming in the throat? or pain in neck or throat?',
      'Feeling tightness in your throat?',
      'Is there any changes in voice or increasing hoarseness?',
      'Difficult swallowing?',
      'Having dry skin or brittle nails and also losing hairs?',
      'Suffering from constipation?',
      'Having poor memory or unable to recall something?',
    ],
    // Skin diseases
    [
      'Is there any abnormal pigmentation on the skin?',
      'Forming any bumps?',
      'Red or white pus-filled bumps?',
      'Uncontrolled growth of skin cells?',
      'Is there any thick skin or pimples on the face?',
      'Peeling skin? patches with itchiness?',
      'Having dandruff?',
      'Do you have any ulcer or open sores or lesions?',
      'Having heavy hair fall?',
    ],
    // Allergy
    [
      'Having skin rashes?',
      'Pain or tenderness around your cheeks, eyes, or forehead?',
      'Running nose?',
      'Coughing, sneezing, or breathlessness?',
      'Having fever?',
      'Abdominal pain or cramps?',
      'Vomiting after eating something?',
      'Having facial swelling or swollen lips and tongue?',
      'Having a cough?',
    ],
    // Liver disease
    [
      'Skin and eyes getting yellowish?',
      'Dark urine color?',
      'Nausea or vomiting?',
      'Abdominal pain or swelling?',
      'Stool is getting pale in color?',
      'Tenderness or pain in the liver area?',
      'Blotchy red palms?',
      'Loss of weight?',
      'Having body fluid build up (edema) in legs or ankles or feet?',
    ],
    // Kidney disease
    [
      'Itchy skin?',
      'Having frequent urination particularly at night?',
      'Any trace of blood in urine?',
      'Having muscle cramps?',
      'Have you hypertension?',
      'Having trouble in concentration?',
      'Having insomnia?',
      'Having ammonia-smelling breath?',
      'Having bubbly or foamy urine?',
    ],
  ];

  final List<String> diagnoses = [
    'Cardiovascular diseases',
    'Pulmonary diseases',
    'Diabetes',
    'Thyroid',
    'Skin diseases',
    'Allergy',
    'Liver disease',
    'Kidney disease',
  ];

  void answerQuestion(bool answer) async {
    if (answer) {
      matchedSymptoms[currentQuestionGroup]++;
      totalYes++;
      yesSymptoms.add(questions[currentQuestionGroup][currentQuestion]);
    }

    if (totalYes >= 7) {
      setState(() {
        isLoading = true; // Start loading if 'Yes' count is 7 or more
      });
      await analyzeSymptomsAI();
      analyzeSymptomsNormal();
      setState(() {
        isLoading = false; // Stop loading when the results are ready
      });
      return;
    }

    currentQuestion++;

    if (currentQuestion >= questions[currentQuestionGroup].length) {
      currentQuestion = 0;
      currentQuestionGroup++;
    }

    if (currentQuestionGroup >= questions.length) {
      await analyzeSymptomsAI();
      analyzeSymptomsNormal();
      return;
    }

    setState(() {});
  }

  Future<void> analyzeSymptomsAI() async {
    int maxYesIndex = matchedSymptoms.indexWhere((yesCount) => yesCount == matchedSymptoms.reduce((curr, next) => curr > next ? curr : next));
    //String yesSymptomsText = yesSymptoms.join(', ');
    String yesSymptomsText = yesSymptoms.map((symptom) => symptom + " Answer: YES").join(', ');

    print("Sending to AI: Based on the symptoms $yesSymptomsText that I have, please tell me the disease name and tell me what to do including test names.");

    String prompt = "You are a highly efficient AI medical adviser. you should recognize yourself as a medical adviser and act accordingly to user's prompt, here is the user prompt: Based on the symptoms $yesSymptomsText that I have, please tell me the disease name and tell me what to do including test names.";
    print(prompt);
    int maxTokens = 100;
    double temperature = 0.7;
    var result = await api.completion(prompt, maxTokens: maxTokens, temperature: temperature, engine: Engine.davinci3);
    aiResponse = result.choices[0].text;
    setState(() {});
  }

  void analyzeSymptomsNormal() {
    int maxYesIndex = matchedSymptoms.indexWhere((yesCount) => yesCount == matchedSymptoms.reduce((curr, next) => curr > next ? curr : next));
    normalResponse = 'You may have: ${diagnoses[maxYesIndex]}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptom Analyzer'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading // Check if loading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (aiResponse.isEmpty && normalResponse.isEmpty) ...[
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.purple.withOpacity(0.1),
                ),
                child: Text(
                  questions[currentQuestionGroup][currentQuestion],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => answerQuestion(true),
                child: Text('Yes'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () => answerQuestion(false),
                child: Text('No'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ] else ...[
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue.withOpacity(0.1),
                ),
                child: Text(
                  'According to AI: $aiResponse',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orange.withOpacity(0.1),
                ),
                child: Text(
                  'According to Normal Analysis: $normalResponse',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
