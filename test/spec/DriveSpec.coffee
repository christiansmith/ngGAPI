describe 'GAPI', ->

  { 
    GAPI,Drive,
    $httpBackend,baseUrl,
    getHeaders,postHeaders,putHeaders,deleteHeaders,patchHeaders,noContentHeaders
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


  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()


  describe 'Drive', ->

    beforeEach inject ($injector) ->
      Drive = $injector.get('Drive')


    # SERVICE PROPERTIES

    it 'should refer to the Drive api', ->
      expect(Drive.api).toBe 'drive'

    it 'should refer to version 2', ->
      expect(Drive.version).toBe 'v2'

    it 'should refer to the correct url', ->
      expect(Drive.url).toBe 'https://www.googleapis.com/drive/v2/'


    # FILES

    it 'should get a file', ->
      url = "#{Drive.url}files/xyz"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.getFiles 'xyz' 
      $httpBackend.flush()

    it 'should upload a file'

    it 'should insert a file', ->
      url = "#{Drive.url}files?uploadType=multipart"
      data = { description: 'about the file' }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Drive.insertFiles data, { uploadType: 'multipart' }
      $httpBackend.flush()

    it 'should patch a file', ->
      url = "#{Drive.url}files/xyz"
      data = { description: 'updated info about the file' }
      $httpBackend.expectPATCH(url, data, patchHeaders).respond null
      Drive.patchFiles 'xyz', data
      $httpBackend.flush()

    it 'should upload a file update'

    it 'should update a file', ->
      url = "#{Drive.url}files/xyz?uploadType=multipart"
      data = { description: 'about the Drive' }
      $httpBackend.expectPUT(url, data, postHeaders).respond null
      Drive.updateFiles 'xyz', data, { uploadType: 'multipart' }
      $httpBackend.flush()

    it 'should copy a file', ->
      url = "#{Drive.url}files/xyz/copy?convert=true"
      data = { title: 'copy of file xyz' }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Drive.copyFile 'xyz', data, { convert: true }
      $httpBackend.flush()

    it 'should delete a file', ->
      url = "#{Drive.url}files/xyz"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Drive.deleteFiles 'xyz'
      $httpBackend.flush()

    it 'should list files', ->
      url = "#{Drive.url}files?q=terms"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.listFiles { q: 'terms' }
      $httpBackend.flush()   

    it 'should touch a file', ->
      url = "#{Drive.url}files/xyz/touch"
      $httpBackend.expectPOST(url, undefined, noContentHeaders).respond null
      Drive.touchFile 'xyz'
      $httpBackend.flush()

    it 'should trash a file', ->
      url = "#{Drive.url}files/xyz/trash"
      $httpBackend.expectPOST(url, undefined, noContentHeaders).respond null
      Drive.trashFile 'xyz'
      $httpBackend.flush()

    it 'should untrash a file', ->
      url = "#{Drive.url}files/xyz/untrash"
      $httpBackend.expectPOST(url, undefined, noContentHeaders).respond null
      Drive.untrashFile 'xyz'
      $httpBackend.flush()

    it 'should watch a file', ->
      url = "#{Drive.url}files/xyz/watch"
      data =
        id:      'string',
        token:   'string',
        type:    'string',
        address: 'string',
        params:  { ttl: 'string' }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Drive.watchFile 'xyz', data
      $httpBackend.flush()


    # ABOUT

    it 'should get current user and settings'


    # CHANGES

    it 'should get a change'
    it 'should list changes'
    it 'should watch changes'


    # CHILDREN

    it 'should delete a child from a folder'
    it 'should get a child from a folder'
    it 'should insert a file into a folder'
    it 'should list files in a folder'


    # PARENTS

    it 'should delete a parent from a file'
    it 'should get a parent reference'
    it 'should insert a parent for a file'
    it 'should list a file\'s parents'


    # PERMISSIONS

    it 'should delete a permission from a file'
    it 'should get a permission by id'
    it 'should insert a permission for a file'
    it 'should list a file\'s permissions'
    it 'should patch a permission'
    it 'should update a permission'
    it 'should get the permission id for an email address'


    # REVISIONS

    it 'should remove a revision'
    it 'should get a revision'
    it 'should list a file\'s revisions'
    it 'should patch a revision'
    it 'should update a revision'


    # APPS

    it 'should list a user\'s installed apps'
    it 'should get an app'


    # COMMENTS

    it 'should delete a comment'
    it 'should get a comment by id'
    it 'should insert a comment on a file'
    it 'should list a file\'s comments'
    it 'should patch a comment'
    it 'should update a comment'


    # REPLIES

    it 'should delete a reply'
    it 'should get a reply'
    it 'should insert a reply'
    it 'should list replies to a comment'
    it 'should patch a reply'
    it 'should update a reply'    


    # PROPERTIES

    it 'should delete a property'
    it 'should get a property'
    it 'should insert a property'
    it 'should list properties of a file'
    it 'should patch a property'
    it 'should update a property'   


    # CHANNELS

    it 'should stop a channel'


    # REALTIME

    it 'should get realtime'
    it 'should update realtime'

    