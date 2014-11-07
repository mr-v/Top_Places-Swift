# Top Places
Demo project that follows functional requirements from the Assignment #5 of the Stanford's cs193p course "Developing iOS 7 Apps for iPhone and iPad" (2013/2014).
Implementation details vary from what was shown during lectures, including:
- implemented in Swift instead of Objective-C
- differences in architecture:
  - exploration of Ports & Adapters to decouple parts of application
  - custom UIStoryboard subclass to inject view controllers dependencies
  - separated object graph initialization
- use of automated testing:
  - unit tests and TDD for some parts
  - async tests for calls to Flickr API
- iOS 8 adaptive features:
  - single storyboard for universal app
  - revamped UISplitViewController

## Credits
Photos icons - http://icons8.com