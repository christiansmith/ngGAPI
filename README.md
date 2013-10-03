# ngGAPI

ngGAPI is a [Google APIs](https://code.google.com/apis/console/) client for AngularJS. 

## Status

This is a work in progress and usage is subject to change. Currently only Youtube is supported, but I'm working (as of 10/3/2013) in my spare time to implement the rest of the APIs. Glad to spend some time pair programming with anyone that wants to contribute. If you want to use ngGAPI but something is missing or doesn't work as expected, please submit an issue. Thanks in advance!


## Install

[Bower](http://bower.io/) is the quickest way to include ngDropbox in your project.

    $ bower install git@github.com:christiansmith/ngGAPI.git --save

    <script src="components/ngGAPI/gapi.js"></script>

If you don't use Bower, just download `gapi.js` into your scripts directory.

    $ curl -O https://raw.github.com/christiansmith/ngGAPI/master/gapi.js

    <script src="your/js/path/gapi.js"></script>


## Usage

...

### APIs

#### GAPI

* GAPI.init()

#### Youtube

* Youtube.listActivities(params)
* Youtube.insertActivities(data, params)

* Youtube.listChannels(params)
* Youtube.updateChannels(data, params)

* Youtube.listGuideCategories(params)

* Youtube.listPlaylistItems(params)
* Youtube.insertPlaylistItems(data, params)
* Youtube.updatePlaylistItems(data, params)
* Youtube.deletePlaylistItems(params)

* Youtube.listPlaylists(params)
* Youtube.insertPlaylists(data, params)
* Youtube.updatePlaylists(data, params)
* Youtube.deletePlaylists(params)

* Youtube.search()

* Youtube.listSubscriptions(params)
* Youtube.insertSubscriptions(data, params)
* Youtube.deleteSubscriptions(params)

* Youtube.setThumbnails(?)

* Youtube.listVideoCategories(params)

* Youtube.listVideos(params)
* Youtube.insertVideos(data, params)
* Youtube.updateVideos(data, params)
* Youtube.deleteVideos(params)


## Development

Installing the Karma test runner with `npm install karma -g`, then run the tests with `karma start`.

## Copyright and License

The library is Copyright (c) 2013 Christian Smith, and distributed under the MIT License.