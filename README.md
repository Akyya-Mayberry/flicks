# Project 1 - *Flicks*

**Flicks** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **7** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [X] User can view movie details by tapping on a cell.
- [X] User sees loading state while waiting for the API.
- [X] User sees an error message when there is a network error.
- [X] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [ ] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [X] Implement segmented control to switch between list view and grid view.
- [ ] Add a search bar.
- [X] All images fade in.
- [ ] For the large poster, load the low-res image first, switch to high-res when complete.
- [X] Customize the highlight and selection effect of the cell.
- [X] Customize the navigation bar.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://cloud.githubusercontent.com/assets/13710170/24595805/9a9a9b4a-17ee-11e7-9618-dfd3ea3b0365.gif' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.
Getting the refresh control to work without compiler errors. I was declaring the refreshControl, the function and everything inside the viewDidLoad() which was a problematic. I found a nice YouTube tutorial that help me work through it quickly. I struggled with getting the error messages to print from requests. I later discovered nothing was printing to the console because I some how disabled the console in XCode. When adding features to refresh data and add a toggable collection view with the table view, I feel like my code got really sloppy with lots of repeated code. I ran into some issues with toggling from list(table) view to grid(collections) view involving duplicate API's while building cells. Resolving that issue may have broke the fade-animation feature. 

## License

    Copyright [yyyy] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
