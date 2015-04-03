'use strict';

angular.module('gapi', [])

  /**
   * GAPI exposes many services, but their respective APIs follow
   * a pattern. This is fortunate. We can define a core abstraction
   * for communicating with all google apis, and then specialize it
   * for each service.
   *
   * The reponsibility of this general service is to implement the
   * authorization flow, and make requests on behalf of a dependent
   * API specific service.
   *
   * Each google API maps specific methods to HTTP verbs.
   *
   *     METHOD         HTTP
   *     list           GET
   *     insert         POST
   *     update         PUT
   *     delete         DELETE
   *     etc            ...
   *
   * Among the collected API's, these methods appear to map consistently.
   */



  .factory('GAPI', function ($q, $http, $log, GoogleApp) {

    /**
     * GAPI Credentials
     */
    GAPI.app = GoogleApp;


    /**
     * Google APIs base URL
     */

    var server = 'https://www.googleapis.com';


    /**
     * Generate a method name from an action and a resource
     */

    function methodName (action, resource) {
      // allow resources with a path prefix
      resource = resource.split('/').pop()
      // uppercase the first character
      resource = resource.charAt(0).toUpperCase() + resource.slice(1);
      return action + resource;
    }


    /**
     * Recurse through a "spec" object and create methods for 
     * resources and nested resources.
     * 
     * For each resource in the provided spec, we define methods
     * for each of the its actions.
     */

    function createMethods (service, spec, parents) {
      var resources = Object.keys(spec);

      resources.forEach(function (resource) {
        var actions = spec[resource];

        actions.forEach(function (action) {

          // if the action is an object, treat it as a nested
          // spec and recurse
          if (typeof action === 'object') {

            if (!parents) { parents = []; }
            // we can't keep passing around the 
            // same array, we need a new one
            var p = parents.concat([resource]); 
            createMethods(service, action, p);

          } else {

            var method = methodName(action, resource);
            service[method] = GAPI[action](resource, parents);

          }
        });
      });
    }


    /**
     * GAPI Service Constructor
     */

    function GAPI (api, version, spec) {
      this.api     = api;
      this.version = version;
      this.url     = [ server, api, version, '' ].join('/');

      createMethods(this, spec);
    }


    /**
     * OAuth 2.0 Signatures
     */

    function oauthHeader(options) {
      if (!options.headers) { options.headers = {}; }
      options.headers['Authorization'] = 'Bearer ' + GAPI.app.oauthToken.access_token;
    }

    function oauthParams(options) {
      if (!options.params) { options.params = {}; }
      options.params.access_token = GAPI.app.oauthToken.access_token;
    }


    /**
     * HTTP Request Helper
     */

    function request (config) {
      var deferred = $q.defer();

      oauthHeader(config);

      function success(response) {
        $log.log('Request success: ', config, response);
        if(response.data)
            deferred.resolve(response.data);
        else
            deferred.resolve(response);
      }

      function failure(fault) {
        $log.log('Request failure: ', config, fault);
        deferred.reject(fault);
      }

      $http(config).then(success, failure);
      return deferred.promise;
    }


    GAPI.request = request;


    /**
     * HTTP GET method available on service instance
     */

    GAPI.prototype.get = function () {
      var args = Array.prototype.slice.call(arguments)
        , path = []
        , params
        ;

      args.forEach(function (arg, i) {
        if (arg && typeof arg !== 'object') {
          path.push(arg); 
        } else {
          params = arg
        }
      });  

      return request({
        method: 'GET',
        url:    this.url + path.join('/'),
        params: params
      });
    };


    /**
     * HTTP POST method available on service instance
     */

    GAPI.prototype.post = function () {
      var args = Array.prototype.slice.call(arguments)
        , path = []
        , other = 0
        , data
        , params
        ;

      args.forEach(function (arg, i) {
        if (!arg || typeof arg === 'object') { // if the arg is not part of the path
          other += 1;                          // increment the number of nonpath args
          if (other === 1) { data   = arg; }
          if (other === 2) { params = arg; }
        } else {                               // if the arg is defined and not and object
          path.push(arg);                      // push to the path array
        }
      });

      return request({
        method: 'POST',
        url:    this.url + path.join('/'),
        data:   data,
        params: params
      });
    }


    /**
     * Build a resource url, optionally with nested resources
     */

    function resourceUrl (args, parents, base, resource) {
      var argIndex = 0
        , nodes = []
        , params = args[args.length.toString()]
        ;

      if (parents && parents.length > 0) {
        parents.forEach(function (parent, i) {
          nodes.push(parent, args[i.toString()])
          argIndex += 1;
        });
      } 

      nodes.push(resource);
      if (['string', 'number'].indexOf(typeof args[argIndex.toString()]) !== -1) {
        nodes.push(args[argIndex.toString()]);
      }

      return base += nodes.join('/');
    }


    /**
     * Parse params from arguments
     */

    function parseParams (args) {
      var last = args[(args.length - 1).toString()];
      return (typeof last === 'object') ? last : null
    }


    /**
     * Parse data and params from arguments
     */

    function parseDataParams (a) {
        var args = Array.prototype.slice.call(a)
          , parsedArgs = {}
          , other = 0
          ;

        args.forEach(function (arg, i) {
          if (!arg || typeof arg === 'object') {
            other += 1;
            if (other === 1) { parsedArgs.data   = arg; }
            if (other === 2) { parsedArgs.params = arg; }
          } 
        });

        return parsedArgs;
    }


    /**
     * Resource methods
     * 
     * These methods are used to construct a service.
     * They are not intended to be called directly on GAPI.
     */


    GAPI.get = function (resource, parents) {
      return function () {
        return request({
          method: 'GET',
          url:    resourceUrl(arguments, parents, this.url, resource),
          params: parseParams(arguments)
        });
      };
    };


    GAPI.set = function (resource, parents) {
      return function () {
        return request({
          method: 'POST',
          url:    resourceUrl(arguments, parents, this.url, resource) + '/set', 
          params: parseParams(arguments)
        });
      };
    };


    GAPI.unset = function (resource, parents) {
      return function () {
        return request({
          method: 'POST',
          url:    resourceUrl(arguments, parents, this.url, resource) + '/unset', 
          params: parseParams(arguments)
        });
      };
    };


    GAPI.list = function (resource, parents) {
      return function () {
        return request({
          method: 'GET',
          url:    resourceUrl(arguments, parents, this.url, resource),
          params: parseParams(arguments)
        });
      };
    };


    GAPI.insert = function (resource, parents) {
      return function () {
        var args = parseDataParams(arguments);
        return request({
          method: 'POST',
          url:    resourceUrl(arguments, parents, this.url, resource),
          data:   args.data,
          params: args.params
        });
      };
    };


    GAPI.update = function (resource, parents) {
      return function () {
        var args = parseDataParams(arguments);
        return request({
          method: 'PUT',
          url:    resourceUrl(arguments, parents, this.url, resource),
          data:   args.data,
          params: args.params
        });
      };
    };


    GAPI.patch = function (resource, parents) {
      return function () {
        var args = parseDataParams(arguments);
        return request({
          method: 'PATCH',
          url:    resourceUrl(arguments, parents, this.url, resource),
          data:   args.data,
          params: args.params
        });
      };
    };


    GAPI.delete = function (resource, parents) {
      return function () {
        return request({
          method: 'DELETE',
          url:    resourceUrl(arguments, parents, this.url, resource),
          params: parseParams(arguments)
        });
      };
    };


    /**
     * Authorization
     */

    GAPI.init = function () {
      var app = GAPI.app,
        deferred = $q.defer(),
        attemptCounter = 0,
        onAuth = function (response) {
          attemptCounter++;
          if(attemptCounter > 3) {
              deferred.reject('Login attempt failed. Attempted to login ' + attemptCounter + ' times.');
              return;
          }
          // The response could tell us the user is not logged in.
          if(response && !response.error) {
              if(response.status && response.status.signed_in === true) {
                  app.oauthToken = gapi.auth.getToken();
                  deferred.resolve(app);
              } else {
                  deferred.reject("App failed to log-in to Google API services.");
              }
          } else {
              deferred.notify('Login attempt failed. Trying again. Attempt #' + attemptCounter);
              gapi.auth.authorize({
                client_id: app.clientId,
                scope: app.scopes,
                immediate: false
                }, onAuth
              );
          }
        };

      deferred.notify('Trying to log-in to Google API services.');

      gapi.auth.authorize({
        client_id: app.clientId,
        scope: app.scopes,
        immediate: true
        }, onAuth
      );

      return deferred.promise;
    }

    return GAPI;
  })


  /**
   * Youtube API
   */

  .factory('Youtube', function (GAPI) {
    var Youtube = new GAPI('youtube', 'v3', {
      activities:       ['list', 'insert'],
      channels:         ['list', 'update'],
      guideCategories:  ['list'],
      liveBroadcasts:   ['list', 'insert', 'update', 'delete'],
      liveStreams:      ['list', 'insert', 'update', 'delete'],
      playlistItems:    ['list', 'insert', 'update', 'delete'],
      playlists:        ['list', 'insert', 'update', 'delete'],
      subscriptions:    ['list', 'insert', 'delete'],
      thumbnails:       ['set'],
      videoCategories:  ['list'],
      videos:           ['list', 'insert', 'update', 'delete'],
      watermarks:       ['set', 'unset']
    });

    // Some methods don't fit the pattern
    // Define them explicitly here
    Youtube.insertChannelBanners = function () {};

    Youtube.bindLiveBroadcasts = function () {};
    Youtube.controlLiveBroadcasts = function () {};
    Youtube.transitionLiveBroadcasts = function () {};

    Youtube.rateVideos = function (params) {
      return Youtube.post('videos', 'rate', undefined, params);
    };

    Youtube.getVideoRating = function (params) {
      return Youtube.get('videos', 'getRating', params);
    };

    Youtube.search = function (params) {
      return Youtube.get('search', params);
    }

    return Youtube;
  })


  /**
   * Blogger API
   */


  .factory('Blogger', function (GAPI) {

    var Blogger = new GAPI('blogger', 'v3', {
      users:        ['get'],
      blogs:        ['get', {
        pages:      ['list', 'get', 'insert', 'update', 'patch', 'delete'],
        posts:      ['list', 'get', 'insert', 'update', 'patch', 'delete', {
          comments: ['list', 'get', 'delete']
        }]
      }]
    });


    Blogger.getBlogByUrl = function (params) {
      return Blogger.get('blogs', 'byurl', params);
    };


    Blogger.listBlogsByUser = function (userId, params) {
      return Blogger.get('users', userId, 'blogs', params);
    };


    Blogger.approveComments = function (blogId, postId, commentId) {
      return Blogger.post('blogs', blogId, 'posts', postId, 'comments', commentId, 'approve');
    };


    Blogger.listCommentsByBlog = function (blogId, params) {
      return Blogger.get('blogs', blogId, 'comments', params);
    };


    Blogger.markCommentsAsSpam = function (blogId, postId, commentId) {
      return Blogger.post('blogs', blogId, 'posts', postId, 'comments', commentId, 'spam');
    };


    Blogger.removeContent = function (blogId, postId, commentId) {
      return Blogger.post('blogs', blogId, 'posts', postId, 'comments', commentId, 'removecontent');
    };


    Blogger.searchPosts = function (blogId, params) {
      return Blogger.get('blogs', blogId, 'posts/search', params);
    };


    Blogger.getPostsByPath = function (blogId, params) {
      return Blogger.get('blogs', blogId, 'posts/bypath', params);
    };


    Blogger.publishPosts = function (blogId, postId, params) {
      return Blogger.post('blogs', blogId, 'posts', postId, 'publish', undefined, params);
    };


    Blogger.revertPosts = function (blogId, postId) {
      return Blogger.post('blogs', blogId, 'posts', postId, 'revert');
    };


    Blogger.getBlogUserInfos = function (userId, blogId, params) {
      return Blogger.get('users', userId, 'blogs', blogId, params);
    };


    Blogger.getPageViews = function (blogId, params) {
      return Blogger.get('blogs', blogId, 'pageviews', params);
    };


    Blogger.getPostUserInfos = function (userId, blogId, postId, params) {
      return Blogger.get('users', userId, 'blogs', blogId, 'posts', postId, params);
    };


    Blogger.listPostUserInfos = function (userId, blogId, params) {
      return Blogger.get('users', userId, 'blogs', blogId, 'posts', params);
    };


    return Blogger;

  })


  /**
   * Calendar API
   */

  .factory('Calendar', function (GAPI) {
    var Calendar = new GAPI('calendar', 'v3', {
      colors: ['get'],
      calendars: ['get', 'insert', 'update', 'delete', 'patch', {
        acl:     ['list', 'get', 'insert', 'update', 'delete', 'patch'],
        events:  ['list', 'get', 'insert', 'update', 'delete', 'patch']
      }],
      'users/me/calendarList': ['list', 'get', 'insert', 'update', 'delete', 'patch'],
      'users/me/settings': ['list', 'get']
    });


    Calendar.clearCalendar = function (id, params) {
      return Calendar.post('calendars', id, 'clear', undefined, params);
    };

    Calendar.importEvents = function (calendarId, data, params) {
      return Calendar.post('calendars', calendarId, 'events', 'import', data, params);
    };

    Calendar.moveEvents = function (calendarId, eventId, destinationId) {
      return Calendar.post('calendars', calendarId, 'events', eventId, 'move', undefined, {
        destination: destinationId
      });
    };

    Calendar.listEventInstances = function (calendarId, eventId, params) {
      return Calendar.get('calendars', calendarId, 'events', eventId, 'instances', params);
    };

    Calendar.quickAdd = function (id, params) {
      return Calendar.post('calendars', id, 'events', 'quickAdd', undefined, params);
    };

    Calendar.watchEvents = function (id, data, params) {
      return Calendar.post('calendars', id, 'events', 'watch', data, params);
    };

    Calendar.freeBusy = function (data) {
      return Calendar.post('freeBusy', data);
    }

    Calendar.stopWatching = function (data) {
      return Calendar.post('channels', 'stop', data)
    };

    return Calendar;
  })


  /**
   * Drive API
   */

  .factory('Drive', function (GAPI) {
    var Drive = new GAPI('drive', 'v2', {
      files:          ['get', 'list', 'insert', 'update', 'delete', 'patch', {
        children:     ['get', 'list', 'insert', 'delete'],
        parents:      ['get', 'list', 'insert', 'delete'],
        permissions:  ['get', 'list', 'insert', 'update', 'delete', 'patch'],
        revisions:    ['get', 'list', 'update', 'delete', 'patch'],
        comments:     ['get', 'list', 'insert', 'update', 'delete', 'patch', {
          replies:      ['get', 'list', 'insert', 'update', 'delete', 'patch']
        }],
        properties:   ['get', 'list', 'insert', 'update', 'delete', 'patch'],
        realtime:     ['get']
      }],
      changes: ['get', 'list'],
      apps: ['get', 'list']
    });

    Drive.copyFile = function (fileId, data, params) {
      return Drive.post('files', fileId, 'copy', data, params);
    };

    Drive.touchFile   = function (fileId) {
      return Drive.post('files', fileId, 'touch');
    };

    Drive.trashFile   = function (fileId) {
      return Drive.post('files', fileId, 'trash');
    };

    Drive.untrashFile = function (fileId) {
      return Drive.post('files', fileId, 'untrash');
    };

    Drive.watchFile   = function (fileId, data) {
      return Drive.post('files', fileId, 'watch', data);
    };

    Drive.about = function (params) {
      return Drive.get('about', params);
    }

    Drive.watchChanges = function (data) {
      return Drive.post('changes', 'watch', data);
    };

    Drive.getPermissionIdForEmail = function (email) {
      return Drive.get('permissionIds', email);
    };

    Drive.stopChannels = function (data) {
      return Drive.post('channels', 'stop', data);
    };

    Drive.updateRealtime = function (fileId, params) {
      return GAPI.request({
        method: 'PUT',
        url:    Drive.url + ['files', fileId, 'realtime'].join('/'),
        params: params
      });
    };


    return Drive;
  })


  /**
   * Google+ API
   */

  .factory('Plus', function (GAPI) {
    var Plus = new GAPI('plus', 'v1', {
      people:       ['get', {
        activities: ['list']
      }],
      activities:   ['get', {
        comments:   ['list']
      }],
      comments:     ['get']
    });

    Plus.searchPeople = function (params) {
      return Plus.get('people', params);
    };

    Plus.listPeopleByActivity = function (activityId, collection, params) {
      return Plus.get('activities', activityId, 'people', collection, params);
    };

    Plus.listPeople = function (userId, collection, params) {
      return Plus.get('people', userId, 'people', collection, params);
    }

    Plus.searchActivities = function (params) {
      return Plus.get('activities', params);
    };

    Plus.insertMoments = function (userId, collection, data, params) {
      return Plus.post('people', userId, 'moments', collection, data, params);
    };

    Plus.listMoments = function (userId, collection, params) {
      return Plus.get('people', userId, 'moments', collection, params);
    };

    Plus.removeMoments = function (id) {
      return GAPI.request({
        method: 'DELETE',
        url:    Plus.url + ['moments', id].join('/')
      });
    };

    return Plus;
  })


  /**
   * Admin Directory API
   */

  .factory('Directory', function (GAPI) {
    var Directory = new GAPI('admin/directory', 'v1', {
      users: ['get', 'insert', 'update', 'delete'],
      groups: ['get', 'insert', 'update', 'delete', 'list', 'patch', {
          members: ['get', 'insert', 'update', 'delete', 'patch', 'list']
      }],
    });

    Directory.makeAdmin = function (id) {
      var data = {'status':true};
      return Directory.post('users', id, 'makeAdmin', data);
    };

    Directory.unMakeAdmin = function (id) {
      var data = {'status':false};
      return Directory.post('users', id, 'makeAdmin', data);
    };

    Directory.listUsers = function (params) {
      return Directory.get('users', params);
    };

    return Directory;
  })

