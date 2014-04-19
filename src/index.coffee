_cache = {}

is_cached = (key) -> _cache[key] or null
cache = (key, html) -> _cache[key] = html

module.exports = (view, opts={}) ->
  key = "#{view}:#{opts.variant or ''}"
  (req, res) ->
    cached = is_cached key
    if cached
      res.set 'X-View-Cache', 'on'
      return res.send opts.filter cached, res.locals if opts.filter?
      return res.send cached
    res.render view, (err, html) ->
      return console.log err if err
      cache key, html
      return res.send opts.filter html, res.locals if opts.filter?
      return res.send html
