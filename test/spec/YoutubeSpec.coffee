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


    # SERVICE PROPERTIES

    it 'should refer to the youtube api', ->
      expect(Youtube.api).toBe 'youtube'

    it 'should refer to version 3', ->
      expect(Youtube.version).toBe 'v3'

    it 'should refer to the correct url', ->
      expect(Youtube.url).toBe 'https://www.googleapis.com/youtube/v3/'


    # ACTIVITIES

    it 'should list activities', ->
      url = "#{Youtube.url}activities?home=true&part=snippet"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listActivities({part:'snippet', home:true})
      $httpBackend.flush()

    it 'should insert activities', ->
      url = "#{Youtube.url}activities?part=snippet"
      data = snippet: { description: 'description' }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Youtube.insertActivities(data, { part: 'snippet' })
      $httpBackend.flush()


    # This one uploads a file. How do we do uploads?
    it 'should insert channel banners'  


    # CHANNELS

    it 'should list channels', ->
      url = "#{Youtube.url}channels?mine=true&part=snippet"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listChannels({part:'snippet', mine:true})
      $httpBackend.flush()

    it 'should update channels', ->
      url = "#{Youtube.url}channels?part=id"
      data = { id: 'qwerty' }
      $httpBackend.expectPUT(url, data, postHeaders).respond null
      Youtube.updateChannels(data, { part: 'id' })
      $httpBackend.flush()
    

    # GUIDE CATEGORIES

    it 'should list guide categories', ->
      url = "#{Youtube.url}guideCategories?part=snippet"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listGuideCategories({part:'snippet'})
      $httpBackend.flush()
    

    # LIVE BROADCASTS

    it 'should bind live broadcasts'
    it 'should control live broadcasts'
    it 'should transition live broadcasts'
    it 'should list live broadcasts'
    it 'should insert live broadcasts'
    it 'should update live broadcasts'
    it 'should delete live broadcasts'
    

    # LIVE STREAMS

    it 'should list live streams'
    it 'should insert live streams'
    it 'should update live streams'
    it 'should delete live streams'
    

    # PLAYLIST ITEMS

    it 'should list playlist items', ->
      url = "#{Youtube.url}playlistItems?maxResults=50&part=snippet&playlistId=1234"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listPlaylistItems 
          part: 'snippet'
          maxResults: 50
          playlistId: '1234'
      $httpBackend.flush()      

    it 'should insert playlist items', ->
      url = "#{Youtube.url}playlistItems?part=snippet"
      data = { snippet: { playlistId: 'x', resourceId: 'y'} }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Youtube.insertPlaylistItems(data, { part: 'snippet' })
      $httpBackend.flush()

    it 'should update playlist items', ->
      url = "#{Youtube.url}playlistItems?part=snippet"
      data = { id: '123', snippet: { playlistId: 'x', resourceId: 'y'} }
      $httpBackend.expectPUT(url, data, postHeaders).respond null
      Youtube.updatePlaylistItems(data, { part: 'snippet' })
      $httpBackend.flush()

    it 'should delete playlist items', ->
      url = "#{Youtube.url}playlistItems?id=xyz"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Youtube.deletePlaylistItems id: 'xyz'
      $httpBackend.flush()
    

    # PLAYLISTS

    it 'should list playlists', ->
      url = "#{Youtube.url}playlists?mine=true&part=snippet"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listPlaylists({part:'snippet', mine:true})
      $httpBackend.flush()

    it 'should insert playlists', ->
      url = "#{Youtube.url}playlists?part=snippet"
      data = { snippet: { title: 'abc'} }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Youtube.insertPlaylists(data, { part: 'snippet' })
      $httpBackend.flush()

    it 'should update playlists', ->
      url = "#{Youtube.url}playlists?part=snippet"
      data = { id: '123', snippet: { title: 'updated'} }
      $httpBackend.expectPUT(url, data, postHeaders).respond null
      Youtube.updatePlaylists(data, { part: 'snippet' })
      $httpBackend.flush()

    it 'should delete playlists', ->
      url = "#{Youtube.url}playlists?id=xyz"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Youtube.deletePlaylists id: 'xyz'
      $httpBackend.flush()
    

    # SUBSCRIPTIONS

    it 'should list subscriptions', ->
      url = "#{Youtube.url}subscriptions?mine=true&part=snippet"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listSubscriptions({part:'snippet', mine:true})
      $httpBackend.flush()

    it 'should insert subscriptions', ->
      url = "#{Youtube.url}subscriptions?part=snippet"
      data = { snippet: { resourceId: 'abc'} }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Youtube.insertSubscriptions(data, { part: 'snippet' })
      $httpBackend.flush()

    it 'should delete subscriptions', ->
      url = "#{Youtube.url}subscriptions?id=xyz"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Youtube.deleteSubscriptions id: 'xyz'
      $httpBackend.flush()
    

    # THUMBNAIL

    it 'should set thumbnails', ->
      url = "#{Youtube.url}thumbnails/set?videoId=123"
      headers =
        "Accept":"application/json, text/plain, */*"
        "X-Requested-With":"XMLHttpRequest"
        "Authorization":"Bearer 1234abcd"      
      $httpBackend.expectPOST(url, undefined, headers).respond null
      Youtube.setThumbnails({ videoId: '123' })
      $httpBackend.flush()      
    

    # VIDEO CATEGORIES

    it 'should list video categories', ->
      url = "#{Youtube.url}videoCategories?part=snippet"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listVideoCategories({ part:'snippet' })
      $httpBackend.flush()
    

    # VIDEOS

    it 'should list videos', ->
      url = "#{Youtube.url}videos?myRating=like&part=snippet"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.listVideos({part:'snippet', myRating:'like'})
      $httpBackend.flush()

    it 'should insert videos', ->
      url = "#{Youtube.url}videos?part=snippet"
      data = { snippet: { title: 'foo'} }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Youtube.insertVideos(data, { part: 'snippet' })
      $httpBackend.flush()

    it 'should update videos', ->
      url = "#{Youtube.url}videos?part=snippet"
      data = { id: '123', snippet: { title: 'updated'} }
      $httpBackend.expectPUT(url, data, postHeaders).respond null
      Youtube.updateVideos(data, { part: 'snippet' })
      $httpBackend.flush()

    it 'should delete videos', ->
      url = "#{Youtube.url}videos?id=xyz"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Youtube.deleteVideos id: 'xyz'
      $httpBackend.flush()
    
    it 'should rate videos', ->
      url = "#{Youtube.url}videos/rate?id=xyz&rating=like"
      headers = 
        "Accept":"application/json, text/plain, */*"
        "X-Requested-With":"XMLHttpRequest"
        "Authorization":"Bearer 1234abcd"
      $httpBackend.expectPOST(url, undefined, headers).respond null
      Youtube.rateVideos({ id: 'xyz', rating: 'like' })
      $httpBackend.flush()

    it 'should get rating', ->
      url = "#{Youtube.url}videos/getRating?id=xyz"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.getVideoRating({ id: 'xyz' })
      $httpBackend.flush()


    # WATERMARKS

    it 'should set watermarks', ->
      url = "#{Youtube.url}watermarks/set?channelId=123"
      headers =
        "Accept":"application/json, text/plain, */*"
        "X-Requested-With":"XMLHttpRequest"
        "Authorization":"Bearer 1234abcd"      
      $httpBackend.expectPOST(url, undefined, headers).respond null
      Youtube.setWatermarks({ channelId: '123' })
      $httpBackend.flush()

    it 'should unset watermark', ->
      url = "#{Youtube.url}watermarks/unset?channelId=123"
      headers =
        "Accept":"application/json, text/plain, */*"
        "X-Requested-With":"XMLHttpRequest"
        "Authorization":"Bearer 1234abcd"      
      $httpBackend.expectPOST(url, undefined, headers).respond null
      Youtube.unsetWatermarks({ channelId: '123' })
      $httpBackend.flush()    
    

    # SEARCH
    
    it 'should search', ->
      url = "#{Youtube.url}search?part=snippet&q=terms"
      $httpBackend.expectGET(url, getHeaders).respond null
      Youtube.search({ part: 'snippet', q: 'terms' })
      $httpBackend.flush()
