# jquery.imotion.js

A jQuery plugin for flashless animation using stop motion images.


   


## Example
http://yusugomori.com/s/motion



## Usage
**html**
```html
<script type="text/javascript" src="http://yusugomori.github.com/api/jquery/plugins/jquery.imotion.js"></script>
<img id="demo-img" />
```

**js**

```js
var imgs = [];  // Array for stop motion images
for(var i=0; i<100; i++) imgs.push("/path/to/images/"+i+".png"); // push images (example)

// minimal
$('#demo-img').imotion(imgs);


// with options
var dfd = $.Deferred();
$('body').on('click', function(){
  dfd.resolve();
});

$('#demo-img').imotion({
  imgs: imgs,
  dfd: dfd,
  fps: 20,
  wait: 1000,
  skipFirst: true
});


// chain actions
//   jquery.imotion.js returns $.Deferred() object ( .promise() ),
//   so you can chain actions with .then() or .fail() etc.
$('#demo-img').imotion(imgs).then(function(){
  /* triggered after animation */
}).fail(function(){
  /* triggered when animation fails */
});

```

## Options

+ **dfd** ( $.Deferred( ) object ):

 Activates animation when receiving dfd.resolve().

 Default is **null**, so animation starts soon after all images are pre-loaded.

+ **fps** ( Number ): 

 Controls how many frames (images) will be displayed per sec. 
 
 Default is **20**, so frame-refreshing time is 1000/20 = 50 msec.

 **Caution: increasing this number may degrade animation quality.**

+ **wait** ( Number ):

 Animation starts after this number (msec).

 Default is **0**. 

+ **skipFirst** ( Boolean ):

 Controls whether to include the first frame in animation.

 Default is **false**. You might want to set this value true when your \<img /\> tag has the initial frame,

 such as: \<img id="demo-img" src="0.png" /\>
 
