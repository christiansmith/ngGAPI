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
   * Among the collected API's, these methods map consistently.
   *
   * THE QUESTION IS, DO THEIR SIGNATURES MAP CONSISTENTLY FROM API TO 
   * API? If so, to define an API client, we should be able to generate 
   * it from a list of resources and their respective actions. 
   */



  .factory('GAPI', function ($q, $http, GoogleApp) {

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
      resource = resource.charAt(0).toUpperCase() + resource.slice(1);
      return action + resource;
    }


    /**
     * GAPI Service Constructor
     * 
     * For each resource in the provided spec, we define methods
     * for each resource's actions.
     */
    
    function GAPI (api, version, spec) {
      var self = this
        , resources = Object.keys(spec)
        , actions
        ;

      self.api     = api;
      self.version = version;
      self.url     = [ server, api, version, '' ].join('/');

      resources.forEach(function (resource) {
        var actions = spec[resource];
        actions.forEach(function (action) {
          var method = methodName(action, resource);
          self[method] = GAPI[action](resource)
        });
      });
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

      //oauthHeader(config);

      function success(response) {
        console.log(config, response);
        deferred.resolve(response.data);
      }

      function failure(fault) {
        console.log(config, fault);
        deferred.reject(fault);
      }

      $http(config).then(success, failure);
      return deferred.promise;
    }


    /**
     * General API methods
     * 
     * These methods are used to construct a service.
     * They are not intended to be called directly on GAPI.
     */

    GAPI.get = function (resource) {
      return function (params) {
        return request({
          method: 'GET',
          url: this.url + resource,
          params: params
        });
      };
    };


    GAPI.set = function () {
      return function () {};
    };
    

    GAPI.list = function (resource) {
      return function (params) {
        return request({
          method: 'GET',
          url: this.url + resource,
          params: params
        });
      };
    };
    

    GAPI.insert = function (resource) {
      return function (data, params) {
        return request({
          method: 'POST',
          url: this.url + resource,
          data: data,
          params: params
        });
      };
    };
    

    GAPI.update = function (resource) {
      return function (data, params) {
        return request({
          method: 'PUT',
          url: this.url + resource,
          data: data,
          params: params
        });
      };
    };


    GAPI.delete = function (resource) {
      return function (params) {
        return request({
          method: 'DELETE',
          url: this.url + resource,
          params: params
        });
      };
    };


    /**
     * Authorization
     */

    GAPI.init = function () {
      var app = GAPI.app
        , deferred = $q.defer();

      gapi.load('auth', function () {
        gapi.auth.authorize({
          client_id: app.clientId,
          scope: app.scopes,
          immediate: false     
        }, function() {
          app.oauthToken = gapi.auth.getToken();
          deferred.resolve(app);
          console.log('authorization', app)
        });
      });

      return deferred.promise;  
    }

    return GAPI;
  })


  /**
   * Youtube
   *
   *   listActivities(params)
   *   insertActivities(data, params)
   *   
   *   listChannels(params)
   *   updateChannels(data, params)
   *  
   *   listGuideCategories(params)
   *  
   *   listPlaylistItems(params)
   *   insertPlaylistItems(data, params)
   *   updatePlaylistItems(data, params)
   *   deletePlaylistItems(params)
   *  
   *   listPlaylists(params)
   *   insertPlaylists(data, params)
   *   updatePlaylists(data, params)
   *   deletePlaylists(params)
   *  
   *   search() ! OOPS, this shouldn't be treated as a resource.
   *  
   *   listSubscriptions(params)
   *   insertSubscriptions(data, params)
   *   deleteSubscriptions(params)
   *  
   *   setThumbnails(?)
   *  
   *   listVideoCategories(params)
   *  
   *   listVideos(params)
   *   insertVideos(data, params)
   *   updateVideos(data, params)
   *   deleteVideos(params)
   *  
   *   getRating(?)
   * 
   */

  .factory('Youtube', function (GAPI) {
    var Youtube = new GAPI('youtube', 'v3', {
      activities:       ['list', 'insert'],
      channels:         ['list', 'update'],
      guideCategories:  ['list'],
      playlistItems:    ['list', 'insert', 'update', 'delete'],
      playlists:        ['list', 'insert', 'update', 'delete'],
      search:           ['list'], // oops, this isn't a resource either...
      subscriptions:    ['list', 'insert', 'delete'],
      thumbnails:       ['set'],
      videoCategories:  ['list'],
      videos:           ['list', 'insert', 'update', 'delete']
    });

    // Some methods don't fit the pattern
    // Define them explicitly here
    Youtube.rate = function () {};
    Youtube.getRating = function () {};

    return Youtube;
  })

