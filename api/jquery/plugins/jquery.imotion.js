/*!
 * jquery.imotion.js
 *
 * @author:  Yusuke Sugomori (http://yusugomori.com)
 * @license: http://yusugomori.com/license/mit
 * @version: 1.0.0
*/
(function(a){a.fn.extend({imotion:function(d){var c,e,b,g,f,h=this;if(d==null){d={}}b=a.fn.imotion;b.options=d;if(a.isArray(d.imgs)!==true){return}c=[];for(e=g=0,f=d.imgs.length;0<=f?g<f:g>f;e=0<=f?++g:--g){c.push(b.preload(d.imgs[e]))}$.when.apply(null,c).done(function(){var i,j;if(d.dfd!=null){i=d.dfd}else{i=a.Deferred();i.resolve()}if(d.wait!=null){j=d.wait}else{j=0}return i.then(function(){var m,l,k;if(d.fps!=null){m=d.fps}else{m=20}if((d.skipFirst!=null)&&d.skipFirst===true){l=1}else{l=0}k=1000/m;return setTimeout(function(){return b.animate(h,b,k,l,d.imgs.length)},j)})}).fail(function(){return h});return this}});return a.extend(a.fn.imotion,{preload:function(d){var b,c;b=$.Deferred();c=document.createElement("img");c.src=d;c.addEventListener("load",function(){return b.resolve()},false);c.onerror=function(){return b.reject()};return b.promise()},animate:function(f,d,c,e,b){if(e===b){return}return setTimeout(function(){f.attr("src",d.options.imgs[e]);return d.animate(f,d,c,e+1,b)},c)}})})(jQuery);