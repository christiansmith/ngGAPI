describe 'GAPI', ->

  {GAPI,Service,Youtube,Blogger,$httpBackend,baseUrl,authorization} = {}


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
      $httpBackend.expectGET(url).respond null
      Service.getResources('123')
      $httpBackend.flush()

    it 'should get a nested resource', ->
      url = "#{Service.url}resources/123/nested/456"
      $httpBackend.expectGET(url).respond null
      Service.getNested('123', '456')
      $httpBackend.flush()

    it 'should set a resource'


    it 'should list resources', ->
      url = "#{Service.url}resources"
      $httpBackend.expectGET(url).respond null
      Service.listResources()
      $httpBackend.flush()

    it 'should list nested resources', ->
      url = "#{Service.url}resources/123/nested/456/nested"
      $httpBackend.expectGET(url).respond null
      Service.listNested('123', '456')
      $httpBackend.flush()

    it 'should insert resources', ->
      url = "#{Service.url}resources"
      data = {}
      $httpBackend.expectPOST(url, data).respond null
      Service.insertResources(data)
      $httpBackend.flush()

    it 'should insert nested resources', ->
      url = "#{Service.url}resources/123/nested"
      data = {}
      $httpBackend.expectPOST(url, data).respond null
      Service.insertNested('123', data)
      $httpBackend.flush()

    it 'should update a resource', ->
      url = "#{Service.url}resources"
      data = {}
      $httpBackend.expectPUT(url, data).respond null
      Service.updateResources(data)
      $httpBackend.flush()

    it 'should update a nested resource', ->
      url = "#{Service.url}resources/123/nested/456"
      data = {}
      $httpBackend.expectPUT(url, data).respond null
      Service.updateNested('123', '456', data)
      $httpBackend.flush()

    it 'should delete a resource', ->
      url = "#{Service.url}resources"
      $httpBackend.expectDELETE(url).respond null
      Service.deleteResources()
      $httpBackend.flush()

    it 'should delete a nested resource', ->
      url = "#{Service.url}resources/123/nested"
      $httpBackend.expectDELETE(url).respond null
      Service.deleteNested('123')
      $httpBackend.flush()

    it 'should search', ->
      url = "#{Service.url}search?maxResults=50&part=snippet&q=Raphael%20Rabello"
      $httpBackend.expectGET(url).respond null
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


  describe 'Blogger', ->

    beforeEach inject ($injector) ->
      Blogger = $injector.get('Blogger')

    it 'should refer to the blogger api', ->
      expect(Blogger.api).toBe 'blogger'

    it 'should refer to version 3', ->
      expect(Blogger.version).toBe 'v3'

    it 'should refer to the correct url', ->
      expect(Blogger.url).toBe 'https://www.googleapis.com/blogger/v3/'


  describe 'Drive', ->
  describe 'Plus', ->
