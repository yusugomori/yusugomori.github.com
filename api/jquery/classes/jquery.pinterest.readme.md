
# jQueryPinterest

https://github.com/yusugomori/jQueryPinterest

A jQuery plugin placing your images with Pinterest look.

## Requirements

**jQuery imagesLoaded plugin**

https://github.com/desandro/imagesloaded

https://github.com/desandro/imagesloaded/blob/master/jquery.imagesloaded.js


## Basic usage
HTML
```html
<!-- Wrap all html codes in #jQueryPinHolder. You can change this ID by specifying option. --> 
<div id="jQueryPinHolder">
  <!-- Place your images in .pin like below -->
  <div class="pin">
    <img alt="240x320" src="http://placehold.it/240x320" />
    <div class="anyNameYouWant">
      You can set html elements here.
    </div>
  </div>
  <div class="pin">
    <img alt="200x300" src="http://placehold.it/200x300" />
  </div>
  <div class="pin">
    <img alt="400x220" src="http://placehold.it/400x220" />
  </div>
  <div class="pin">
    <img alt="200x160" src="http://placehold.it/200x160" />
  </div>
  <div class="pin">
    <img alt="240x480" src="http://placehold.it/240x480" />
  </div>
  <div class="pin">
    <img alt="320x320" src="http://placehold.it/320x320" />
  </div>
  <div class="pin">
    <img alt="280x480" src="http://placehold.it/280x480" />
  </div>
  <div class="pin">
    <img alt="240x320" src="http://placehold.it/240x320" />
  </div>
  <div class="pin">
    <img alt="200x300" src="http://placehold.it/200x300" />
  </div>
  <div class="pin">
    <img alt="400x220" src="http://placehold.it/400x220" />
  </div>
  <div class="pin">
    <img alt="200x160" src="http://placehold.it/200x160" />
  </div>
  <div class="pin">
    <img alt="240x480" src="http://placehold.it/240x480" />
  </div>
  <div class="pin">
    <img alt="320x320" src="http://placehold.it/320x320" />
  </div>
  <div class="pin">
    <img alt="280x480" src="http://placehold.it/280x480" />
  </div>
</div>
```

JS
```js
$(function(){
  new jQueryPinterest()
});
```

## Example
http://yusugomori.com/s/pinterest


## Options
+ pinHolderId: Name of jQueryPinterest wrapper <div> id. Default is #jQueryPinHolder
+ pinHolderWidth: min-width of wrapper. If you set pinHolderToggle = false, this will be a fixed width. Default is 940
+ pinHolderToggle: Set true to correspond to window size (just like Pinterest). Default is true 
+ pinWidth: Set each pin's width. Pin's outerWidth will be pinWidth + 2 * pinPadding. Default is 192
+ pinPadding: Set pin's padding. Default is 15
+ pinMargin: Set pin's margin. Default is 15

### Example
```js
  new jQueryPinterest({
    pinHolderWidth: 1000,
    pinHolderToggle: false,
    pinWidth: 200
  })
```

