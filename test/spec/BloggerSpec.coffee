describe 'GAPI', ->

  { 
    GAPI,Blogger,
    $httpBackend,baseUrl,
    getHeaders,postHeaders,putHeaders,deleteHeaders,patchHeaders,noContentHeaders,
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


  describe 'Blogger', ->

    beforeEach inject ($injector) ->
      Blogger = $injector.get('Blogger')

    it 'should refer to the blogger api', ->
      expect(Blogger.api).toBe 'blogger'

    it 'should refer to version 3', ->
      expect(Blogger.version).toBe 'v3'

    it 'should refer to the correct url', ->
      expect(Blogger.url).toBe 'https://www.googleapis.com/blogger/v3/'


    # BLOGS

    it 'should get blog by id', ->
      url = "#{Blogger.url}blogs/xyz"
      $httpBackend.expectGET(url, getHeaders).respond null
      Blogger.getBlogs 'xyz' 
      $httpBackend.flush()

    it 'should get blog by url', ->
      url = "#{Blogger.url}blogs/byurl?url=example.blogspot.com"
      $httpBackend.expectGET(url, getHeaders).respond null
      Blogger.getBlogByUrl url: 'example.blogspot.com'
      $httpBackend.flush()

    it 'should list blogs by user', ->
      url = "#{Blogger.url}users/xyz/blogs?view=author"
      $httpBackend.expectGET(url, getHeaders).respond null
      Blogger.listBlogsByUser 'xyz', view: 'author'
      $httpBackend.flush()


    # COMMENTS

    it 'should list comments', ->
      url = "#{Blogger.url}blogs/123/posts/456/comments?maxResults=5"
      $httpBackend.expectGET(url, getHeaders).respond null
      Blogger.listComments '123', '456', { maxResults: 5 }
      $httpBackend.flush()

    it 'should get a comment', ->
      url = "#{Blogger.url}blogs/123/posts/456/comments/789"
      $httpBackend.expectGET(url, getHeaders).respond null
      Blogger.getComments '123', '456', '789'
      $httpBackend.flush()

    it 'should approve a comment', ->
      url = "#{Blogger.url}blogs/123/posts/456/comments/789/approve"
      $httpBackend.expectPOST(url, undefined, noContentHeaders).respond null
      Blogger.approveComments '123', '456', '789'
      $httpBackend.flush()      

    it 'should delete a comment', ->
      url = "#{Blogger.url}blogs/123/posts/456/comments/789"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Blogger.deleteComments '123', '456', '789'
      $httpBackend.flush()

    it 'should list comments by blog', ->
      url = "#{Blogger.url}blogs/123/comments?maxResults=5"
      $httpBackend.expectGET(url, getHeaders).respond null
      Blogger.listCommentsByBlog '123', maxResults: 5
      $httpBackend.flush()

    it 'should mark a comment as spam', ->
      url = "#{Blogger.url}blogs/123/posts/456/comments/789/spam"
      $httpBackend.expectPOST(url, undefined, noContentHeaders).respond null
      Blogger.markCommentsAsSpam '123', '456', '789'
      $httpBackend.flush()

    it 'should remove the content of a comment', ->
      url = "#{Blogger.url}blogs/123/posts/456/comments/789/removecontent"
      $httpBackend.expectPOST(url, undefined, noContentHeaders).respond null
      Blogger.removeContent '123', '456', '789'
      $httpBackend.flush()


    # PAGES
    
    it 'should list pages', ->
      url = "#{Blogger.url}blogs/123/pages?fetchBodies=true"
      $httpBackend.expectGET(url, getHeaders).respond null
      Blogger.listPages '123', fetchBodies: true
      $httpBackend.flush()

    it 'should get a page', ->
      url = "#{Blogger.url}blogs/123/pages/456?view=admin"
      $httpBackend.expectGET(url, getHeaders).respond null
      Blogger.listPages '123', '456', view: 'admin'
      $httpBackend.flush()

    it 'should delete a page', ->
      url = "#{Blogger.url}blogs/123/pages/456"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Blogger.deletePages '123', '456'
      $httpBackend.flush()

    it 'should insert a page', ->
      url = "#{Blogger.url}blogs/123/pages"
      data =   
        title: 'string'
        content: 'string'
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Blogger.insertPages '123', data
      $httpBackend.flush() 

    it 'should patch a page', ->
      url = "#{Blogger.url}blogs/123/pages/456"
      data =   
        title: 'string'
        content: 'string'      
      $httpBackend.expectPATCH(url, data, patchHeaders).respond null
      Blogger.patchPages '123', '456', data
      $httpBackend.flush() 

    it 'should update a page', ->
      url = "#{Blogger.url}blogs/123/pages/456"
      data =   
        title: 'string'
        content: 'string'      
      $httpBackend.expectPUT(url, data, putHeaders).respond null
      Blogger.updatePages '123', '456', data
      $httpBackend.flush() 


    # POSTS

    it 'should list posts', ->
      url = "#{Blogger.url}blogs/123/posts?fetchBodies=true"
      $httpBackend.expectGET(url, getHeaders).respond null
      Blogger.listPosts '123', fetchBodies: true
      $httpBackend.flush()

    it 'should get a post', ->
      url = "#{Blogger.url}blogs/123/posts/456?view=admin"
      $httpBackend.expectGET(url, getHeaders).respond null
      Blogger.getPosts '123', '456', view: 'admin'
      $httpBackend.flush()

    it 'should search posts', ->
      url = "#{Blogger.url}blogs/123/posts/search?q=terms"
      $httpBackend.expectGET(url, getHeaders).respond null
      Blogger.searchPosts '123', q: 'terms'
      $httpBackend.flush()

    it 'should insert a post', ->
      url = "#{Blogger.url}blogs/123/posts?isDraft=true"
      data =   
        title: 'string'
        content: 'string'
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Blogger.insertPosts '123', data, { isDraft: true }
      $httpBackend.flush()

    it 'should delete a post', ->
      url = "#{Blogger.url}blogs/123/posts/456"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Blogger.deletePosts '123', '456'
      $httpBackend.flush()

    it 'should get posts by path', ->
      url = "#{Blogger.url}blogs/123/posts/bypath?path=path%2Fto%2Fpost"
      $httpBackend.expectGET(url, getHeaders).respond null
      Blogger.getPostsByPath '123', path: 'path/to/post'
      $httpBackend.flush()

    it 'should patch a post', ->
      url = "#{Blogger.url}blogs/123/posts/456"
      data =   
        title: 'string'
        content: 'string'      
      $httpBackend.expectPATCH(url, data, patchHeaders).respond null
      Blogger.patchPosts '123', '456', data
      $httpBackend.flush() 

    it 'should update a post', ->
      url = "#{Blogger.url}blogs/123/posts/456"
      data =   
        title: 'string'
        content: 'string'      
      $httpBackend.expectPUT(url, data, putHeaders).respond null
      Blogger.updatePosts '123', '456', data
      $httpBackend.flush() 

    it 'should publish a post', ->
      url = "#{Blogger.url}blogs/123/posts/456/publish?publishDate=datetime"
      $httpBackend.expectPOST(url, undefined, noContentHeaders).respond null
      Blogger.publishPosts '123', '456', { publishDate: 'datetime' }
      $httpBackend.flush()

    it 'should revert a post', ->
      url = "#{Blogger.url}blogs/123/posts/456/revert"
      $httpBackend.expectPOST(url, undefined, noContentHeaders).respond null
      Blogger.revertPosts '123', '456'
      $httpBackend.flush()


    # USERS

    it 'should get a user', ->
      url = "#{Blogger.url}users/xyz"
      $httpBackend.expectGET(url, getHeaders).respond null
      Blogger.getUsers 'xyz'
      $httpBackend.flush()


    # BLOGUSERINFOS (yes, that's really what they call it in the docs...)

    it 'should get blog and user info', ->
      url = "#{Blogger.url}users/xyz/blogs/123?maxPosts=5"
      $httpBackend.expectGET(url, getHeaders).respond null
      Blogger.getBlogUserInfos 'xyz', '123', { maxPosts: 5 }
      $httpBackend.flush()


    # PAGEVIEWS
    
    it 'should get pageviews for a blog', ->
      url = "#{Blogger.url}blogs/123/pageviews?range=all"
      $httpBackend.expectGET(url, getHeaders).respond null
      Blogger.getPageViews '123', range: 'all'
      $httpBackend.flush()


    # POSTUSERINFOS

    it 'should get post and user info', ->
      url = "#{Blogger.url}users/xyz/blogs/123/posts/456?maxComments=5"
      $httpBackend.expectGET(url, getHeaders).respond null
      Blogger.getPostUserInfos 'xyz', '123', '456', { maxComments: 5 }
      $httpBackend.flush()

    it 'should list post and user pairs for a blog', ->
      url = "#{Blogger.url}users/xyz/blogs/123/posts?maxResults=5"
      $httpBackend.expectGET(url, getHeaders).respond null
      Blogger.listPostUserInfos 'xyz', '123', { maxResults: 5 }
      $httpBackend.flush()
