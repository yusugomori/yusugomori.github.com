###!
 * A jQuery plugin which auto-detects and auto-sets css3 transform -prefix
 * Example:  $('.elem').transform('rotate(90deg)');
 *
 * @author:  Yusuke Sugomori  http://yusugomori.com
 * @version: 1.0.0
 ###

do (jQuery) ->
  $ = jQuery
  $.fn.extend
    transform: (value) ->
      self = $.fn.transform

      prefix = self.attr()
      return unless prefix?  # transform unsupported

      key = prefix + 'transform'

      @each () ->
        $(@).css key, value


  $.extend $.fn.transform,
    attr: () ->
      if document.body.style.transform?
        return ''

      if document.body.style.webkitTransform?
        return '-webkit-'

      if document.body.style.MozTransform?
        return '-moz-'

      if document.body.style.msTransform?
        return '-ms-'

      if document.body.style.OTransform?
        return '-o-'
