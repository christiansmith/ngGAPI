describe 'GAPI', ->

  { 
    GAPI,Calendar,
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
    # Calendar    = $injector.get 'Calendar'
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
