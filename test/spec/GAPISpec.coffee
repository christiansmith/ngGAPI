describe 'GAPI', ->

  { 
    GAPI,Service,Youtube,Blogger,
    $httpBackend,baseUrl,
    getHeaders,postHeaders,putHeaders,deleteHeaders,
    authorization
  } = {}


  angular.module('gapi')
    .value 'GoogleApp', 
      apiKey: '1234'
      clientId: 'abcd'
      scopes: [
        'https://www.googleapis.com/auth/youtube'
        'https://www.googleapis.com/auth/userinfo.profile'
      ]  
    

  beforeEach module 'gapi'


  beforeEach inject ($injector) ->
    GAPI         = $injector.get 'GAPI'
    $httpBackend = $injector.get '$httpBackend'

    GAPI.app = {
      oauthToken: {
        access_token: '1234abcd'
      }
    }

    getHeaders = deleteHeaders = 
      "Accept":"application/json, text/plain, */*"
      "X-Requested-With":"XMLHttpRequest"
      "Authorization":"Bearer 1234abcd"

    postHeaders = putHeaders =
      "Accept":"application/json, text/plain, */*"
      "X-Requested-With":"XMLHttpRequest"
      "Content-Type":"application/json;charset=utf-8"
      "Authorization":"Bearer 1234abcd"

    Service = new GAPI 'service', 'v1', 
      resources: [
        'get'
        'set'
        'list'
        'insert'
        'update'
        'delete'
        { nested: [
            'get', 'set', 'insert', 'update', 'delete', {
              nested: ['list']
            }
          ] 
        }
      ] 
    

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()


  describe 'authorization', ->

    it 'should return promise'


  describe 'service constructor', ->

    it 'should set the api', ->
      expect(Service.api).toBe 'service'

    it 'should set the version', ->
      expect(Service.version).toBe 'v1'

    it 'should set the baseUrl', ->
      expect(Service.url).toBe 'https://www.googleapis.com/service/v1/'

    it 'should define a get method on a specified resource', ->
      expect(typeof Service.getResources).toEqual('function')
      expect(Service.getResources.toString()).toBe GAPI.get('resource').toString()

    it 'should define a set method on a specified resource', ->
      expect(typeof Service.setResources).toEqual('function')
      expect(Service.setResources.toString()).toBe GAPI.set('resource').toString()

    it 'should define a list method on a specified resource', ->
      expect(typeof Service.listResources).toEqual('function')
      expect(Service.listResources.toString()).toBe GAPI.list('resource').toString()

    it 'should define an insert method on a specified resource', ->
      expect(typeof Service.insertResources).toEqual('function')
      expect(Service.insertResources.toString()).toBe GAPI.insert('resource').toString()

    it 'should define an update method on a specified resource', ->
      expect(typeof Service.updateResources).toEqual('function')
      expect(Service.updateResources.toString()).toBe GAPI.update('resource').toString()

    it 'should define a delete method on a specified resource', ->
      expect(typeof Service.deleteResources).toEqual('function')
      expect(Service.deleteResources.toString()).toBe GAPI.delete('resource').toString()

    it 'should define a get method on a nested resource', ->
      expect(typeof Service.getNested).toEqual 'function'
      expect(Service.getNested.toString()).toBe GAPI.get('nested', ['resource']).toString()

    it 'should define a set method on a nested resource', ->
      expect(typeof Service.setNested).toEqual 'function'
      expect(Service.setNested.toString()).toBe GAPI.set('nested', ['resource']).toString()

    it 'should define a list method on a nested resource', ->
      expect(typeof Service.listNested).toEqual('function')
      expect(Service.listNested.toString()).toBe GAPI.list('nested', ['resource']).toString()
    
    it 'should define an insert method on a nested resource', ->
      expect(typeof Service.insertNested).toEqual 'function'
      expect(Service.insertNested.toString()).toBe GAPI.insert('nested', ['resource']).toString()

    it 'should define an update method on a nested resource', ->
      expect(typeof Service.updateNested).toEqual 'function'
      expect(Service.updateNested.toString()).toBe GAPI.update('nested', ['resource']).toString()

    it 'should define a delete method on a nested resource', ->
      expect(typeof Service.deleteNested).toEqual 'function'
      expect(Service.deleteNested.toString()).toBe GAPI.delete('nested', ['resource']).toString()

    it 'should define a search method on the constructed service', ->
      expect(Service.search).toBe GAPI.search


  describe 'constructed service', ->

    it 'should get a resource', ->
      url = "#{Service.url}resources/123"
      $httpBackend.expectGET(url, getHeaders).respond null
      Service.getResources('123')
      $httpBackend.flush()

    it 'should get a nested resource', ->
      url = "#{Service.url}resources/123/nested/456"
      $httpBackend.expectGET(url, getHeaders).respond null
      Service.getNested('123', '456')
      $httpBackend.flush()

    it 'should set a resource'


    it 'should list resources', ->
      url = "#{Service.url}resources"
      $httpBackend.expectGET(url, getHeaders).respond null
      Service.listResources()
      $httpBackend.flush()

    it 'should list nested resources', ->
      url = "#{Service.url}resources/123/nested/456/nested"
      $httpBackend.expectGET(url, getHeaders).respond null
      Service.listNested('123', '456')
      $httpBackend.flush()

    it 'should insert resources', ->
      url = "#{Service.url}resources"
      data = {}
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Service.insertResources(data)
      $httpBackend.flush()

    it 'should insert nested resources', ->
      url = "#{Service.url}resources/123/nested"
      data = {}
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Service.insertNested('123', data)
      $httpBackend.flush()

    it 'should update a resource', ->
      url = "#{Service.url}resources"
      data = {}
      $httpBackend.expectPUT(url, data, putHeaders).respond null
      Service.updateResources(data)
      $httpBackend.flush()

    it 'should update a nested resource', ->
      url = "#{Service.url}resources/123/nested/456"
      data = {}
      $httpBackend.expectPUT(url, data, putHeaders).respond null
      Service.updateNested('123', '456', data)
      $httpBackend.flush()

    it 'should delete a resource', ->
      url = "#{Service.url}resources"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Service.deleteResources()
      $httpBackend.flush()

    it 'should delete a nested resource', ->
      url = "#{Service.url}resources/123/nested"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Service.deleteNested('123')
      $httpBackend.flush()

    it 'should search', ->
      url = "#{Service.url}search?maxResults=50&part=snippet&q=Raphael%20Rabello"
      $httpBackend.expectGET(url, getHeaders).respond null
      Service.search('Raphael Rabello')
      $httpBackend.flush()


  describe 'Youtube', ->

    beforeEach inject ($injector) ->
      Youtube = $injector.get('Youtube')

    it 'should refer to the youtube api', ->
      expect(Youtube.api).toBe 'youtube'

    it 'should refer to version 3', ->
      expect(Youtube.version).toBe 'v3'

    it 'should refer to the correct url', ->
      expect(Youtube.url).toBe 'https://www.googleapis.com/youtube/v3/'

    it 'should list activities', ->
      url = "#{Youtube.url}activities?home=true&part=snippet"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listActivities({part:'snippet', home:true})
      $httpBackend.flush()

    it 'should insert activities'

    it 'should list channels', ->
      url = "#{Youtube.url}channels?mine=true&part=snippet"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listChannels({part:'snippet', mine:true})
      $httpBackend.flush()

    it 'should update channels'
    
    it 'should list guide categories'
    
    it 'should bind live broadcasts'
    it 'should control live broadcasts'
    it 'should transition live broadcasts'
    it 'should list live broadcasts'
    it 'should insert live broadcasts'
    it 'should update live broadcasts'
    it 'should delete live broadcasts'
    
    it 'should list live streams'
    it 'should insert live streams'
    it 'should update live streams'
    it 'should delete live streams'
    
    it 'should list playlist items', ->
      url = "#{Youtube.url}playlistItems?maxResults=50&part=snippet&playlistId=1234"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listPlaylistItems 
          part: 'snippet'
          maxResults: 50
          playlistId: '1234'
      $httpBackend.flush()      

    it 'should insert playlist items'
    it 'should update playlist items'
    it 'should delete playlist items'
    
    it 'should list playlists', ->
      url = "#{Youtube.url}playlists?mine=true&part=snippet"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listPlaylists({part:'snippet', mine:true})
      $httpBackend.flush()

    it 'should insert playlists'
    it 'should update playlists'
    it 'should delete playlists'
    
    it 'should list subscriptions', ->
      url = "#{Youtube.url}subscriptions?mine=true&part=snippet"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listSubscriptions({part:'snippet', mine:true})
      $httpBackend.flush()

    it 'should insert subscriptions'
    it 'should delete subscriptions'
    
    it 'should set thumbnail'
    
    it 'should list video categories'
    
    it 'should list videos', ->
      url = "#{Youtube.url}videos?myRating=like&part=snippet"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listVideos({part:'snippet', myRating:'like'})
      $httpBackend.flush()

    it 'should insert videos'
    it 'should update videos'
    it 'should delete videos'
    
    it 'should set watermark'
    it 'should unset watermark'
    
    it 'should rate'
    it 'should get rating'
    
    it 'should search'


  describe 'Blogger', ->

    beforeEach inject ($injector) ->
      Blogger = $injector.get('Blogger')

    it 'should refer to the blogger api', ->
      expect(Blogger.api).toBe 'blogger'

    it 'should refer to version 3', ->
      expect(Blogger.version).toBe 'v3'

    it 'should refer to the correct url', ->
      expect(Blogger.url).toBe 'https://www.googleapis.com/blogger/v3/'

    it 'should get blog by id'
    it 'should get blog by url'
    it 'should list blogs by user'
    it 'should list comments'
    it 'should get a comment'
    it 'should list pages'
    it 'should get a page'
    it 'should get a post'
    it 'should list posts'
    it 'should search posts'
    it 'should insert a post'
    it 'should delete a post'
    it 'should get posts by path'
    it 'should patch a post'
    it 'should update a post'
    it 'should get a user'


  describe 'Drive', ->

    it 'should get a file'
    it 'should insert a file'
    it 'should patch a file'
    it 'should update a file'
    it 'should copy a file'
    it 'should delete a file'
    it 'should list files'
    it 'should touch a file'
    it 'should trash a file'
    it 'should untrash a file'
    it 'should watch a file'

    it 'should get current user and settings'

    it 'should get a change'
    it 'should list changes'
    it 'should watch changes'

    it 'should delete a child from a folder'
    it 'should get a child from a folder'
    it 'should insert a file into a folder'
    it 'should list files in a folder'

    it 'should delete a parent from a file'
    it 'should get a parent reference'
    it 'should insert a parent for a file'
    it 'should list a file\'s parents'

    it 'should delete a permission from a file'
    it 'should get a permission by id'
    it 'should insert a permission for a file'
    it 'should list a file\'s permissions'
    it 'should patch a permission'
    it 'should update a permission'
    it 'should get the permission id for an email address'

    it 'should remove a revision'
    it 'should get a revision'
    it 'should list a file\'s revisions'
    it 'should patch a revision'
    it 'should update a revision'

    it 'should list a user\'s installed apps'
    it 'should get an app'

    it 'should delete a comment'
    it 'should get a comment by id'
    it 'should insert a comment on a file'
    it 'should list a file\'s comments'
    it 'should patch a comment'
    it 'should update a comment'

    it 'should delete a reply'
    it 'should get a reply'
    it 'should insert a reply'
    it 'should list replies to a comment'
    it 'should patch a reply'
    it 'should update a reply'    

    it 'should delete a property'
    it 'should get a property'
    it 'should insert a property'
    it 'should list properties of a file'
    it 'should patch a property'
    it 'should update a property'   

    it 'should stop a channel'
    it 'should get realtime'
    it 'should update realtime'


  describe 'Plus', ->

    it 'should get a person by id'
    it 'should search people'
    it 'should list people by activity'
    it 'should list people added to a user\'s circles'

    it 'should list activities by collection'
    it 'should get an activity'
    it 'should search activities'

    it 'should list activity comments'
    it 'should get a comment'

    it 'should insert a moment'
    it 'should list moments written by the app'
    it 'should delete a moment written by the app'


  describe 'Calendar', ->

    it 'should delete an acl'
    it 'should get an acl'
    it 'should insert an acl'
    it 'should list an acl'
    it 'should update an acl'
    it 'should patch an acl'

    it 'should delete a calendar list'
    it 'should get a calendar list'
    it 'should insert a calendar list'
    it 'should list a user\'s calendar lists'
    it 'should update a calendar list'
    it 'should patch a calendar list'

    it 'should clear a calendar'
    it 'should delete a secondary calendar'
    it 'should get calendar metadata'
    it 'should insert a secondary calendar'
    it 'should update metadata for a calendar'
    it 'should patch a metadata for a calendar'    

    it 'should get colors'

    it 'should delete an event'
    it 'should get an event'
    it 'should import an event'
    it 'should insert an event'
    it 'should list instances of a recurring event'
    it 'should list events on a specified calendar'
    it 'should move an event to another calendar'
    it 'should create an event based on a simple text string'
    it 'should update an event'
    it 'should patch an event'
    it 'should watch for changes to events'
    
    it 'should get free/busy for a set of calendars'
    
    it 'should get a user setting'
    it 'should list user settings for the authenticated user'

    it 'should stop a channel'
