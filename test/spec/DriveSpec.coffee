describe 'GAPI', ->

  { 
    GAPI,Drive,
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