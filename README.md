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

No nib, no storyboard, layout "by hand". With, _not so surprisingly_, very little code (all in the `layoutSubviews` methods). No need for the overkill, over-engineered and far from complete `AutoLayout`, when all you need to get _exactly_ what you want are a few extensions on the `CGRect` struct (provided). e.g.:

        let top = self.bounds.top(Sizes.CitySelector.height)  
        let mid = self.bounds.shrink(.Top, by: Sizes.CitySelector.height)  
                             .shrink(.Bottom, by: Sizes.Guides.bottomGuide)  
                             .insetBy(dx:30.0, dy: 0.0)  
      
        citySelector.sizeToFit()  
        citySelector.frame = citySelector.bounds.centered(intoRect: top)  
        tableView.frame = mid  

A variant of MVC that is much cleaner, simpler, easier to maintain. I can rant about it all day long :)

## Network and REST

A simple `Network` struct that just tunnels the request to/from the server with no application knowledge, A `Configuration` (and its extensions) used by the `Loader` struct that does know about OpenWeather requirements.

## User Interface

The simplest I could think of. Scales across iPhone models. The choice I made is to have 7 rows exactly whose height varies according to the device.

Note that scrolling always stops on cell boundaries.

## Value Types

For `WeatherForecast` and `WeatherRecord`

## Structs vereywhere

Unless there is an interaction needed somehow with `UIKit`

## Error Handling

This needs doing. Right now network errors are simply ignored and nothing happens at all, not even letting the user know about it.

## Alternative UI

Take a lesson from Apple watchOS and present each day as a circle with 6 points for 0, 3, 6, 12, 15 & 18, with only temp+icon (ignore wind), with one such circle per cell, and the name of the day of the week as label for the whole circle. Since I currently have seven rows, this is a perfect fit for "weather in the next 7 days".

## Unit Tests

Extremely minimal (just one method of the `Configuration`).

At the minimum we would need to  unit test JSON parsing with a bunch of sample JSON answers stored in the bundle, and checking that the resulting `WeatherForecast` and `WeatheRecord` match expectations.

More generaly, anything that can be seen as a _pure function_, for example data processing/transformation (as in JSON processing alluded above) should be unit tested.

Note that my architecture, by exposing well known applications entitites through the `WellKnown` structs facilitates testing without mocks.
