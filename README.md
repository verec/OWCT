## OWCT
I stopped at the point I could switch cities between Paris and London and had at least temperature, wind speed and day+time on display  
See [the screen cast](https://www.dropbox.com/s/6p1v9snwe5o2c79/OW.mov?dl=0)

## To Compile

You will need Xcode 7.3.1 and Swift 2.2 _this has *not* been ported to Swift 3_

## Libraries

I used some of my own libraries for the UI side, though no external dependency at all, no CocoaPods no Carthage, etc ...

## Design

Asynchronous with GCD, including when loading lazily the weather icons.

JSON manual parsing (via `NSJSONSerialization.JSONObjectWithData` obviously) because that is the most maintainable route, and exactly zero magic happens.

## Architecture

No nib, no storyboard, layout "by hand". With, _not so surprisingly_, very little code (all in the `layoutSubViews` methods). No need for the overkill, over-engineered and far from complete `AutoLayout`, when all you need to get _exactly_ what you want is a few extension on the `CGRect` struct (provided).

A variant of MVC that is much cleaner, simpler, easier to maintain. I can rant about it all day long :)

## User Interface

The simplest I could think of. Scales across iPhone models. The choice I made is to have 7 rows exactly whose height varies according to the device.

Note that scrolling always stops on cell boundaries.

## Value Types

For `WeatherForecast` and `WeatherRecord`

## Structs vereywhere

Unless there is an interaction needed somehow with `UIKit`