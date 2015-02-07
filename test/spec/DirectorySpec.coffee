describe 'GAPI', ->

  { 
    GAPI,Directory,
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
    $log         = $injector.get '$log'

    GAPI.app = {
      oauthToken: {
        access_token: '1234abcd'
      }
    }

    getHeaders = deleteHeaders = patchHeaders = noContentHeaders =
      "Authorization":"Bearer 1234abcd"
      "Accept":"application/json, text/plain, */*"

    postHeaders = putHeaders =
      "Authorization":"Bearer 1234abcd"
      "Accept":"application/json, text/plain, */*"
      "Content-Type":"application/json;charset=utf-8"


  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()


  describe 'Directory', ->

    beforeEach inject ($injector) ->
      Directory = $injector.get('Directory')


    # SERVICE PROPERTIES

    it 'should refer to the Directory api', ->
      expect(Directory.api).toBe 'admin/directory'

    it 'should refer to version 1', ->
      expect(Directory.version).toBe 'v1'

    it 'should refer to the correct url', ->
      expect(Directory.url).toBe 'https://www.googleapis.com/admin/directory/v1/'


    # Users

    it 'should create a user', ->
      url = "#{Directory.url}users"
      data = { "primaryEmail": "liz@example.com", "name": { "givenName": "Elizabeth", "familyName": "Smith" }, "suspended": false, "password": "new user password", "hashFunction": "SHA-1", "changePasswordAtNextLogin": false, "ipWhitelisted": false, "ims": [ { "type": "work", "protocol": "gtalk", "im": "liz_im@talk.example.com", "primary": true } ], "emails": [ { "address": "liz@example.com", "type": "home", "customType": "", "primary": true } ], "addresses": [ { "type": "work", "customType": "", "streetAddress": "1600 Amphitheatre Parkway", "locality": "Mountain View", "region": "CA", "postalCode": "94043" } ], "externalIds": [ { "value": "12345", "type": "custom", "customType": "employee" } ], "relations": [ { "value": "Mom", "type": "mother", "customType": "" }, { "value": "manager", "type": "referred_by", "customType": "" } ], "organizations": [ { "name": "Google Inc.", "title": "SWE", "primary": true, "type": "work", "description": "Software engineer" } ], "phones": [ { "value": "+1 nnn nnn nnnn", "type": "work" } ], "orgUnitPath": "/corp/engineering", "includeInGlobalAddressList": true }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Directory.insertUsers data
      $httpBackend.flush()

    it 'should update a user', ->
      url = "#{Directory.url}users/123"
      data = { "primaryEmail": "liz@example.com", "name": { "givenName": "Elizabeth", "familyName": "Smith" }, "suspended": false, "password": "new user password", "hashFunction": "SHA-1", "changePasswordAtNextLogin": false, "ipWhitelisted": false, "ims": [ { "type": "work", "protocol": "gtalk", "im": "liz_im@talk.example.com", "primary": true } ], "emails": [ { "address": "liz@example.com", "type": "home", "customType": "", "primary": true } ], "addresses": [ { "type": "work", "customType": "", "streetAddress": "1600 Amphitheatre Parkway", "locality": "Mountain View", "region": "CA", "postalCode": "94043" } ], "externalIds": [ { "value": "12345", "type": "custom", "customType": "employee" } ], "relations": [ { "value": "Mom", "type": "mother", "customType": "" }, { "value": "manager", "type": "referred_by", "customType": "" } ], "organizations": [ { "name": "Google Inc.", "title": "SWE", "primary": true, "type": "work", "description": "Software engineer" } ], "phones": [ { "value": "+1 nnn nnn nnnn", "type": "work" } ], "orgUnitPath": "/corp/engineering", "includeInGlobalAddressList": true }
      $httpBackend.expectPUT(url, data, putHeaders).respond null
      Directory.updateUsers '123', data
      $httpBackend.flush()

    it 'should make a user an administrator', ->
      url = "#{Directory.url}users/123/makeAdmin"
      data = { "status": true }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Directory.makeAdmin '123'
      $httpBackend.flush()

    it 'should make an administrator a user', ->
      url = "#{Directory.url}users/123/makeAdmin"
      data = { "status": false }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Directory.unMakeAdmin '123'
      $httpBackend.flush()

    it 'should get a user', ->
      url = "#{Directory.url}users/123"
      $httpBackend.expectGET(url, getHeaders).respond null
      Directory.getUsers '123'
      $httpBackend.flush()

    it 'should get a user', ->
      url = "#{Directory.url}users/123"
      $httpBackend.expectGET(url, getHeaders).respond null
      Directory.getUsers '123'
      $httpBackend.flush()

    it 'should list all users in a domain', ->
      url = "#{Directory.url}users?domain=example.com"
      $httpBackend.expectGET(url, getHeaders).respond null
      Directory.listUsers {'domain':'example.com'}
      $httpBackend.flush()

    it 'should list all users in an account', ->
      url = "#{Directory.url}users?customer=1234&maxResults=20&orderBy=familyName&pageToken=pageToken&query=email%3Dsomeone@example.com&sortOrder=descending"
      $httpBackend.expectGET(url, getHeaders).respond null
      Directory.listUsers {'customer':'1234','maxResults':20,'orderBy':'familyName','pageToken':'pageToken','query':'email=someone@example.com','sortOrder':'descending'}
      $httpBackend.flush()

    # Groups

    it 'should create a group', ->
      url = "#{Directory.url}groups"
      data = { "email": "testgroup@mydomain.com", "name": "Test Group", "description": "Test Group Long Description" };
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Directory.insertGroups data
      $httpBackend.flush()

    it 'should update a group', ->
      url = "#{Directory.url}groups/testgroup@mydomain.com"
      data = { "email": "testgroup@mydomain.com", "name": "Test Group", "description": "Test Group Long Description" };
      $httpBackend.expectPUT(url, data, putHeaders).respond null
      Directory.updateGroups 'testgroup@mydomain.com', data
      $httpBackend.flush()

    it 'should patch a group', ->
      url = "#{Directory.url}groups/testgroup@mydomain.com"
      data = { "email": "testgroup@mydomain.com", "description": "Test Group Long Description" };
      $httpBackend.expectPATCH(url, data, putHeaders).respond null
      Directory.patchGroups 'testgroup@mydomain.com', data
      $httpBackend.flush()

    it 'should get a group', ->
      url = "#{Directory.url}groups/testgroup@mydomain.com"
      $httpBackend.expectGET(url, getHeaders).respond null
      Directory.getGroups 'testgroup@mydomain.com'
      $httpBackend.flush()

    it 'should list all groups', ->
      url = "#{Directory.url}groups?domain=example.com"
      $httpBackend.expectGET(url, getHeaders).respond null
      Directory.listGroups {'domain':'example.com'}
      $httpBackend.flush()

    it 'should delete a group', ->
      url = "#{Directory.url}groups/testgroup@mydomain.com"
      $httpBackend.expectDELETE(url, getHeaders).respond null
      Directory.deleteGroups 'testgroup@mydomain.com'
      $httpBackend.flush()

    # Group Members

    it 'should create a member', ->
      url = "#{Directory.url}groups/testgroup@mydomain.com/members"
      data = {"kind":"admin#directory#member","email":"testuser@example.com","role":"MEMBER"}
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Directory.insertMembers 'testgroup@mydomain.com', data
      $httpBackend.flush()

    it 'should update a member', ->
      url = "#{Directory.url}groups/testgroup@mydomain.com/members/testuser@mydomain.com"
      data = {"kind":"admin#directory#member","role":"MEMBER"}
      $httpBackend.expectPUT(url, data, putHeaders).respond null
      Directory.updateMembers 'testgroup@mydomain.com', 'testuser@mydomain.com', data
      $httpBackend.flush()

    it 'should patch a member', ->
      url = "#{Directory.url}groups/testgroup@mydomain.com/members/testuser@mydomain.com"
      data = {"kind":"admin#directory#member","role":"MEMBER"}
      $httpBackend.expectPATCH(url, data, putHeaders).respond null
      Directory.patchMembers 'testgroup@mydomain.com', 'testuser@mydomain.com', data
      $httpBackend.flush()

    it 'should get a member', ->
      url = "#{Directory.url}groups/testgroup@mydomain.com/members/testuser@mydomain.com"
      $httpBackend.expectGET(url, getHeaders).respond null
      Directory.getMembers 'testgroup@mydomain.com', 'testuser@mydomain.com'
      $httpBackend.flush()

    it 'should list all members', ->
      url = "#{Directory.url}groups/testgroup@mydomain.com/members"
      $httpBackend.expectGET(url, getHeaders).respond null
      Directory.listMembers 'testgroup@mydomain.com'
      $httpBackend.flush()

    it 'should delete a member', ->
      url = "#{Directory.url}groups/testgroup@mydomain.com/members/testuser@mydomain.com"
      $httpBackend.expectDELETE(url, getHeaders).respond null
      Directory.deleteMembers 'testgroup@mydomain.com', 'testuser@mydomain.com'
      $httpBackend.flush()

