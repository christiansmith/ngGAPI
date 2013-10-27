describe 'GAPI', ->

  { 
    GAPI,Service,
    $httpBackend,baseUrl,
    getHeaders,postHeaders,putHeaders,deleteHeaders,patchHeaders,noContentHeaders,
    authorization
  } = {}


  angular.module('gapi')
    .value 'GoogleApp', 
      apiKey: '1234'
      clientId: 'abcd' 
    

  beforeEach module 'gapi'


  beforeEach inject ($injector) ->
    GAPI         = $injector.get 'GAPI'
    $httpBackend = $injector.get '$httpBackend'

    GAPI.app = {
      oauthToken: {
        access_token: '1234abcd'
      }
    }

    getHeaders = deleteHeaders = patchHeaders = noContentHeaders =
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
        'unset'
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


  describe 'constructed service HTTP methods', ->

    describe 'get', ->

      it 'should build a path from arguments', ->
        url = "#{Service.url}arbitrary/path/to/resource"
        $httpBackend.expectGET(url, getHeaders).respond null
        Service.get 'arbitrary', 'path', 'to', 'resource'
        $httpBackend.flush()

      it 'should encode parameters', ->
        url = "#{Service.url}arbitrary/path/to/resource?foo=bar"
        $httpBackend.expectGET(url, getHeaders).respond null
        Service.get 'arbitrary', 'path', 'to', 'resource', { foo: 'bar' }
        $httpBackend.flush()    

      it 'should handle undefined params', ->
        url = "#{Service.url}arbitrary/path/to/resource" 
        $httpBackend.expectGET(url, getHeaders).respond null
        Service.get 'arbitrary', 'path', 'to', 'resource', undefined
        $httpBackend.flush()        

    describe 'post', ->

      it 'should build a path from arguments', ->
        url = "#{Service.url}arbitrary/path/to/resource"
        $httpBackend.expectPOST(url, undefined, noContentHeaders).respond null
        Service.post 'arbitrary', 'path', 'to', 'resource'
        $httpBackend.flush()   

      it 'should encode parameters with undefined data', ->
        url = "#{Service.url}arbitrary/path/to/resource?foo=bar"
        $httpBackend.expectPOST(url, undefined, noContentHeaders).respond null
        Service.post 'arbitrary', 'path', 'to', 'resource', undefined, {foo:'bar'}
        $httpBackend.flush()

      it 'should send data without parameters', ->
        url = "#{Service.url}arbitrary/path/to/resource"
        data = { foo: 'bar' }
        $httpBackend.expectPOST(url, data, postHeaders).respond null
        Service.post 'arbitrary', 'path', 'to', 'resource', data
        $httpBackend.flush()



  describe 'constructed service resource methods', ->

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

    it 'should set a resource', ->
      url = "#{Service.url}resources/set"
      headers =
        "Accept":"application/json, text/plain, */*"
        "X-Requested-With":"XMLHttpRequest"
        "Authorization":"Bearer 1234abcd"
      $httpBackend.expectPOST(url, undefined, headers).respond null
      Service.setResources()
      $httpBackend.flush()    

    it 'should unset a resource', ->
      url = "#{Service.url}resources/unset"
      headers =
        "Accept":"application/json, text/plain, */*"
        "X-Requested-With":"XMLHttpRequest"
        "Authorization":"Bearer 1234abcd"
      $httpBackend.expectPOST(url, undefined, headers).respond null
      Service.unsetResources()
      $httpBackend.flush()  

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


