import 'dart:math';

String getGreeting() {
  var hour = DateTime.now().hour;
  var random = Random();

  List<String> morningGreetings = [
    'Good morning',
    'Rise and shine',
    'Top of the morning to you',
    'Have a great morning',
  ];

  List<String> afternoonGreetings = [
    'Good afternoon',
    'Hope you\'re having a nice day',
    'Afternoon greetings',
    'How\'s your day going?',
  ];

  List<String> eveningGreetings = [
    'Good evening',
    'Hope you had a great day',
    'Evening greetings',
    'Winding down for the day?',
  ];

  List<String> nightGreetings = [
    'Hello night owl',
    'Burning the midnight oil?',
    'Working late or early?',
    'Hope you\'re having a peaceful night',
  ];

  if (hour >= 5 && hour < 12) {
    return morningGreetings[random.nextInt(morningGreetings.length)];
  } else if (hour >= 12 && hour < 17) {
    return afternoonGreetings[random.nextInt(afternoonGreetings.length)];
  } else if (hour >= 17 && hour < 22) {
    return eveningGreetings[random.nextInt(eveningGreetings.length)];
  } else {
    return nightGreetings[random.nextInt(nightGreetings.length)];
  }
}