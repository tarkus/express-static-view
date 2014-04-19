// Generated by CoffeeScript 1.7.1
(function() {
  var cache, is_cached, _cache;

  _cache = {};

  is_cached = function(key) {
    return _cache[key] || null;
  };

  cache = function(key, html) {
    return _cache[key] = html;
  };

  module.exports = function(view, opts) {
    var key;
    if (opts == null) {
      opts = {};
    }
    key = "" + view + ":" + (opts.variant || '');
    return function(req, res) {
      var cached;
      cached = is_cached(key);
      if (cached) {
        res.set('X-View-Cache', 'on');
        if (opts.filter != null) {
          return res.send(opts.filter(cached, res.locals));
        }
        return res.send(cached);
      }
      return res.render(view, function(err, html) {
        if (err) {
          return console.log(err);
        }
        cache(key, html);
        if (opts.filter != null) {
          return res.send(opts.filter(html, res.locals));
        }
        return res.send(html);
      });
    };
  };

}).call(this);