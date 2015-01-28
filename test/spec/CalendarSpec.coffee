describe 'GAPI', ->

  {
    GAPI,Calendar,
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


  describe 'Calendar', ->

    beforeEach inject ($injector) ->
      Calendar = $injector.get('Calendar')


    # SERVICE PROPERTIES

    it 'should refer to the Calendar api', ->
      expect(Calendar.api).toBe 'calendar'

    it 'should refer to version 3', ->
      expect(Calendar.version).toBe 'v3'

    it 'should refer to the correct url', ->
      expect(Calendar.url).toBe 'https://www.googleapis.com/calendar/v3/'


    # ACLs

    it 'should delete an acl', ->
      url = "#{Calendar.url}calendars/123/acl/456"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Calendar.deleteAcl '123', '456'
      $httpBackend.flush()

    it 'should get an acl', ->
      url = "#{Calendar.url}calendars/123/acl/456"
      $httpBackend.expectGET(url, getHeaders).respond null
      Calendar.getAcl '123', '456'
      $httpBackend.flush()

    it 'should insert an acl', ->
      url = "#{Calendar.url}calendars/123/acl"
      data = { role: 'owner', scope: { type: 'user' } }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Calendar.insertAcl '123', data
      $httpBackend.flush()

    it 'should list an acl', ->
      url = "#{Calendar.url}calendars/123/acl"
      $httpBackend.expectGET(url, getHeaders).respond null
      Calendar.listAcl '123'
      $httpBackend.flush()

    it 'should update an acl', ->
      url = "#{Calendar.url}calendars/123/acl/456"
      data = { role: 'writer' }
      $httpBackend.expectPUT(url, data, postHeaders).respond null
      Calendar.updateAcl '123', '456', data
      $httpBackend.flush()

    it 'should patch an acl', ->
      url = "#{Calendar.url}calendars/123/acl/456"
      data = { role: 'reader' }
      $httpBackend.expectPATCH(url, data, patchHeaders).respond null
      Calendar.patchAcl '123', '456', data
      $httpBackend.flush()


    # CALENDAR LIST

    it 'should delete a calendar list', ->
      url = "#{Calendar.url}users/me/calendarList/xyz"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Calendar.deleteCalendarList 'xyz'
      $httpBackend.flush()

    it 'should get a calendar list', ->
      url = "#{Calendar.url}users/me/calendarList/xyz"
      $httpBackend.expectGET(url, getHeaders).respond null
      Calendar.getCalendarList 'xyz'
      $httpBackend.flush()

    it 'should insert a calendar list', ->
      url = "#{Calendar.url}users/me/calendarList"
      data = { id: 'xyz', defaultReminders: { minutes: 15, methods: 'email' } }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Calendar.insertCalendarList(data)
      $httpBackend.flush()

    it 'should list a user\'s calendar lists', ->
      url = "#{Calendar.url}users/me/calendarList?maxResults=5"
      $httpBackend.expectGET(url, getHeaders).respond null
      Calendar.listCalendarList { maxResults: 5 }
      $httpBackend.flush()

    it 'should update a calendar list', ->
      url = "#{Calendar.url}users/me/calendarList/xyz"
      data = { defaultReminders: { minutes: 15, methods: 'email' } }
      $httpBackend.expectPUT(url, data, putHeaders).respond null
      Calendar.updateCalendarList 'xyz', data
      $httpBackend.flush()

    it 'should patch a calendar list', ->
      url = "#{Calendar.url}users/me/calendarList/xyz"
      data = { defaultReminders: { minutes: 15, methods: 'email' } }
      $httpBackend.expectPATCH(url, data, patchHeaders).respond null
      Calendar.patchCalendarList 'xyz', data
      $httpBackend.flush()


    # CALENDARS

    it 'should clear a calendar', ->
      url = "#{Calendar.url}calendars/xyz/clear"
      $httpBackend.expectPOST(url, undefined, noContentHeaders).respond null
      Calendar.clearCalendar('xyz')
      $httpBackend.flush()

    it 'should delete a secondary calendar', ->
      url = "#{Calendar.url}calendars/xyz"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Calendar.deleteCalendars 'xyz'
      $httpBackend.flush()

    it 'should get calendar metadata', ->
      url = "#{Calendar.url}calendars/xyz"
      $httpBackend.expectGET(url, getHeaders).respond null
      Calendar.getCalendars('xyz')
      $httpBackend.flush()

    it 'should insert a secondary calendar', ->
      url = "#{Calendar.url}calendars"
      data = { summary: 'title of calendar' }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Calendar.insertCalendars(data)
      $httpBackend.flush()

    it 'should update metadata for a calendar', ->
      url = "#{Calendar.url}calendars/xyz"
      data = { description: 'about the calendar' }
      $httpBackend.expectPUT(url, data, postHeaders).respond null
      Calendar.updateCalendars('xyz', data)
      $httpBackend.flush()

    it 'should patch metadata for a calendar', ->
      url = "#{Calendar.url}calendars/xyz"
      data = { id: '123', description: 'patched' }
      $httpBackend.expectPATCH(url, data, patchHeaders).respond null
      Calendar.patchCalendars('xyz', data)
      $httpBackend.flush()


    # COLORS

    it 'should get colors', ->
      url = "#{Calendar.url}colors"
      $httpBackend.expectGET(url, getHeaders).respond null
      Calendar.getColors()
      $httpBackend.flush()


    # EVENTS

    it 'should delete an event', ->
      url = "#{Calendar.url}calendars/123/events/456"
      $httpBackend.expectDELETE(url, deleteHeaders).respond null
      Calendar.deleteEvents '123', '456'
      $httpBackend.flush()

    it 'should get an event', ->
      url = "#{Calendar.url}calendars/123/events/456"
      $httpBackend.expectGET(url, getHeaders).respond null
      Calendar.getEvents '123', '456'
      $httpBackend.flush()

    it 'should import an event', ->
      url = "#{Calendar.url}calendars/123/events/import"
      data = { attendees: ['joe@example.com'], start: {}, end: {} }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Calendar.importEvents '123', data
      $httpBackend.flush()

    it 'should insert an event', ->
      url = "#{Calendar.url}calendars/123/events"
      data = { attendees: ['joe@example.com'], start: {}, end: {} }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Calendar.insertEvents '123', data
      $httpBackend.flush()

    it 'should list instances of a recurring event', ->
      url = "#{Calendar.url}calendars/123/events/456/instances"
      $httpBackend.expectGET(url, getHeaders).respond null
      Calendar.listEventInstances '123', '456'
      $httpBackend.flush()

    it 'should list events on a specified calendar', ->
      url = "#{Calendar.url}calendars/123/events"
      $httpBackend.expectGET(url, getHeaders).respond null
      Calendar.listEvents '123'
      $httpBackend.flush()

    it 'should move an event to another calendar', ->
      url = "#{Calendar.url}calendars/123/events/456/move?destination=124"
      $httpBackend.expectPOST(url, undefined, noContentHeaders).respond null
      Calendar.moveEvents '123', '456', '124'
      $httpBackend.flush()

    it 'should create an event based on a simple text string', ->
      text = 'Appointment at Somewhere on June 3rd 10am-10:25am'
      url = "#{Calendar.url}calendars/123/events/quickAdd?text=Appointment+at+Somewhere+on+June+3rd+10am-10:25am"
      $httpBackend.expectPOST(url, undefined, noContentHeaders).respond null
      Calendar.quickAdd '123', {text}
      $httpBackend.flush()

    it 'should update an event', ->
      url = "#{Calendar.url}calendars/123/events/456"
      data = { attendees: ['joe@example.com'], start: {}, end: {} }
      $httpBackend.expectPUT(url, data, postHeaders).respond null
      Calendar.updateEvents '123', '456', data
      $httpBackend.flush()

    it 'should patch an event', ->
      url = "#{Calendar.url}calendars/123/events/456"
      data = { attendees: ['joe@example.com'], start: {}, end: {} }
      $httpBackend.expectPATCH(url, data, patchHeaders).respond null
      Calendar.patchEvents '123', '456', data
      $httpBackend.flush()

    it 'should watch for changes to events', ->
      url = "#{Calendar.url}calendars/123/events/watch"
      data =
        id: 'string'
        token: 'string'
        type: 'string'
        address: 'string'
        params:
          ttl: 'string'
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Calendar.watchEvents '123', data
      $httpBackend.flush()


    # FREEBUSY

    it 'should get free/busy for a set of calendars', ->
      url = "#{Calendar.url}freeBusy"
      data =
        timeMin: 'datetime',
        timeMax: 'datetime',
        timeZone: 'string',
        groupExpansionMax: 'integer',
        calendarExpansionMax: 'integer',
        items:
          id: 'string'
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Calendar.freeBusy(data)
      $httpBackend.flush()


    # SETTINGS

    it 'should get a user setting', ->
      url = "#{Calendar.url}users/me/settings/xyz"
      $httpBackend.expectGET(url, getHeaders).respond null
      Calendar.getSettings 'xyz'
      $httpBackend.flush()

    it 'should list user settings for the authenticated user', ->
      url = "#{Calendar.url}users/me/settings"
      $httpBackend.expectGET(url, getHeaders).respond null
      Calendar.listSettings()
      $httpBackend.flush()


    # CHANNELS

    it 'should stop a channel', ->
      url = "#{Calendar.url}channels/stop"
      data = { id: 'string', resourceId: 'string' }
      $httpBackend.expectPOST(url, data, postHeaders).respond null
      Calendar.stopWatching data
      $httpBackend.flush()
