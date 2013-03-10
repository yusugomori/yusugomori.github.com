/*!
 * A jQuery plugin which auto detects and auto sets css3 transition -prefix
 * Example: $('.elem').transition('all 1s linear');
 *
 * @author:  Yusuke Sugomori  http://yusugomori.com
 * @version: 1.0.0
*/
(function(jQuery) {
  var $;
  $ = jQuery;
  $.fn.extend({
    transition: function(value) {
      var key, prefix, self;
      self = $.fn.transform;
      prefix = self.attr();
      if (prefix == null) return;
      key = prefix + 'transition';
      return this.each(function() {
        return $(this).css(key, value);
      });
    }
  });
  return $.extend($.fn.transition, {
    attr: function() {
      if (document.body.style.transition != null) return '';
      if (document.body.style.webkitTransition != null) return '-webkit-';
      if (document.body.style.MozTransition != null) return '-moz-';
      if (document.body.style.msTransition != null) return '-ms-';
      if (document.body.style.OTransition != null) return '-o-';
    }
  });
})(jQuery);
