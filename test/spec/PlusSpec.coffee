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
