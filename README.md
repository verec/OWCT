# OWCT
I stopped at the point I could switch cities between Paris and London and had at least temperature, wind speed and day+time on display  
See [the screen cast](http://OW.mov)

# To Compile

You will need Xcode 7.3.1 and Swift 2.2 _this has *not* been ported to Swift 3_

# Libraries

I used a lot of my own libraries for the UI side, though the no external dependency at all, no CocoaPods no Carthage, etc ...

# Design

Asynchronous with GCD, including when loading lazily the weather icons.

JSON manual parsing (via `NSJSONSerialization.JSONObjectWithData` obviously) because that is the most maintainable route, and exactly zero magic happens.

# Architecture

No nib, no storyboard, layout "by hand".

A variant of MVC that is much cleaner, simpler, easier to maintain. I can rant about it all day long :)

# Value Types

For `WeatherForecast` and `WeatherRecord`

# Structs vereywhere

Unless there is an interaction needed somehow with `UIKit`