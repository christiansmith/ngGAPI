describe 'GAPI', ->

  { 
    GAPI,Plus,
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


  describe 'Plus', ->

    beforeEach inject ($injector) ->
      Plus = $injector.get('Plus')


    # SERVICE PROPERTIES

    it 'should refer to the Google+ API', ->
      expect(Plus.api).toBe 'plus'

    it 'should refer to version 1', ->
      expect(Plus.version).toBe 'v1'

    it 'should refer to the correct url', ->
      expect(Plus.url).toBe 'https://www.googleapis.com/plus/v1/'


    # PEOPLE

    it 'should get a person by id', ->
      url = "#{Plus.url}people/xyz"
      $httpBackend.expectGET(url, getHeaders).respond null
      Plus.getPeople('xyz')
      $httpBackend.flush()

    it 'should search people', ->
      url = "#{Plus.url}people?query=term"
      $httpBackend.expectGET(url, getHeaders).respond null
      Plus.searchPeople({ query:'term' })
      $httpBackend.flush()

    it 'should list people by activity', ->
      url = "#{Plus.url}activities/123/people/plusoners"
      $httpBackend.expectGET(url, getHeaders).respond null
      Plus.listPeopleByActivity '123', 'plusoners'
      $httpBackend.flush()

    it 'should list people added to a user\'s circles', ->
      url = "#{Plus.url}people/xyz/people/visible?maxResults=5"
      $httpBackend.expectGET(url, getHeaders).respond null
      Plus.listPeople 'xyz', 'visible', { maxResults: 5 }
      $httpBackend.flush()      


    # ACTIVITIES

    it 'should list activities by collection', ->
      url = "#{Plus.url}people/xyz/activities/public?maxResults=5"
      $httpBackend.expectGET(url, getHeaders).respond null
      Plus.listActivities 'xyz', 'public', { maxResults: 5 }
      $httpBackend.flush()

    it 'should get an activity', ->
      url = "#{Plus.url}activities/123"
      $httpBackend.expectGET(url, getHeaders).respond null
      Plus.getActivities '123'
      $httpBackend.flush()

    it 'should search activities', ->
      url = "#{Plus.url}activities?query=term"
      $httpBackend.expectGET(url, getHeaders).respond null
      Plus.searchActivities({ query:'term' })
      $httpBackend.flush()


    # COMMENTS

    it 'should list activity comments', ->
      url = "#{Plus.url}activities/123/comments"
      $httpBackend.expectGET(url, getHeaders).respond null
      Plus.listComments '123'
      $httpBackend.flush()

    it 'should get a comment', ->
      url = "#{Plus.url}comments/456"
      $httpBackend.expectGET(url, getHeaders).respond null
      Plus.getComments '456'
      $httpBackend.flush()


    # MOMENTS

    it 'should insert a moment', ->
      url = "#{Plus.url}people/xyz/moments/vault"
      data = { target: {}, type: '' } 
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Plus.insertMoments 'xyz', 'vault', data 
      $httpBackend.flush() 

    it 'should list moments written by the app', ->
      url = "#{Plus.url}people/xyz/moments/vault"
      $httpBackend.expectGET(url, getHeaders).respond null
      Plus.listMoments 'xyz', 'vault'
      $httpBackend.flush()       

    it 'should delete a moment written by the app', ->
      url = "#{Plus.url}moments/123"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Plus.removeMoments '123'
      $httpBackend.flush()
