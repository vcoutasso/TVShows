# TV Shows

**TV Shows** is a TV Series catalog app with a very boring name.

It fetches data from the [TVMaze API](https://www.tvmaze.com/api) and presents a searchable, scrollable list (at least to the extent where it can't provide more data) of series with their poster images. The user can click a show to view details and/or bookmark it, and see a list of all episodes and seasons. Episodes also have a dedicated details view.

The shows marked as favorites are persisted in a database and shown in a separate list. Lastly, the app also has an authentication screen in which the user can unlock the application using either biometry (FaceID/TouchID) or an arbitrary pin chosen when the app starts after a fresh install.

## How it was built

I opted to build the app without any dependencies or external tools, making exclusive use of Apple technologies. The app was built entirely in pure modern Swift, leveraging the (not so) new concurrency system, protocols for Protocol Oriented Programing, and all of its cool features wherever I could see fit.

The framework of choice was UIKit, using only my keyboard to create the views (view code rules!). The app implements a variation of the MVVM architecture, introducing the Coordinator pattern to handle application-wide routing (check that code out, I think it's pretty cool).

As for coding practices, I used `git` for version control following (or trying) the Conventional Commits specification for commit messages. I tried to keep commits small whenever I could, which is why there are so many of them (I also had a lot of free time).

For a while I developed the app following something that resembles TDD, so I managed to keep a pretty good unit test coverage for some time (80%+). Unfortunately, there were many features I wanted to implement so I had to relax my standards a bit and now it is barely at 40%.

Some highlights that I think are worth mentioning:

- A fairly generic, testable, and reusable networking layer
- A pretty cool, maintainable, and extendable Coordinator system (I really enjoyed building that one!)
- Data persistence with Core Data and User Defaults
- A compile-time safe representation of the TVMaze API, unit tested to guarantee that it produces valid endpoints and requests
- A little bit of Combine for stuff like inter-object communication and debouncing of the search bar

## What could be different if I had more time

From the second day onwards I started rushing a little in an attempt to try and finalize the features I wanted to implement, so I ended up taking some shortcuts. One of them was putting together unit tests a lot less than I would have hoped.

I also ended up going for some quick and dirty solutions where I thought it would be too time-consuming to do it the other way around. I tried to keep them at a minimum, but things like an abstraction layer between ViewModels and services to separate responsibilities, cleaner inter-object communication (I hate double delegates), and code refactoring to remove duplicates are things that I haven't had the chance to work on during this narrow timeframe.

I wish I'd made an exception for the no third-party tools thing to implement a CI/CD pipeline, probably using Github Actions for testing and Fastlane for automated beta releases, but I couldn't find the time to do so.

I really enjoyed building this app, even though I had to make a lot of compromises along the way. I would like it to look a bit more polished (there are some UI glitches that I have yet to resolve) with a better UX (empty search results are just blank screens, errors are not properly handled, and stuff like that).

Lastly, I just remembered that I initially wanted to implement some logging in the app. `print` statements can help a lot during development, but I'm not a fan of them.
