###!
 * jquery.pinterest.js - placing your images with Pinterest look
 *
 * @version  1.0.0
 * @author   yusugomori
 * @license  http://yusugomori.com/license/mit The MIT License
 *
 * More details on github: https://github.com/yusugomori/jQueryPinterest
 ###

class jQueryPinterest
  constructor: (options={}) ->
    @pinHolderId = '#jQueryPinHolder'
    @pinHolderWidth = 940
    @pinHolderToggle = true
    @pinWidth = 192
    @pinPadding = 15
    @pinMargin = 15

    @pinHolderId = options.pinHolderId if options.pinHolderId?
    @pinHolderWidth = options.pinHolderWidth if options.pinHolderWidth?
    @pinHolderToggle = options.pinHolderToggle if options.pinHolderToggle?
    @pinWidth = options.pinWidth if options.pinWidth?
    @pinPadding = options.pinPadding if options.pinPadding?
    @pinMargin = options.pinMargin if options.pinMargin?

    @pins = "#{@pinHolderId} .pin"

    # initial css settings
    $(@pinHolderId).css
      visibility: 'hidden'    # hide pins before calculating respective position
      position: 'relative'
      'margin-left': 'auto'
      'margin-right': 'auto'
      'min-width': @pinHolderWidth

    $(@pins).css
      position: 'absolute'
      width: @pinWidth
      padding: @pinPadding
      background: '#fff'
      '-webkit-box-shadow': '0 1px 3px rgba(34,25,25,0.4)'
      '-moz-box-shadow': '0 1px 2px rgba(34,25,25,0.4)'
      'box-shadow': '0 1px 3px rgba(34,25,25,0.4)'


    $('body').imagesLoaded =>
      @main()

    $(window).bind "resize", =>
      @main()

  main: () ->
    @clientWidth = @getClientWidth()
    @pinNum = @getPinNum()

    rowNum = @getRowNum()
    globalHeight = new Array(rowNum)
    for i in [0...rowNum]
      globalHeight[i] = 0
    localHeight = []
    localPins = []

    self = @
    n = 0
    $(@pins).each ->
      r = n % rowNum
      if r is 0
        localHeight = []
        localPins = []

      self.storePinData(@, localHeight, localPins)

      n++

      if (r is rowNum-1) or (n is self.pinNum and r isnt rowNum-1)
        unless n is rowNum
          obj = self.sortPins(globalHeight, localHeight)
        else
          obj = self._sortPins(globalHeight, localHeight)  # for first line

        self.setPins(globalHeight, localHeight, localPins, obj)

    $(@pinHolderId).css
      visibility: 'visible'
      width: rowNum*(@pinWidth+2*@pinPadding) + (rowNum-1)*@pinMargin
      height: Math.max.apply(null, globalHeight)

  storePinData: (el, localHeight, localPins) ->
    img = $(el).find('img')
    if img.length > 1
      img = img[0]
    _imgWidth = $(img).width()
    imgHeight = $(img).height() * @pinWidth / _imgWidth
    $(img).css
      width: @pinWidth
      height: Math.floor(imgHeight)
      display: 'block'

    localHeight.push $(el).outerHeight()
    localPins.push el

    @

  setPins: (globalHeight, _localHeight, _localPins, obj) ->
    localPins = _localPins.concat()
    localHeight = _localHeight.concat()

    for i in [0...localHeight.length]
      sortO = obj.sortedLocalHeightOrder[i]
      asortO = obj.asortedGlobalHeightOrder[i]

      $(localPins[sortO]).css
        top: globalHeight[asortO] + @pinMargin
        left: asortO * (@pinWidth + 2*@pinPadding + @pinMargin)
      globalHeight[asortO] += localHeight[sortO] + @pinMargin

    @

  _sortPins: (globalHeight, _localHeight) ->
    localHeight = _localHeight.concat()
    sortedLocalHeightOrder = new Array(localHeight.length)
    asortedGlobalHeightOrder = new Array(globalHeight.length)

    for i in [0...localHeight.length]
      sortedLocalHeightOrder[i] = i
    for i in [0...globalHeight.length]
      asortedGlobalHeightOrder[i] = i
    return {
      sortedLocalHeightOrder: sortedLocalHeightOrder,
      asortedGlobalHeightOrder: asortedGlobalHeightOrder
    }

  sortPins: (globalHeight, _localHeight) ->
    localHeight = _localHeight.concat()

    sortedLocalHeight = localHeight.concat().sort(@arraySort)
    asortedGlobalHeight = globalHeight.concat().sort(@arraySort).reverse()

    sortedLocalHeightOrder = new Array(localHeight.length)
    asortedGlobalHeightOrder = new Array(globalHeight.length)

    for i in [0...localHeight.length]
      for j in [0...localHeight.length]
        if sortedLocalHeight[i] is localHeight[j] and sortedLocalHeightOrder.indexOf(j) is -1
          sortedLocalHeightOrder[i] = j
          break

    for i in [0...globalHeight.length]
      for j in [0...globalHeight.length]
        if asortedGlobalHeight[i] is globalHeight[j] and asortedGlobalHeightOrder.indexOf(j) is -1
          asortedGlobalHeightOrder[i] = j

          break

    return {
      sortedLocalHeightOrder: sortedLocalHeightOrder,
      asortedGlobalHeightOrder: asortedGlobalHeightOrder
    }

  getClientWidth: () ->
    if @pinHolderToggle is true
      clientWidth = document.documentElement.clientWidth
      unless clientWidth > @pinHolderWidth
        clientWidth = @pinHolderWidth
    else
      clientWidth = @pinHolderWidth

    return clientWidth

  getRowNum: () ->
    r = 0
    clientWidth = @clientWidth
    pinOuterWidth = @pinWidth + 2*@pinPadding
    pinMargin = @pinMargin

    while clientWidth >= pinOuterWidth
      clientWidth -= pinOuterWidth
      r++
      if clientWidth >= pinMargin
        clientWidth -= pinMargin

    return r

  getPinNum: () ->
    r = 0
    $(@pins).each ->
      r++
    return r

  arraySort: (a, b) ->
    return (b-a)

# $ ->
#   new jQueryPinterest()
