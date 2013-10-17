describe 'GAPI', ->

  { 
    GAPI,Youtube,
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



  describe 'Youtube', ->

    beforeEach inject ($injector) ->
      Youtube = $injector.get('Youtube')

    it 'should refer to the youtube api', ->
      expect(Youtube.api).toBe 'youtube'

    it 'should refer to version 3', ->
      expect(Youtube.version).toBe 'v3'

    it 'should refer to the correct url', ->
      expect(Youtube.url).toBe 'https://www.googleapis.com/youtube/v3/'

    it 'should list activities', ->
      url = "#{Youtube.url}activities?home=true&part=snippet"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listActivities({part:'snippet', home:true})
      $httpBackend.flush()

    it 'should insert activities'

    it 'should list channels', ->
      url = "#{Youtube.url}channels?mine=true&part=snippet"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listChannels({part:'snippet', mine:true})
      $httpBackend.flush()

    it 'should update channels'
    
    it 'should list guide categories'
    
    it 'should bind live broadcasts'
    it 'should control live broadcasts'
    it 'should transition live broadcasts'
    it 'should list live broadcasts'
    it 'should insert live broadcasts'
    it 'should update live broadcasts'
    it 'should delete live broadcasts'
    
    it 'should list live streams'
    it 'should insert live streams'
    it 'should update live streams'
    it 'should delete live streams'
    
    it 'should list playlist items', ->
      url = "#{Youtube.url}playlistItems?maxResults=50&part=snippet&playlistId=1234"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listPlaylistItems 
          part: 'snippet'
          maxResults: 50
          playlistId: '1234'
      $httpBackend.flush()      

    it 'should insert playlist items'
    it 'should update playlist items'
    it 'should delete playlist items'
    
    it 'should list playlists', ->
      url = "#{Youtube.url}playlists?mine=true&part=snippet"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listPlaylists({part:'snippet', mine:true})
      $httpBackend.flush()

    it 'should insert playlists'
    it 'should update playlists'
    it 'should delete playlists'
    
    it 'should list subscriptions', ->
      url = "#{Youtube.url}subscriptions?mine=true&part=snippet"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listSubscriptions({part:'snippet', mine:true})
      $httpBackend.flush()

    it 'should insert subscriptions'
    it 'should delete subscriptions'
    
    it 'should set thumbnail'
    
    it 'should list video categories'
    
    it 'should list videos', ->
      url = "#{Youtube.url}videos?myRating=like&part=snippet"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listVideos({part:'snippet', myRating:'like'})
      $httpBackend.flush()

    it 'should insert videos'
    it 'should update videos'
    it 'should delete videos'
    
    it 'should set watermark'
    it 'should unset watermark'
    
    it 'should rate'
    it 'should get rating'
    
    it 'should search'
