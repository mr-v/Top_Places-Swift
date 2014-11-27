# Top Places
Demo project that follows functional requirements from the Assignment #5 of the Stanford's cs193p course "Developing iOS 7 Apps for iPhone and iPad" (2013/2014).
Implementation details vary from what was shown during lectures, including:
- implemented in Swift instead of Objective-C
- differences in architecture:
  - exploration of Ports & Adapters/Clean Architecture to decouple parts of application
  - Dependency Injection
    - custom UIStoryboard subclass to inject View Controllers dependencies
    - separated object graph initialization
- automated tests:
  - TDD: unit tests for non-GUI parts
    - HTTP requests stubbing with Nocilla
  - integration tests for calls to Flickr API
- iOS 8 adaptive features:
  - single storyboard for universal app
  - revamped UISplitViewController

## Credits
Photos icons - http://icons8.com