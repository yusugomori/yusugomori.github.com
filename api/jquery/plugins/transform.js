/*!
 * A jQuery plugin which auto-detects and auto-sets css3 transform -prefix
 * Example:  $('.elem').transform('rotate(90deg)');
 *
 * @author:  Yusuke Sugomori  http://yusugomori.com
 * @version: 1.0.0
*/
(function(jQuery) {
  var $;
  $ = jQuery;
  $.fn.extend({
    transform: function(value) {
      var key, prefix, self;
      self = $.fn.transform;
      prefix = self.attr();
      if (prefix == null) return;
      key = prefix + 'transform';
      return this.each(function() {
        return $(this).css(key, value);
      });
    }
  });
  return $.extend($.fn.transform, {
    attr: function() {
      if (document.body.style.transform != null) return '';
      if (document.body.style.webkitTransform != null) return '-webkit-';
      if (document.body.style.MozTransform != null) return '-moz-';
      if (document.body.style.msTransform != null) return '-ms-';
      if (document.body.style.OTransform != null) return '-o-';
    }
  });
})(jQuery);
