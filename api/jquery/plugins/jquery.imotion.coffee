###!
 * jquery.imotion.js
 *
 * @author:  Yusuke Sugomori (http://yusugomori.com)
 * @license: http://yusugomori.com/license/mit
 * @version: 1.0.1
 ###


do (jQuery) ->
  jQuery.fn.extend
    imotion: (options={}) ->
      self = jQuery.fn.imotion

      if jQuery.isArray(options) is true
        options =
          imgs: options

      return if jQuery.isArray(options.imgs) isnt true

      self.options = options


      dfds = []
      for i in [0...options.imgs.length]
        dfds.push self.preload(options.imgs[i])

      $.when.apply(null, dfds).done =>
        if options.dfd?
          dfd = options.dfd
        else
          dfd = jQuery.Deferred()
          dfd.resolve()

        if options.wait?
          wait = options.wait
        else
          wait = 0

        dfd.then () =>
          if options.fps?
            fps = options.fps
          else
            fps = 20

          if options.skipFirst? and options.skipFirst is true
            index = 1
          else
            index = 0

          interval = 1000 / fps
          setTimeout =>
            self.animate(@, self, interval, index, options.imgs.length)
          , wait

      .fail () =>
        return @

      return @


  jQuery.extend jQuery.fn.imotion,
    preload: (src) ->
      dfd = $.Deferred()
      img = document.createElement('img')
      img.src = src

      img.addEventListener 'load', () ->
        dfd.resolve()
      , false

      img.onerror = () ->
        dfd.reject()

      return dfd.promise()

    animate: ($img, self, interval, index, len) ->
      return if index is len
      setTimeout ->
        $img.attr 'src', self.options.imgs[index]
        self.animate($img, self, interval, index+1, len)
      , interval
