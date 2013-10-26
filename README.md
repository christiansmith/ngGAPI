# ngGAPI

ngGAPI is a [Google APIs](https://code.google.com/apis/console/) client for AngularJS. 

## Status

Currently Youtube, Google+, Google Calendar, and parts of Blogger and Google Drive are implemented. I'm working (as of 10/20/2013) in my spare time to support the rest of the APIs. [Erik Isaksen](https://github.com/Nevraeka) is helping with this and [an example app](https://github.com/christiansmith/ngOAuthExamples). Glad to spend some time pair programming with anyone else that wants to contribute. If you want to use ngGAPI but something is missing or doesn't work as expected, please submit an issue, or better yet a pull request. Thanks in advance!


## Install

[Bower](http://bower.io/) is the quickest way to include ngGAPI in your project.

    $ bower install git@github.com:christiansmith/ngGAPI.git --save

    <script src="components/ngGAPI/gapi.js"></script>

If you don't use Bower, just download `gapi.js` into your scripts directory.

    $ curl -O https://raw.github.com/christiansmith/ngGAPI/master/gapi.js

    <script src="your/js/path/gapi.js"></script>


## Usage

Be sure to include "gapi" as a dependency in your main app module.

    angular.module('myApp', ['gapi'])

After you register your app in the [Google APIs Console](https://code.google.com/apis/console), configure ngGAPI with credentials and whatever scopes you need for your app.

    angular.module('myApp')
      .value('GoogleApp', {
        apiKey: 'YOUR_API_KEY',
        clientId: 'YOUR_CLIENT_ID',
        scopes: [
          // whatever scopes you need for your app, for example:
          'https://www.googleapis.com/auth/drive',
          'https://www.googleapis.com/auth/youtube',
          'https://www.googleapis.com/auth/userinfo.profile'
          // ...
        ]  
      })

To use a specific service, inject it into your controllers by name. All GAPI methods return a promise.

    angular.module('myApp')
      .controller('VideosCtrl', function ($scope, Youtube) {
        $scope.videos = Youtube.search({ part: 'snippet', q: 'Search terms' })
      });


## Services

#### GAPI authorization

* GAPI.init()


#### Drive

* Files
  * [**Drive.getFiles(fileId, params)**](https://developers.google.com/drive/v2/reference/files/get)
  * [**Drive.insertFiles(data, params)**](https://developers.google.com/drive/v2/reference/files/insert)  
  * [**Drive.patchFiles(fileId, data, params)**](https://developers.google.com/drive/v2/reference/files/patch)
  * [**Drive.updateFiles(fileId, data, params)**](https://developers.google.com/drive/v2/reference/files/update)
  * [**Drive.copyFiles(fileId, data, params)**](https://developers.google.com/drive/v2/reference/files/copy)
  * [**Drive.deleteFiles(fileId)**](https://developers.google.com/drive/v2/reference/files/delete)
  * [**Drive.listFiles(params)**](https://developers.google.com/drive/v2/reference/files/list)
  * [**Drive.touchFiles(fileId)**](https://developers.google.com/drive/v2/reference/files/touch)
  * [**Drive.trashFiles(fileId)**](https://developers.google.com/drive/v2/reference/files/trash)
  * [**Drive.untrashFiles(fileId)**](https://developers.google.com/drive/v2/reference/files/untrash)
  * [**Drive.watchFiles(fileId, data)**](https://developers.google.com/drive/v2/reference/files/watch)

* About
  * [**Drive.about(params)**](https://developers.google.com/drive/v2/reference/about/get)

* Changes
  * [**Drive.getChanges(changeId)**](https://developers.google.com/drive/v2/reference/changes/get)
  * [**Drive.listChanges(params)**](https://developers.google.com/drive/v2/reference/changes/list)
  * [**Drive.watchChanges(data)**](https://developers.google.com/drive/v2/reference/changes/watch)

* Children
  * [**Drive.deleteChildren(folderId, childId)**](https://developers.google.com/drive/v2/reference/children/delete)
  * [**Drive.getChildren(folderId, childId)**](https://developers.google.com/drive/v2/reference/children/get)
  * [**Drive.insertChildren(folderId, data)**](https://developers.google.com/drive/v2/reference/children/insert)
  * [**Drive.listChildren(folderId, params)**](https://developers.google.com/drive/v2/reference/children/list)

* Parents
  * [**Drive.deleteParents(fileId, parentId)**](https://developers.google.com/drive/v2/reference/parents/delete)
  * [**Drive.getParents(fileId, parentId)**](https://developers.google.com/drive/v2/reference/parents/get)
  * [**Drive.insertParents(fileId, data)**](https://developers.google.com/drive/v2/reference/parents/insert)
  * [**Drive.listParents(fileId)**](https://developers.google.com/drive/v2/reference/parents/list)

* Permissions
  * [**Drive.deletePermissions(fileId, permissionId)**](https://developers.google.com/drive/v2/reference/permissions/delete)
  * [**Drive.getPermissions(fileId, permissionId)**](https://developers.google.com/drive/v2/reference/permissions/get)
  * [**Drive.insertPermissions(fileId, data, params)**](https://developers.google.com/drive/v2/reference/permissions/insert)
  * [**Drive.listPermissions(fileId)**](https://developers.google.com/drive/v2/reference/permissions/list)
  * [**Drive.patchPermissions(fileId, permissionId, data, params)**](https://developers.google.com/drive/v2/reference/permissions/patch)
  * [**Drive.updatePermissions(fileId, permissionId, data, params)**](https://developers.google.com/drive/v2/reference/permissions/update)
  * [**Drive.getPermissionIdForEmail(email)**](https://developers.google.com/drive/v2/reference/permissions/getIdForEmail)

* Revisions
  * [**Drive.deleteRevisions(fileId, revisionId)**](https://developers.google.com/drive/v2/reference/revisions/delete)
  * [**Drive.getRevisions(fileId, revisionId)**](https://developers.google.com/drive/v2/reference/revisions/get)
  * [**Drive.listRevisions(fileId)**](https://developers.google.com/drive/v2/reference/revisions/list)
  * [**Drive.patchRevisions(fileId, revisionId, data)**](https://developers.google.com/drive/v2/reference/revisions/patch)
  * [**Drive.updateRevisions(fileId, revisionId, data, params)**](https://developers.google.com/drive/v2/reference/revisions/update)

* Apps
  * [**Drive.listApps()**](https://developers.google.com/drive/v2/reference/apps/list)
  * [**Drive.getApps(appId)**](https://developers.google.com/drive/v2/reference/apps/get)

* Comments
  * [**Drive.deleteComments(fileId, commentId)**](https://developers.google.com/drive/v2/reference/comments/delete)
  * [**Drive.getComments(fileId, commentId, params)**](https://developers.google.com/drive/v2/reference/comments/get)
  * [**Drive.insertComments(fileId, data, params)**](https://developers.google.com/drive/v2/reference/comments/insert)
  * [**Drive.listComments(fileId, params)**](https://developers.google.com/drive/v2/reference/comments/list)
  * [**Drive.patchComments(fileId, commentId, data, params)**](https://developers.google.com/drive/v2/reference/comments/patch)
  * [**Drive.updateComments(fileId, commentId, data, params)**](https://developers.google.com/drive/v2/reference/comments/update)

* Replies
  * [**Drive.deleteReplies(fileId, commentId, replyId)**](https://developers.google.com/drive/v2/reference/replies/delete)
  * [**Drive.getReplies(fileId, commentId, replyId, params)**](https://developers.google.com/drive/v2/reference/replies/get)
  * [**Drive.insertReplies(fileId, commentId, data)**](https://developers.google.com/drive/v2/reference/replies/insert)
  * [**Drive.listReplies(fileId, commentId, params)**](https://developers.google.com/drive/v2/reference/replies/list)
  * [**Drive.patchReplies(fileId, commentId, replyId, data)**](https://developers.google.com/drive/v2/reference/replies/patch)
  * [**Drive.updateReplies(fileId, commentId, replyId, data)**](https://developers.google.com/drive/v2/reference/replies/update)

* Properties
  * [**Drive.deleteProperties(fileId, propertyKey)**](https://developers.google.com/drive/v2/reference/properties/delete)
  * [**Drive.getProperties(fileId, propertyKey)**](https://developers.google.com/drive/v2/reference/properties/get)
  * [**Drive.insertProperties(fileId, data)**](https://developers.google.com/drive/v2/reference/properties/insert)
  * [**Drive.listProperties(fileId)**](https://developers.google.com/drive/v2/reference/properties/list)
  * [**Drive.patchProperties(fileId, propertyKey, data, params)**](https://developers.google.com/drive/v2/reference/properties/patch)
  * [**Drive.updateProperties(fileId, propertyKey, data, params)**](https://developers.google.com/drive/v2/reference/properties/update)

* Channels
  * [**Drive.stopChannels(data)**](https://developers.google.com/drive/v2/reference/channels/stop)

* Realtime
  * [**Drive.getRealtime(fileId)**](https://developers.google.com/drive/v2/reference/realtime/get)
  * [**Drive.updateRealtime(fileId, params)**](https://developers.google.com/drive/v2/reference/realtime/update)


#### Youtube

Official Youtube DATA API (v3) [reference documentation](https://developers.google.com/youtube/v3/)

* Activities
  * [**Youtube.listActivities(params)**](https://developers.google.com/youtube/v3/docs/activities/list)
  * [**Youtube.insertActivities(data, params)**](https://developers.google.com/youtube/v3/docs/activities/insert)

* ChannelBanners
  * Youtube.insertChannelBanners()

* Channels
  * [**Youtube.listChannels(params)**](https://developers.google.com/youtube/v3/docs/channels/list)
  * [**Youtube.updateChannels(data, params)**](https://developers.google.com/youtube/v3/docs/channels/update)

* GuideCategories
  * [**Youtube.listGuideCategories(params)**](https://developers.google.com/youtube/v3/docs/guideCategories/list)

* PlaylistItems
  * [**Youtube.listPlaylistItems(params)**](https://developers.google.com/youtube/v3/docs/playlistItems/list)
  * [**Youtube.insertPlaylistItems(data, params)**](https://developers.google.com/youtube/v3/docs/playlistItems/insert)
  * [**Youtube.updatePlaylistItems(data, params)**](https://developers.google.com/youtube/v3/docs/playlistItems/update)
  * [**Youtube.deletePlaylistItems(params)**](https://developers.google.com/youtube/v3/docs/playlistItems/delete)
  
* Playlists
  * [**Youtube.listPlaylists(params)**](https://developers.google.com/youtube/v3/docs/playlists/list)
  * [**Youtube.insertPlaylists(data, params)**](https://developers.google.com/youtube/v3/docs/playlists/insert)
  * [**Youtube.updatePlaylists(data, params)**](https://developers.google.com/youtube/v3/docs/playlists/update)
  * [**Youtube.deletePlaylists(params)**](https://developers.google.com/youtube/v3/docs/playlists/delete)
  
* Search
  * [**Youtube.search()**](https://developers.google.com/youtube/v3/docs/search/list)
  
* Subscriptions
  * [**Youtube.listSubscriptions(params)**](https://developers.google.com/youtube/v3/docs/subscriptions/list)
  * [**Youtube.insertSubscriptions(data, params)**](https://developers.google.com/youtube/v3/docs/subscriptions/insert)
  * [**Youtube.deleteSubscriptions(params)**](https://developers.google.com/youtube/v3/docs/subscriptions/delete)
  
* Thumbnails
  * [**Youtube.setThumbnails(params)**](https://developers.google.com/youtube/v3/docs/thumbnails)
  
* VideoCategories
  * [**Youtube.listVideoCategories(params)**](https://developers.google.com/youtube/v3/docs/videoCategories/list)
  
* Videos
  * [**Youtube.listVideos(params)**](https://developers.google.com/youtube/v3/docs/videos/list)
  * [**Youtube.insertVideos(data, params)**](https://developers.google.com/youtube/v3/docs/videos/insert)
  * [**Youtube.updateVideos(data, params)**](https://developers.google.com/youtube/v3/docs/videos/update)
  * [**Youtube.deleteVideos(params)**](https://developers.google.com/youtube/v3/docs/videos/delete)
  * [**Youtube.rateVideos(params)**](https://developers.google.com/youtube/v3/docs/videos/rate)
  * [**Youtube.getVideoRatings(params)**](https://developers.google.com/youtube/v3/docs/videos/getRating)
  
* Watermarks
  * [**Youtube.setWatermarks()**](https://developers.google.com/youtube/v3/docs/watermarks/set)
  * [**Youtube.unsetWatermarks()**](https://developers.google.com/youtube/v3/docs/watermarks/unset)


#### Google+

* People
  * [**Plus.getPeople(userId)**](https://developers.google.com/+/api/latest/people/get)
  * [**Plus.searchPeople(params)**](https://developers.google.com/+/api/latest/people/search)
  * [**Plus.listPeopleByActivity(activityId, collection)**](https://developers.google.com/+/api/latest/people/listByActivity)
  * [**Plus.listPeople(userId, collection, params)**](https://developers.google.com/+/api/latest/people/list)

* Activities
  * [**Plus.listActivities(userId, collection, params)**](https://developers.google.com/+/api/latest/activities/list)
  * [**Plus.getActivities(activityId)**](https://developers.google.com/+/api/latest/activities/get)
  * [**Plus.searchActivities(params)**](https://developers.google.com/+/api/latest/activities/search)

* Comments
  * [**Plus.listComments(activityId, params)**](https://developers.google.com/+/api/latest/comments/list)
  * [**Plus.getComments(commentId)**](https://developers.google.com/+/api/latest/comments/get)

* Moments
  * [**Plus.insertMoments(userId, collection, data, params)**](https://developers.google.com/+/api/latest/moments/insert)
  * [**Plus.listMoments(userId, collection, params)**](https://developers.google.com/+/api/latest/moments/list)
  * [**Plus.removeMoments(id)**](https://developers.google.com/+/api/latest/moments/remove)

#### Calendar API

* ACL
  * [**Calendar.deleteAcl(calendarId, ruleId)**](https://developers.google.com/google-apps/calendar/v3/reference/acl/delete)
  * [**Calendar.getAcl(calendarId, ruleId)**](https://developers.google.com/google-apps/calendar/v3/reference/acl/get)
  * [**Calendar.insertAcl(calendarId, data)**](https://developers.google.com/google-apps/calendar/v3/reference/acl/insert)
  * [**Calendar.listAcl(calendarId)**](https://developers.google.com/google-apps/calendar/v3/reference/acl/list)
  * [**Calendar.updateAcl(calendarId, ruleId, data)**](https://developers.google.com/google-apps/calendar/v3/reference/acl/update)
  * [**Calendar.patchAcl(calendarId, ruleId, data)**](https://developers.google.com/google-apps/calendar/v3/reference/acl/patch)

* CalendarList
  * [**Calendar.deleteCalendarList(calendarId)**](https://developers.google.com/google-apps/calendar/v3/reference/calendarList/delete)
  * [**Calendar.getCalendarList(calendarId)**](https://developers.google.com/google-apps/calendar/v3/reference/calendarList/get)
  * [**Calendar.insertCalendarList(data)**](https://developers.google.com/google-apps/calendar/v3/reference/calendarList/insert)
  * [**Calendar.listCalendarList(params)**](https://developers.google.com/google-apps/calendar/v3/reference/calendarList/list)
  * [**Calendar.updateCalendarList(calendarId, data)**](https://developers.google.com/google-apps/calendar/v3/reference/calendarList/update)
  * [**Calendar.patchCalendarList(calendarId, data)**](https://developers.google.com/google-apps/calendar/v3/reference/calendarList/patch)

* Calendars
  * [**Calendar.clearCalendars(calendarId)**](https://developers.google.com/google-apps/calendar/v3/reference/calendars/clear)
  * [**Calendar.deleteCalendars(calendarId)**](https://developers.google.com/google-apps/calendar/v3/reference/calendars/delete)
  * [**Calendar.getCalendars(calendarId)**](https://developers.google.com/google-apps/calendar/v3/reference/calendars/get)
  * [**Calendar.insertCalendars(data)**](https://developers.google.com/google-apps/calendar/v3/reference/calendars/insert)
  * [**Calendar.updateCalendars(calendarId, data)**](https://developers.google.com/google-apps/calendar/v3/reference/calendars/update)
  * [**Calendar.patchCalendars(calendarId, data)**](https://developers.google.com/google-apps/calendar/v3/reference/calendars/patch)

* Colors
  * [**Calendar.getColors()**](https://developers.google.com/google-apps/calendar/v3/reference/colors/get)

* Events
  * [**Calendar.deleteEvents(calendarId, eventId)**](https://developers.google.com/google-apps/calendar/v3/reference/events/delete)
  * [**Calendar.getEvents(calendarId, eventId, params)**](https://developers.google.com/google-apps/calendar/v3/reference/events/get)
  * [**Calendar.importEvents(calendarId, data, params)**](https://developers.google.com/google-apps/calendar/v3/reference/events/import)
  * [**Calendar.insertEvents(calendarId, data, params)**](https://developers.google.com/google-apps/calendar/v3/reference/events/insert)
  * [**Calendar.listEventInstances(calendarId, eventId, params)**](https://developers.google.com/google-apps/calendar/v3/reference/events/instances)
  * [**Calendar.listEvents(calendarId, params)**](https://developers.google.com/google-apps/calendar/v3/reference/events/list)
  * [**Calendar.moveEvents(calendarId, eventId, params)**](https://developers.google.com/google-apps/calendar/v3/reference/events/move)
  * [**Calendar.quickAdd(calendarId, params)**](https://developers.google.com/google-apps/calendar/v3/reference/events/quickAdd)
  * [**Calendar.updateEvents(calendarId, eventId, data, params)**](https://developers.google.com/google-apps/calendar/v3/reference/events/update)
  * [**Calendar.patchEvents(calendarId, eventId, data, params)**](https://developers.google.com/google-apps/calendar/v3/reference/events/patch)
  * [**Calendar.watchEvents(calendarId, data)**](https://developers.google.com/google-apps/calendar/v3/reference/events/watch)

* FreeBusy
  * [**Calendar.freeBusy(data)**](https://developers.google.com/google-apps/calendar/v3/reference/freebusy/query)

* Settings
  * [**Calendar.getSettings(setting)**](https://developers.google.com/google-apps/calendar/v3/reference/settings/get)
  * [**Calendar.listSettings()**](https://developers.google.com/google-apps/calendar/v3/reference/settings/list)

* Channels
  * [**Calendar.stopWatching(data)**](https://developers.google.com/google-apps/calendar/v3/reference/channels/stop)

## Development

Installing the Karma test runner with `npm install karma -g`, then run the tests with `karma start`.

## Copyright and License

The library is Copyright (c) 2013 Christian Smith, and distributed under the MIT License.