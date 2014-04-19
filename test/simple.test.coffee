should = require 'should'
express = require 'express'
request = require 'request'
view_cache = require '../lib'



urls = [
  'http://localhost:23456/test_view_cache'
  'http://localhost:23456/test_view_cache_with_variant'
]

describe "View cache middleware", ->

  before (done) ->
    app = express()
    app.set 'view engine', 'jade'
    app.set "views", "#{__dirname}"

    app.get "/test_view_cache", view_cache "layout"

    set_variant = ->
      (req, res, next) ->
        res.locals.variant = "world"
        next()

    app.get "/test_view_cache_with_variant", set_variant(), view_cache("layout", variant: "variant")

    app.listen(23456)
    done()


  it 'should render view during first request', (done) ->
    request urls[0], (error, response, body) ->
      body.should.match /Hello/
      should.not.exists response.headers['x-view-cache']
      done()

  it 'should cache view afterwards', (done) ->
    request urls[0], (error, response, body) ->
      body.should.match /Hello/
      response.headers['x-view-cache'].should.equal 'on'
      done()

  it 'should render view with variant during first request', (done) ->
    request urls[1], (error, response, body) ->
      body.should.match /Hello world/
      should.not.exists response.headers['x-view-cache']
      done()

  it 'should cache view with variant afterwards', (done) ->
    request urls[1], (error, response, body) ->
      body.should.match /Hello world/
      response.headers['x-view-cache'].should.equal 'on'
      done()
