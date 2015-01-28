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

    getHeaders = deleteHeaders = noContentHeaders =
      "Authorization":"Bearer 1234abcd"
      "Accept":"application/json, text/plain, */*"

    patchHeaders =
      "Authorization":"Bearer 1234abcd"
      "Accept":"application/json, text/plain, */*"
      "Content-Type":"application/json;charset=utf-8"

    postHeaders = putHeaders =
      "Authorization":"Bearer 1234abcd"
      "Accept":"application/json, text/plain, */*"
      "Content-Type":"application/json;charset=utf-8"


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

    it 'should get current user and settings', ->
      url = "#{Drive.url}about?includeSubscribed=true"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.about includeSubscribed: true
      $httpBackend.flush()


    # CHANGES

    it 'should get a change', ->
      url = "#{Drive.url}changes/xyz"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.getChanges 'xyz' 
      $httpBackend.flush()

    it 'should list changes', ->
      url = "#{Drive.url}changes?maxResults=5"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.listChanges { maxResults: 5 }
      $httpBackend.flush()  

    it 'should watch changes', ->
      url = "#{Drive.url}changes/watch"
      data =
        id:      'string',
        token:   'string',
        type:    'string',
        address: 'string',
        params:  { ttl: 'string' }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Drive.watchChanges data
      $httpBackend.flush()


    # CHILDREN

    it 'should delete a child from a folder', ->
      url = "#{Drive.url}files/123/children/456"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Drive.deleteChildren '123', '456'
      $httpBackend.flush()

    it 'should get a child from a folder', ->
      url = "#{Drive.url}files/123/children/456"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.getChildren '123', '456'
      $httpBackend.flush()

    it 'should insert a file into a folder', ->
      url = "#{Drive.url}files/123/children"
      data = { id: '456' }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Drive.insertChildren '123', { id: '456' }
      $httpBackend.flush()

    it 'should list files in a folder', ->
      url = "#{Drive.url}files/123/children?maxResults=5"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.listChildren '123', { maxResults: 5 }
      $httpBackend.flush()  


    # PARENTS

    it 'should delete a parent from a file', ->
      url = "#{Drive.url}files/123/parents/456"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Drive.deleteParents '123', '456'
      $httpBackend.flush()

    it 'should get a parent reference', ->
      url = "#{Drive.url}files/123/parents/456"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.getParents '123', '456'
      $httpBackend.flush()

    it 'should insert a parent for a file', ->
      url = "#{Drive.url}files/123/parents"
      data = { id: '456' }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Drive.insertParents '123', { id: '456' }
      $httpBackend.flush()

    it 'should list a file\'s parents', ->
      url = "#{Drive.url}files/123/parents"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.listParents '123'
      $httpBackend.flush()      


    # PERMISSIONS

    it 'should delete a permission from a file', ->
      url = "#{Drive.url}files/123/permissions/456"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Drive.deletePermissions '123', '456'
      $httpBackend.flush()

    it 'should get a permission by id', ->
      url = "#{Drive.url}files/123/permissions/456"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.getPermissions '123', '456'
      $httpBackend.flush()

    it 'should insert a permission for a file', ->
      url = "#{Drive.url}files/123/permissions?sendNotificationEmails=true"
      data =
        role: 'string'
        type: 'string'
        value: 'string'
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Drive.insertPermissions '123', data, { sendNotificationEmails: true }
      $httpBackend.flush()

    it 'should list a file\'s permissions', ->
      url = "#{Drive.url}files/123/permissions"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.listPermissions '123'
      $httpBackend.flush()

    it 'should patch a permission', ->
      url = "#{Drive.url}files/123/permissions/456?transferOwnership=true"
      data =
        role: 'string'
        type: 'string'
        value: 'string'
      $httpBackend.expectPATCH(url, data, patchHeaders).respond null
      Drive.patchPermissions '123', '456', data, { transferOwnership: true }
      $httpBackend.flush()

    it 'should update a permission', ->
      url = "#{Drive.url}files/123/permissions/456?transferOwnership=true"
      data =
        role: 'string'
      $httpBackend.expectPUT(url, data, putHeaders).respond null
      Drive.updatePermissions '123', '456', data, { transferOwnership: true }
      $httpBackend.flush()

    it 'should get the permission id for an email address', ->
      url = "#{Drive.url}permissionIds/foo@bar.com"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.getPermissionIdForEmail 'foo@bar.com' 
      $httpBackend.flush()


    # REVISIONS

    it 'should remove a revision', ->
      url = "#{Drive.url}files/123/revisions/456"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Drive.deleteRevisions '123', '456'
      $httpBackend.flush()

    it 'should get a revision', ->
      url = "#{Drive.url}files/123/revisions/456"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.getRevisions '123', '456'
      $httpBackend.flush()

    it 'should list a file\'s revisions', ->
      url = "#{Drive.url}files/123/revisions"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.listRevisions '123'
      $httpBackend.flush()

    it 'should patch a revision', ->
      url = "#{Drive.url}files/123/revisions/456"
      data =
        kind: 'drive#revision'
        etag: 'etag'
        id: 'string'
        selfLink: 'string'
        mimeType: 'string'
        # etc
      $httpBackend.expectPATCH(url, data, patchHeaders).respond null
      Drive.patchRevisions '123', '456', data
      $httpBackend.flush()

    it 'should update a revision', ->
      url = "#{Drive.url}files/123/revisions/456"
      data =
        pinned: true
        publishAuto: true
        published: true
        publishedOutsideDomain: true
      $httpBackend.expectPUT(url, data, putHeaders).respond null
      Drive.updateRevisions '123', '456', data
      $httpBackend.flush()


    # APPS

    it 'should list a user\'s installed apps', ->
      url = "#{Drive.url}apps"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.listApps()
      $httpBackend.flush()  

    it 'should get an app', ->
      url = "#{Drive.url}apps/xyz"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.getApps 'xyz' 
      $httpBackend.flush()


    # COMMENTS

    it 'should delete a comment', ->
      url = "#{Drive.url}files/123/comments/456"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Drive.deleteComments '123', '456'
      $httpBackend.flush()

    it 'should get a comment by id', ->
      url = "#{Drive.url}files/123/comments/456"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.getComments '123', '456'
      $httpBackend.flush()

    it 'should insert a comment on a file', ->
      url = "#{Drive.url}files/123/comments"
      data =
        content: 'string'
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Drive.insertComments '123', data
      $httpBackend.flush()

    it 'should list a file\'s comments', ->
      url = "#{Drive.url}files/123/comments?maxResults=5"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.listComments '123', { maxResults: 5 }
      $httpBackend.flush()

    it 'should patch a comment', ->
      url = "#{Drive.url}files/123/comments/456"
      data =
        content: 'string'
        # etc
      $httpBackend.expectPATCH(url, data, patchHeaders).respond null
      Drive.patchComments '123', '456', data
      $httpBackend.flush()

    it 'should update a comment', ->
      url = "#{Drive.url}files/123/comments/456"
      data =
        content: 'string'
        # etc
      $httpBackend.expectPUT(url, data, putHeaders).respond null
      Drive.updateComments '123', '456', data
      $httpBackend.flush()


    # REPLIES

    it 'should delete a reply', ->
      url = "#{Drive.url}files/123/comments/456/replies/789"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Drive.deleteReplies '123', '456', '789'
      $httpBackend.flush()    

    it 'should get a reply', ->
      url = "#{Drive.url}files/123/comments/456/replies/789?includeDeleted=true"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.getReplies '123', '456', '789', { includeDeleted: true }
      $httpBackend.flush()

    it 'should insert a reply', ->
      url = "#{Drive.url}files/123/comments/456/replies"
      data =
        content: 'string'
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Drive.insertReplies '123', '456', data
      $httpBackend.flush()

    it 'should list replies to a comment', ->
      url = "#{Drive.url}files/123/comments/456/replies?maxResults=5"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.listReplies '123', '456', { maxResults: 5 }
      $httpBackend.flush()

    it 'should patch a reply', ->
      url = "#{Drive.url}files/123/comments/456/replies/789"
      data =
        content: 'string'
        # etc
      $httpBackend.expectPATCH(url, data, patchHeaders).respond null
      Drive.patchReplies '123', '456', '789', data
      $httpBackend.flush()

    it 'should update a reply', ->
      url = "#{Drive.url}files/123/comments/456/replies/789"
      data =
        content: 'string'
        # etc
      $httpBackend.expectPUT(url, data, putHeaders).respond null
      Drive.updateReplies '123', '456', '789', data
      $httpBackend.flush()   


    # PROPERTIES

    it 'should delete a property', ->
      url = "#{Drive.url}files/123/properties/456"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Drive.deleteProperties '123', '456'
      $httpBackend.flush()

    it 'should get a property', ->
      url = "#{Drive.url}files/123/properties/456?visibility=string"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.getProperties '123', '456', { visibility: 'string' }
      $httpBackend.flush()

    it 'should insert a property', ->
      url = "#{Drive.url}files/123/properties"
      data =
        key: 'string'
        value: 'string'
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Drive.insertProperties '123', data
      $httpBackend.flush()

    it 'should list properties of a file', ->
      url = "#{Drive.url}files/123/properties"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.listProperties '123'
      $httpBackend.flush()

    it 'should patch a property', ->
      url = "#{Drive.url}files/123/properties/456"
      data =
        key: 'string'
        value: 'string'
      $httpBackend.expectPATCH(url, data, patchHeaders).respond null
      Drive.patchProperties '123', '456', data
      $httpBackend.flush()

    it 'should update a property', ->
      url = "#{Drive.url}files/123/properties/456"
      data =
        key: 'string'
        value: 'string'
      $httpBackend.expectPUT(url, data, putHeaders).respond null
      Drive.updateProperties '123', '456', data
      $httpBackend.flush()


    # CHANNELS

    it 'should stop a channel', ->
      url = "#{Drive.url}channels/stop"
      data =
        id: 'string'
        resourceId: 'string'
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Drive.stopChannels data
      $httpBackend.flush()    


    # REALTIME

    it 'should get realtime', ->
      url = "#{Drive.url}files/xyz/realtime"
      $httpBackend.expectGET(url, getHeaders).respond null
      Drive.getRealtime 'xyz' 
      $httpBackend.flush()

    it 'should update realtime', ->
      url = "#{Drive.url}files/123/realtime?uploadType=media"
      $httpBackend.expectPUT(url, undefined, noContentHeaders).respond null
      Drive.updateRealtime '123', { uploadType: 'media' }
      $httpBackend.flush()

    
