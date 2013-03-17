/*!
 * jquery.imotion.js
 *
 * @author:  Yusuke Sugomori (http://yusugomori.com)
 * @license: http://yusugomori.com/license/mit
 * @version: 1.0.2
*/
(function(a){a.fn.extend({imotion:function(e){var b,d,f,c,h,g,j=this;if(e==null){e={}}c=a.fn.imotion;if(a.isArray(e)===true){e={imgs:e}}if(a.isArray(e.imgs)!==true){return}c.options=e;d=[];for(f=h=0,g=e.imgs.length;0<=g?h<g:h>g;f=0<=g?++h:--h){d.push(c.preload(e.imgs[f]))}b=$.Deferred();$.when.apply(null,d).done(function(){var i,k;if(e.dfd!=null){i=e.dfd}else{i=a.Deferred();i.resolve()}if(e.wait!=null){k=e.wait}else{k=0}return i.then(function(){var n,m,l;if(e.fps!=null){n=e.fps}else{n=20}if((e.skipFirst!=null)&&e.skipFirst===true){m=1}else{m=0}l=1000/n;return setTimeout(function(){return c.animate(j,c,l,m,e.imgs.length,b)},k)})}).fail(function(){return b.reject()});return b.promise()}});return a.extend(a.fn.imotion,{preload:function(d){var b,c;b=$.Deferred();c=document.createElement("img");c.src=d;c.addEventListener("load",function(){return b.resolve()},false);c.onerror=function(){return b.reject()};return b.promise()},animate:function(g,e,d,f,c,b){if(f>c){b.resolve()}return setTimeout(function(){g.attr("src",e.options.imgs[f]);return e.animate(g,e,d,f+1,c,b)},d)}})})(jQuery);