###!
 * jFBMobileFeedPhoto.js
 *
 * @version  1.0.2
 * @author   Yusuke Sugomori
 * @license  http://yusugomori.com/license/mit The MIT License
 *
 * More details on github: https://github.com/yusugomori/jFBMobileFeedPhoto
 ###

class jFBMobileFeedPhoto
  constructor: (options={}) ->
    # @iphoneHack()

    @scrollTop = 0

    @placeHolderId = '#jFBMobileFeedPhoto'
    @margin = 20
    @imageMargin = 7
    @images = []

    @placeHolderId = options.id if options.id?
    @$placeHolder = $(@placeHolderId)

    @overlayPlaceHolderId = @placeHolderId + 'Overlay'
    @overlayImageMargin = 20
    @overlayCloseText = 'Done'
    @overlayCloseTextPos = 15
    @isOverlayShown = false

    @isOriented = false

    @onTouchThres = 10
    @onTouchCurrent = {x: 0, y: 0}
    @onTouchStart = {x: 0, y: 0}
    @onTouchDrag = {x: 0, y: 0}
    @onTouchImageFlg = false
    @currentImgNum = null
    @targetImg = null

    @onTouchCurrentOverlay = {x: 0, y: 0}
    @onTouchStartOverlay = {x: 0, y: 0}
    @onTouchDragOverlay = {x: 0, y: 0}
    @currentImgNumOverlay = null


    $('body').append "<div id=\"#{@overlayPlaceHolderId.substring(1)}\"></div>"
    @$overlayPlaceHolder = $(@overlayPlaceHolderId)

    @$placeHolder.hide()
    @$overlayPlaceHolder.hide()

    @setImageArray()
    @$placeHolder.empty()

    if options.margin?
      @margin = options.margin
    unless options.margin? or @images.length isnt 1
      @margin = 5

    @winWidth = $(window).width()
    @winHeight = 0
    @placeImage()
    @placeOverlay()

    @setStaticCss()
    @setStaticOverlayCss()

    @main()

    # Bind event for orientationchange
    @orientationchange()

  main: () ->
    @setCss()
    @$placeHolder.show()

    if @images.length > 1
      @onTouch(true)
    else
      @onTouch(false)

    return

  onTouch: (flg = true) ->
    @touchstart()
    @touchmove(flg)
    @touchend(flg)
    return

  touchstart: () ->
    @$placeHolder.on 'touchstart', (e) =>
      if event.touches[1]?
        e.preventDefault()
        return

      @targetImg = e.target
      touch = event.touches[0]

      @onTouchCurrent = @getTranslate(@$placeHolder)
      @onTouchStart = {x: touch.pageX, y: touch.pageY}
      @onTouchDrag = {x: touch.pageX, y: touch.pageY}

      if @targetImg.tagName? and @targetImg.tagName.toLowerCase().match(/img/)
        @onTouchImageFlg = true

    return

  touchmove: (flg = true) ->
    @$placeHolder.on 'touchmove', (e) =>
      if event.touches[1]?
        e.preventDefault()
        return

      touch = event.touches[0]
      @onTouchDrag = {x: touch.pageX, y: touch.pageY}

      return unless flg

      _dX = Math.abs @onTouchStart.x - @onTouchDrag.x
      _dY = Math.abs @onTouchStart.y - @onTouchDrag.y

      # Detect slide or scroll
      if _dX >= _dY
        e.preventDefault()
        @slideImage()

    return

  touchend: (flg = true) ->
    @$placeHolder.on 'touchend', (e) =>
      if event.touches[1]?
        e.preventDefault()
        return

      if @onTouchImageFlg
        @onTouchImageFlg = false

        _dX = Math.abs @onTouchStart.x - @onTouchDrag.x
        _dY = Math.abs @onTouchStart.y - @onTouchDrag.y

        if _dX < @onTouchThres and _dY < @onTouchThres
          @showOverlay()
          return

      unless flg
        return

      @slideImageFix()

    return


  onTouchOverlay: (flg = true) ->
    @touchstartOverlay()
    @touchmoveOverlay(flg)
    @touchendOverlay(flg)
    return

  touchstartOverlay: () ->
    @$overlayPlaceHolder.on 'touchstart', (e) =>
      if event.touches[1]?
        e.preventDefault()
        return

      touch = event.touches[0]
      @onTouchCurrentOverlay = @getTranslate(@$overlayPlaceHolder.children().eq(0))

      @onTouchStartOverlay = {x: touch.pageX, y: touch.pageY}
      @onTouchDragOverlay = {x: touch.pageX, y: touch.pageY}

    return

  touchmoveOverlay: (flg = true) ->
    @$overlayPlaceHolder.on 'touchmove', (e) =>
      e.preventDefault()

      return if event.touches[1]?

      touch = event.touches[0]
      @onTouchDragOverlay = {x: touch.pageX, y: touch.pageY}

      return unless flg

      @slideImageOverlay()

    return

  touchendOverlay: (flg = true) ->
    @$overlayPlaceHolder.on 'touchend', (e) =>
      if event.touches[1]?
        e.preventDefault()
        return
      unless flg
        return

      @slideImageFixOverlay()

    return

  showOverlay: () ->
    @setScrollTop()
    @$overlayPlaceHolder.css
      visibility: 'hidden'
    @$overlayPlaceHolder.show()

    @setOverlayCss()
    $('html,body').height @winHeight

    @$overlayPlaceHolder.css
      visibility: 'visible'

    @isOverlayShown = true

    # Bind touch
    if @images.length > 1
      @onTouchOverlay(true)
    else
      @onTouchOverlay(false)

    # Bind click
    @$overlayPlaceHolder.children().eq(1).on 'click', (e) =>
      @hideOverlay()

    # Bind scroll
    $(window).on 'scroll', (e) =>
      unless @isOriented
        @hideOverlay()
      @isOriented = false

    return

  hideOverlay: () ->
    $('html,body').css
      height: 'auto'
    @$overlayPlaceHolder.off 'touchstart'
    @$overlayPlaceHolder.off 'touchmove'
    @$overlayPlaceHolder.off 'touchend'
    @$overlayPlaceHolder.children().eq(1).off 'click'
    @$overlayPlaceHolder.hide()
    @isOverlayShown = false
    $(window).off 'scroll'
    scrollTo(0, @scrollTop)

    return

  slideImage: () ->
    dx = @onTouchDrag.x - @onTouchStart.x
    x = @onTouchCurrent.x + dx
    w = @winWidth - 2 * @margin

    if x > 0
      x = 0
    if x < -1 * (@images.length - 1) * (w + @imageMargin)
      x = -1 * (@images.length - 1) * (w + @imageMargin)


    @$placeHolder.css
      '-webkit-transition-duration': '0ms'
      '-webkit-transform': "translate3d(#{x}px, 0px, 0px)"

    return

  slideImageFix: (flg = false) ->
    w = @winWidth - 2 * @margin

    if flg and @currentImgNum?
      thres = @currentImgNum
    else
      dx = @onTouchDrag.x - @onTouchStart.x
      x = @onTouchCurrent.x + dx
      thres = Math.abs(x - w / 2 - @imageMargin)

    if thres < 0
      x = 0
      @currentImgNum = 0
    else
      unless flg and @currentImgNum?
        thres = parseInt(thres / (w + @imageMargin))

      if thres >= @images.length
        x = -1 * (@images.length - 1) * (w + @imageMargin)
      else
        x = -1 * thres * (w + @imageMargin)

      @currentImgNum = thres


    @$placeHolder.css
      '-webkit-transition-duration': '150ms'
      '-webkit-transform': "translate3d(#{x}px, 0px, 0px)"

    return


  slideImageOverlay: () ->
    dx = @onTouchDragOverlay.x - @onTouchStartOverlay.x
    x = @onTouchCurrentOverlay.x + dx

    if x > 0
      x = 0
    if x < -1 * (@images.length - 1) * (@winWidth + @overlayImageMargin)
      x = -1 * (@images.length - 1) * (@winWidth + @overlayImageMargin)


    @$overlayPlaceHolder.children().eq(0).css
      '-webkit-transform': "translate3d(#{x}px, 0px, 0px)"

    return

  slideImageFixOverlay: (flg = false) ->
    w = @winWidth

    if flg and @currentImgNumOverlay?
      thres = @currentImgNumOverlay
    else
      dx = @onTouchDragOverlay.x - @onTouchStartOverlay.x
      x = @onTouchCurrentOverlay.x + dx
      thres = Math.abs(x - w / 2 - @overlayImageMargin)

    if thres < 0
      x = 0
      @currentImgNumOverlay = 0
    else
      unless flg and @currentImgNumOverlay?
        thres = parseInt(thres / (w + @overlayImageMargin))

      if thres >= @images.length
        x = -1 * (@images.length - 1) * (w + @overlayImageMargin)
      else
        x = -1 * thres * (w + @overlayImageMargin)

      @currentImgNumOverlay = thres

    if flg
      ms = '0ms'
    else if @winWidth > @winHeight
      ms = '300ms'
    else
      ms = '150ms'
    @$overlayPlaceHolder.children().eq(0).css
      '-webkit-transition-duration': ms
      '-webkit-transform': "translate3d(#{x}px, 0px, 0px)"

    return

  setStaticCss: () ->
    $('html, body').css
      overflow: 'hidden'
      height: 'auto'

    @$placeHolder.css
      position: 'relative'
      margin: '0 auto'
      '-webkit-transform': 'translate3d(0px, 0px, 0px)'
      '-webkit-transition-property': '-webkit-transform'
      '-webkit-transform-style': 'preserve-3d'
      '-webkit-transition-timing-function': 'ease-in-out'
      '-webkit-transition-duration': '0ms'

    # wrapper
    @$placeHolder.children().css
      position: 'absolute'
      top: 0

    # image container
    @$placeHolder.children().children().css
      position: 'relative'
      overflow: 'hidden'
      '-webkit-box-shadow': '0 1px 2px #888'
      'box-shadow': '0 1px 2px #888'

    @$placeHolder.children().children().find('img').css
      'max-width': '100%'
      'height': 'auto'
      border: 0
      display: 'block'
      position: 'absolute'
      top: 0
      left: 0

    return

  setStaticOverlayCss: () ->
    @$overlayPlaceHolder.css
      overflow: 'hidden'
      'z-index': 9999
      # position: 'absolute'
      position: 'fixed'
      top: 0
      left: 0
      background: '#000'

    @$overlayPlaceHolder.children().eq(0).css
      '-webkit-transform': 'translate3d(0px, 0px, 0px)'
      '-webkit-transition-property': '-webkit-transform'
      '-webkit-transform-style': 'preserve-3d'
      '-webkit-transition-timing-function': 'ease-in-out'
      '-webkit-transition-duration': '0ms'

    # close
    @$overlayPlaceHolder.children().eq(1).css
      'z-index': 10000
      position: 'absolute'
      top: @overlayCloseTextPos
      right: @overlayCloseTextPos
      background: 'rgba(0,0,0,0.5)'
      color: '#ddd'
      padding: '3px 10px'
      border: 'solid 2px #ddd'
      'border-radius': '3px'
      'font-size': '11px'
      'font-weight': 'bold'

    # wrapper
    @$overlayPlaceHolder.children().eq(0).children().css
      position: 'absolute'
      top: 0

    # image container
    @$overlayPlaceHolder.children().eq(0).children().children().css
      position: 'relative'
      overflow: 'hidden'

    @$overlayPlaceHolder.children().eq(0).children().children().find('img').css
      border: 0
      display: 'block'
      position: 'absolute'


    # comment
    @$overlayPlaceHolder.children().eq(0).children().children().children('div').css
      position: 'absolute'
      bottom: 0
      left: 0
      color: '#fff'
      background: 'rgba(0,0,0,0.3)'
      padding: '20px'
      'font-size': '14px'
      'letter-spacing': '1px'
      '-webkit-box-sizing': 'border-box'
      'box-sizing': 'border-box'

    return

  setCss: () ->
    @setWinHeight()

    placeHolderLeft = 0

    size = @winWidth - 2 * @margin
    containerHeight = size

    # if containerHeight > @winHeight
    #   containerHeight = @winHeight

    parentWidth = @$placeHolder.parent().width()

    if parentWidth < size
      placeHolderLeft = (parentWidth - size) /2

    @$placeHolder.css
      height: size
      width: size
      left: placeHolderLeft

    # wrapper
    for i in [0...@images.length]
      _left = i * (size + @imageMargin)

      @$placeHolder.children().eq(i).css
        left: _left

    # image container
    @$placeHolder.children().children().css
      height: containerHeight
      width: size

    @$placeHolder.children().children().find('img').css
      'min-width': size
      'min-height': size

    return


  setOverlayCss: () ->
    imageNum = $(@targetImg).attr 'data-image-number'
    transX = -1 * imageNum * (@winWidth + @overlayImageMargin)

    @setWinHeight()

    @$overlayPlaceHolder.css
      height: @winHeight + 5  # bug fix
      width: @winWidth

    @$overlayPlaceHolder.children().eq(0).css
      '-webkit-transform': "translate3d(#{transX}px, 0px, 0px)"

    # wrapper and image
    for i in [0...@images.length]
      _left = i * (@winWidth + @overlayImageMargin)

      @$overlayPlaceHolder.children().eq(0).children().eq(i).css
        left: _left

      _img = @$overlayPlaceHolder.children().eq(0).children().eq(i).children().find('img')
      _$img = $(_img)

      _src = _$img.attr 'src'

      _tmpImg = new Image()
      _tmpImg.src = _src

      _w = _tmpImg.width
      _h = _tmpImg.height

      _width = _w
      _height = _h

      if _w > @winWidth
        _width = @winWidth
        _h = _h * @winWidth / _w
        _height = _h

      if _h > @winHeight
        _height = @winHeight
        _width = _width * @winHeight / _h

      _t = (@winHeight - _height) / 2
      _l = (@winWidth - _width) / 2

      _$img.css
        top: _t
        left: _l
        height: _height
        width: _width

    # image container
    @$overlayPlaceHolder.children().eq(0).children().children().css
      height: @winHeight
      width: @winWidth

    @$overlayPlaceHolder.children().eq(0).children().children().children('div').css
      width: @winWidth

    return

  placeImage: () ->
    for i in [0...@images.length]
      _html = '<div><div>'
      _html += "<img src=\"#{@images[i].img}\" data-image-number=\"#{i}\" />"

      # if @images[i].div?
      #   _html += "<div>#{@images[i].div}</div>"

      _html += '</div></div>'

      @$placeHolder.append _html

    return

  placeOverlay: () ->
    @$overlayPlaceHolder.append '<div></div>'
    @$overlayPlaceHolder.append "<div>#{@overlayCloseText}</div>"

    for i in [0...@images.length]
      _html = '<div><div>'
      _html += "<img src=\"#{@images[i].img}\" data-image-number=\"#{i}\" />"

      if @images[i].div?
        _html += "<div>#{@images[i].div}</div>"

      _html += '</div></div>'

      @$overlayPlaceHolder.children().eq(0).append _html

    return

  setImageArray: () ->
    self = @
    @$placeHolder.children('div').each () ->
      $_img = $(@).children('img')
      $_div = $(@).children('div')

      _hash = {
        img: $_img.attr('src')
      }

      if $_div.length > 0
        _hash.div = $_div.html()

      self.images.push _hash

    return


  getTranslate: (elem) ->
    m = new WebKitCSSMatrix($(elem).css('-webkit-transform'))
    return { x: parseInt(m.e, 10), y: parseInt(m.f, 10) }


  setWinHeight: () ->
    if window.innerHeight?
      @winHeight = window.innerHeight
    else
      @winHeight = $(window).height()

    return


  setScrollTop: () ->
    @scrollTop = $(window).scrollTop()
    return

  iphoneHack: () ->
    setTimeout(scrollTo, 120, 0, 1)
    return

  orientationchange: () ->
    $(window).on 'orientationchange', () =>
      @$placeHolder.hide()
      @winWidth = $(window).width()
      @slideImageFix(true)
      @main()

      if @isOverlayShown
        @isOriented = true
        @setOverlayCss()
        @slideImageFixOverlay(true)
    return
