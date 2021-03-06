## Rotten Tomatoes [(raw)](?raw=1)

This is a movies app displaying box office and top rental DVDs using the [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON).

Time spent: 20 hours 

### Features

#### Required

- [✔︎] User can view a list of movies. Poster images load asynchronously.
- [✔︎] User can view movie details by tapping on a cell.
- [✔︎] User sees loading state while waiting for the API.
- [✔︎] User sees error message when there is a network error: http://cl.ly/image/1l1L3M460c3C
- [✔︎] User can pull to refresh the movie list.

#### Optional

- [✔︎] All images fade in.
- [✔︎] For the larger poster, load the low-res first and switch to high-res when complete.
- [✔︎] All images should be cached in memory and disk: AppDelegate has an instance of `NSURLCache` and `NSURLRequest` makes a request with `NSURLRequestReturnCacheDataElseLoad` cache policy. I tested it by turning off wifi and restarting the app.
- [✔︎] Customize the highlight and selection effect of the cell.
- [✔︎] Customize the navigation bar.
- [✔︎] Add a tab bar for Box Office and DVD.
- [✔︎] Add a search bar: pretty simple implementation of searching against the existing table view data.

### Note:

-Full-function work nice at movies->list view.
-No autolayout implemented, some UI elements might not be aligned properly. work fine at Iphone 6 or 6s.

### Issue:

- (fixed)The error network view not show animation and appearent when pull to refresh.

### 3rd party libraries

- HUD: https://www.cocoacontrols.com/controls/cozyloadingactivity

### Installation

Run the following in command-line:
 1. Pod install
 2. Open Movies.xcworkspace



### Walkthrough

![lab_1](https://cloud.githubusercontent.com/assets/15353623/11152730/d3626e10-8a66-11e5-8edc-70ebe56d6bc9.gif)



Credits
---------
* [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
