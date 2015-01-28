describe 'GAPI', ->

  { 
    GAPI,AdminDirectory,
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


  describe 'AdminDirectory', ->

    beforeEach inject ($injector) ->
      AdminDirectory = $injector.get('AdminDirectory')


    # SERVICE PROPERTIES

    it 'should refer to the AdminDirectory api', ->
      expect(AdminDirectory.api).toBe 'admin/directory'

    it 'should refer to version 1', ->
      expect(AdminDirectory.version).toBe 'v1'

    it 'should refer to the correct url', ->
      expect(AdminDirectory.url).toBe 'https://www.googleapis.com/admin/directory/v1/'


    # Users

    it 'should create a user', ->
      url = "#{AdminDirectory.url}users"
      data = { "primaryEmail": "liz@example.com", "name": { "givenName": "Elizabeth", "familyName": "Smith" }, "suspended": false, "password": "new user password", "hashFunction": "SHA-1", "changePasswordAtNextLogin": false, "ipWhitelisted": false, "ims": [ { "type": "work", "protocol": "gtalk", "im": "liz_im@talk.example.com", "primary": true } ], "emails": [ { "address": "liz@example.com", "type": "home", "customType": "", "primary": true } ], "addresses": [ { "type": "work", "customType": "", "streetAddress": "1600 Amphitheatre Parkway", "locality": "Mountain View", "region": "CA", "postalCode": "94043" } ], "externalIds": [ { "value": "12345", "type": "custom", "customType": "employee" } ], "relations": [ { "value": "Mom", "type": "mother", "customType": "" }, { "value": "manager", "type": "referred_by", "customType": "" } ], "organizations": [ { "name": "Google Inc.", "title": "SWE", "primary": true, "type": "work", "description": "Software engineer" } ], "phones": [ { "value": "+1 nnn nnn nnnn", "type": "work" } ], "orgUnitPath": "/corp/engineering", "includeInGlobalAddressList": true }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      AdminDirectory.insertUsers data
      $httpBackend.flush()

    it 'should update a user', ->
      url = "#{AdminDirectory.url}users/123"
      data = { "primaryEmail": "liz@example.com", "name": { "givenName": "Elizabeth", "familyName": "Smith" }, "suspended": false, "password": "new user password", "hashFunction": "SHA-1", "changePasswordAtNextLogin": false, "ipWhitelisted": false, "ims": [ { "type": "work", "protocol": "gtalk", "im": "liz_im@talk.example.com", "primary": true } ], "emails": [ { "address": "liz@example.com", "type": "home", "customType": "", "primary": true } ], "addresses": [ { "type": "work", "customType": "", "streetAddress": "1600 Amphitheatre Parkway", "locality": "Mountain View", "region": "CA", "postalCode": "94043" } ], "externalIds": [ { "value": "12345", "type": "custom", "customType": "employee" } ], "relations": [ { "value": "Mom", "type": "mother", "customType": "" }, { "value": "manager", "type": "referred_by", "customType": "" } ], "organizations": [ { "name": "Google Inc.", "title": "SWE", "primary": true, "type": "work", "description": "Software engineer" } ], "phones": [ { "value": "+1 nnn nnn nnnn", "type": "work" } ], "orgUnitPath": "/corp/engineering", "includeInGlobalAddressList": true }
      $httpBackend.expectPUT(url, data, putHeaders).respond null
      AdminDirectory.updateUsers '123', data
      $httpBackend.flush()

    it 'should make a user an administrator', ->
      url = "#{AdminDirectory.url}users/123/makeAdmin"
      data = { "status": true }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      AdminDirectory.makeAdmin '123'
      $httpBackend.flush()

    it 'should make an administrator a user', ->
      url = "#{AdminDirectory.url}users/123/makeAdmin"
      data = { "status": false }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      AdminDirectory.unMakeAdmin '123'
      $httpBackend.flush()

    it 'should get a user', ->
      url = "#{AdminDirectory.url}users/123"
      $httpBackend.expectGET(url, getHeaders).respond null
      AdminDirectory.getUsers '123'
      $httpBackend.flush()

    it 'should get a user', ->
      url = "#{AdminDirectory.url}users/123"
      $httpBackend.expectGET(url, getHeaders).respond null
      AdminDirectory.getUsers '123'
      $httpBackend.flush()

    it 'should list all users in a domain', ->
      url = "#{AdminDirectory.url}users?domain=example.com"
      $httpBackend.expectGET(url, getHeaders).respond null
      AdminDirectory.listUsers {'domain':'example.com'}
      $httpBackend.flush()

    it 'should list all users in an account', ->
      url = "#{AdminDirectory.url}users?customer=1234&maxResults=20&orderBy=familyName&pageToken=pageToken&query=email%3Dsomeone@example.com&sortOrder=descending"
      $httpBackend.expectGET(url, getHeaders).respond null
      AdminDirectory.listUsers {'customer':'1234','maxResults':20,'orderBy':'familyName','pageToken':'pageToken','query':'email=someone@example.com','sortOrder':'descending'}
      $httpBackend.flush()

