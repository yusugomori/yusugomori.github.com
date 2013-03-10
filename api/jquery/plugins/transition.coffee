###!
 * A jQuery plugin which auto detects and auto sets css3 transition -prefix
 * Example: $('.elem').transition('all 1s linear');
 *
 * @author:  Yusuke Sugomori  http://yusugomori.com
 * @version: 1.0.0
 ###

do (jQuery) ->
  $ = jQuery
  $.fn.extend
    transition: (value) ->
      self = $.fn.transform

      prefix = self.attr()
      return unless prefix?

      key = prefix + 'transition'

      @each () ->
        $(@).css key, value


  $.extend $.fn.transition,
    attr: () ->
      if document.body.style.transition?
        return ''

      if document.body.style.webkitTransition?
        return '-webkit-'

      if document.body.style.MozTransition?
        return '-moz-'

      if document.body.style.msTransition?
        return '-ms-'

      if document.body.style.OTransition?
        return '-o-'
