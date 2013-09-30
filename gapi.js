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

  .factory('GAPI', function ($q, $http, GAPIconfig) {

    /**
     * Google APIs base URL
     */

    var baseUrl = 'https://www.googleapis.com/'

    /**
     * HTTP Request Helper
     */

    function request(config) {
      var deferred = $q.defer();

      if (!config.params) { config.params = {}; }
      config.params.access_token = GAPIconfig.oauthToken.access_token;

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
     * General API method calls
     */

    var methods = {
      

      get: function (baseUrl, resource) {
        return function (params) {
          return request({
            method: 'GET',
            url: baseUrl + resource,
            params: params
          });          
        }
      },


      set: function (baseUrl, resource) {},


      list: function (baseUrl, resource) {
        return function (params) {
          return request({
            method: 'GET',
            url: baseUrl + resource,
            params: params
          });          
        }        
      },


      insert: function (baseUrl, resource) {
        return function (data, params) {
          return request({
            method: 'POST',
            url: baseUrl + resource,
            params: params,
            data: data
          });
        };
      },


      update: function (baseUrl, resource) {
        return function (data, params) {
          return request({
            method: 'PUT',
            url: baseUrl + resource,
            params: params,
            data: data
          });
        };        
      },


      delete: function (baseUrl, resource) {
        return function (data, params) {
          return request({
            method: 'DELETE',
            url: baseUrl + resource,
            params: params
          });
        };        
      },
      

      rate: function (baseUrl, resource) {},
      

      getRating: function (baseUrl, resource) {}


    };


    /**
     * Generate a method name by concatenating and camel-casing
     * an action and resource.
     */

    function methodName(action, resource) {
      resource[0] = resource[0].toUppercase()
      return action + resource;
    }


    /**
     * GAPI Service Constructor
     *
     * For each resource in the provided spec, we define methods
     * for each resource's actions.
     *
     * It would normally be poor form to assign to the prototype 
     * within the body of a constructor. However, AngularJS services 
     * are singletons, and we will only invoke this once per Google API.
     */

    function GAPI (api, version, spec) {
      var actions,
        , resources = Object.keys(spec)
        , self = this;

      self.baseUrl = baseUrl + api + '/' + version + '/';

      resources.forEach(function (resource) {
        var actions = spec[resource];
      
        actions.forEach(function (action) {
          var method = methodName(action, resource);
          this.prototype[method] = methods[action](self.baseUrl + resource);
        });
      });
    }

    return GAPI;
  });



  /**
   * Example of generating a service specific client.
   */

  .factory('Youtube', function (GAPI) {
    var Youtube = new GAPI('youtube', 'v3', {
      activities:       ['list', 'insert'],
      channels:         ['list', 'update'],
      guideCategories:  ['list'],
      playlistItems:    ['list', 'insert', 'update', 'delete'],
      playlists:        ['list', 'insert', 'update', 'delete'],
      search:           ['list'],
      subscriptions:    ['list', 'insert', 'delete'],
    //  thumbnails:       ['set'],
      videoCategories:  ['list'],
    //  videos:           ['list', 'insert', 'update', 'delete', 'rate', 'getRating']
    });

    // Some methods don't fit the pattern
    // Define them explicitly here
    Youtube.getRating = function () {}

    return Youtube;
  })


  /**
   * Example Controller
   */

  .controller('YoutubeCtrl', function ($scope, Youtube) {
    $scope.activities = Youtube.listActivities({ limit: 10 })
  })
