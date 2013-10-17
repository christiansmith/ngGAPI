describe 'GAPI', ->

  { 
    GAPI,Blogger,
    $httpBackend,baseUrl,
    getHeaders,postHeaders,putHeaders,deleteHeaders,
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

    getHeaders = deleteHeaders = 
      "Accept":"application/json, text/plain, */*"
      "X-Requested-With":"XMLHttpRequest"
      "Authorization":"Bearer 1234abcd"

    postHeaders = putHeaders =
      "Accept":"application/json, text/plain, */*"
      "X-Requested-With":"XMLHttpRequest"
      "Content-Type":"application/json;charset=utf-8"
      "Authorization":"Bearer 1234abcd"


  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()


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
