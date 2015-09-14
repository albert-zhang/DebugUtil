# AZDebugUtil


Debug log to console/UI/File utilities for iOS development. With the NSLog's alternatives, you can easily manage the log statements by the preprocessors. And you can easily save log to file.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

AZDebugUtil is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AZDebugUtil"
```

- Add the `#import "Debug.h"` to your prefix header file. If it is not exist you could create one, then update the setting in `Build Settings` > `Apple LLVM - Language` > `Prefix Header`
- Copy the precompile defines to the prefix header file from `Debug.h`, and uncomment them as your need
- In `application:didFinishLaunchingWithOptions:` in `UIApplicationDelegate`, call `[DebugLogView sharedView]` to init the log UI if you need to see the log on UI
- Then you can use the `DebugLog`, `DebugLogError`, `FileLogger`, ...

## Example

	DebugLog(@"we got here: %d", theId);
	DebugLogWarning(@"the name is nil for people: %@", people.uid);
	DebugLogError(@"should never get here");
	
	[FileLogger log:@"we got %d peoples here", peoples.count];
	
	[DebugTip show:@"Hello!"];
	
	[UIAlertView showWithTitle:@"Hi" message:@"show the value?" onDismiss:
	    ^(UIAlertView *alertView, NSInteger buttonIndex) {
	        if(buttonIndex != alertView.cancelButtonIndex){
	            [self showDebugValue];
	        }
	    } cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];

## Sepcial Preprocessors in Debug.h

- **DEBUG_LOG_ENABLED** The master swith of the log function. Comment it will turn off all logs. You can do this when building for release.
- **DEBUG_LOG_TO_CONSOLE** Comment to turn off log to console.
- **DEBUG_LOG_TO_UI** Comment to turn off log to UI (the `DebugLogView`). Note that the `DebugLogView` is disabled by default, for performance consideration. When you turn on this, there will be small button "[D]" on the window, tap it will open the view. And in the view there is a swith to enable the log.
- **DEBUG_LOG_EW_TO_FILE** Auto log error and warning to the log files. The log files are stored in the app's document directory, named _log_001.txt_.

**All the preprocessors above should be undefined (or simply comment them) before releasing.**

