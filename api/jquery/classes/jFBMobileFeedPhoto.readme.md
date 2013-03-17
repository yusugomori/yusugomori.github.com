# jFBMobileFeedPhoto

https://github.com/yusugomori/jFBMobileFeedPhoto

jFBMobileFeedPhoto.js is a jQuery plugin, making your images in html code look and act like photos on News Feed in Facebook iPhone App with simple html codes. *1

*1 More specifically, jFBMobileFeedPhoto is "class" in CoffeeScript (or "var" in JavaScript) .


## Example
http://yusugomori.com/s/facebook

Try access with Mobile Webkit browser.
More examples in ./example directory.



## Usage
**HTML**
```html
<!-- More than one photo -->
<div id="jFBMobileFeedPhoto">
  <div>
    <img alt="" src="./img/1.jpg" />
    <div>Sample comment</div>
  </div>
  
  <div>
    <img alt="" src="./img/2.jpg" />
    <div>日本語サンプルコメント<br />(Sample comment in Japanese)</div>
  </div>

  <div>
    <img alt="" src="./img/3.jpg" />
    <!-- No comment -->
  </div>
</div>
```

**JavaScript**
```js
$(function(){
  new jFBMobileFeedPhoto();
})
```



The html code above will be replaced like below with jFBMobileFeedPhoto.js
```html
<div id="jFBMobileFeedPhoto">
  <div>
    <div>
      <img alt="" src="./img/1.jpg" />
    </div>
  </div>

  <div>
    <div>
      <img alt="" src="./img/2.jpg" />
    </div>
  </div>

  <div>
    <div>
      <img alt="" src="./img/3.jpg" />
    </div>
  </div>
</div>

<div id="jFBMobileFeedPhotoOverlay">
  <div>
    <div>
      <div>
        <img alt="" src="./img/1.jpg" />
        <div>Sample comment</div>
      </div>
      
      <div>
        <img alt="" src="./img/2.jpg" />
        <div>日本語サンプルコメント<br />(Sample comment in Japanese)</div>
      </div>
      
      <div>
        <img alt="" src="./img/3.jpg" />
      </div>      
      
    </div>
  </div>

  <div>Done</div>
</div>
```

jFBMobileFeedPhoto will contaminate ID of #jFBMobileFeedPhoto (and #jFBMobileFeedPhotoOverlay).
You can change this ID by specifying option like below.

```js
$(function(){
  new jFBMobileFeedPhoto({id: '#whicheverYouWant'});
})
```

Also see examples for more details.


## Requirements
jFBMobileFeedPhoto uses **position: fixed;**, so it requires iOS 5 >=.