# ngGAPI

ngGAPI is a [Google APIs](https://code.google.com/apis/console/) client for AngularJS. 

## Status

This is a work in progress and usage is subject to change. Currently only Youtube is supported, but I'm working (as of 10/3/2013) in my spare time to implement the rest of the APIs. Glad to spend some time pair programming with anyone that wants to contribute. If you want to use ngGAPI but something is missing or doesn't work as expected, please submit an issue. Thanks in advance!


## Install

[Bower](http://bower.io/) is the quickest way to include ngGAPI in your project.

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

Official Youtube DATA API (v3) [reference documentation](https://developers.google.com/youtube/v3/)

* [**Youtube.listActivities(params)**](https://developers.google.com/youtube/v3/docs/activities/list)
* [**Youtube.insertActivities(data, params)**](https://developers.google.com/youtube/v3/docs/activities/insert)

* Youtube.insertChannelBanners()

* [**Youtube.listChannels(params)**](https://developers.google.com/youtube/v3/docs/channels/list)
* [**Youtube.updateChannels(data, params)**](https://developers.google.com/youtube/v3/docs/channels/update)

* [**Youtube.listGuideCategories(params)**](https://developers.google.com/youtube/v3/docs/guideCategories/list)

* Youtube.bindLiveBroadcasts()
* Youtube.controlLiveBroadcasts()
* Youtube.transitionLiveBroadcasts()
* Youtube.listLiveBroadcasts()
* Youtube.insertLiveBroadcasts()
* Youtube.updateLiveBroadcasts()
* Youtube.deleteLiveBroadcasts()

* Youtube.listLiveStreams()
* Youtube.insertLiveStreams()
* Youtube.updateLiveStreams()
* Youtube.deleteLiveStreams()

* [**Youtube.listPlaylistItems(params)**](https://developers.google.com/youtube/v3/docs/playlistItems/list)
* [**Youtube.insertPlaylistItems(data, params)**](https://developers.google.com/youtube/v3/docs/playlistItems/insert)
* [**Youtube.updatePlaylistItems(data, params)**](https://developers.google.com/youtube/v3/docs/playlistItems/update)
* [**Youtube.deletePlaylistItems(params)**](https://developers.google.com/youtube/v3/docs/playlistItems/delete)

* [**Youtube.listPlaylists(params)**](https://developers.google.com/youtube/v3/docs/playlists/list)
* [**Youtube.insertPlaylists(data, params)**](https://developers.google.com/youtube/v3/docs/playlists/insert)
* [**Youtube.updatePlaylists(data, params)**](https://developers.google.com/youtube/v3/docs/playlists/update)
* [**Youtube.deletePlaylists(params)**](https://developers.google.com/youtube/v3/docs/playlists/delete)

* [**Youtube.search()**](https://developers.google.com/youtube/v3/docs/search/list)

* [**Youtube.listSubscriptions(params)**](https://developers.google.com/youtube/v3/docs/subscriptions/list)
* [**Youtube.insertSubscriptions(data, params)**](https://developers.google.com/youtube/v3/docs/subscriptions/insert)
* [**Youtube.deleteSubscriptions(params)**](https://developers.google.com/youtube/v3/docs/subscriptions/delete)

* [**Youtube.setThumbnails(params)**](https://developers.google.com/youtube/v3/docs/thumbnails)

* [**Youtube.listVideoCategories(params)**](https://developers.google.com/youtube/v3/docs/videoCategories/list)

* [**Youtube.listVideos(params)**](https://developers.google.com/youtube/v3/docs/videos/list)
* [**Youtube.insertVideos(data, params)**](https://developers.google.com/youtube/v3/docs/videos/insert)
* [**Youtube.updateVideos(data, params)**](https://developers.google.com/youtube/v3/docs/videos/update)
* [**Youtube.deleteVideos(params)**](https://developers.google.com/youtube/v3/docs/videos/delete)
* [**Youtube.rateVideos(params)**](https://developers.google.com/youtube/v3/docs/videos/rate)
* [**Youtube.getVideoRatings(params)**](https://developers.google.com/youtube/v3/docs/videos/getRating)

* [**Youtube.setWatermarks()**](https://developers.google.com/youtube/v3/docs/watermarks/set)
* [**Youtube.unsetWatermarks()**](https://developers.google.com/youtube/v3/docs/watermarks/unset)

## Development

Installing the Karma test runner with `npm install karma -g`, then run the tests with `karma start`.

## Copyright and License

The library is Copyright (c) 2013 Christian Smith, and distributed under the MIT License.