###
                   .ohhhs:`     -oyhhs-
                   dMMMNMMd:  `yNMNMMMN.
                   yMMd..oNN.dMy-.oMMN`
                  `-hMMds+mNhMs/oyNMd:
           ..-=:::+shmNMMmysMMhsmMMNmhs::=-.
       .,-`        `-ohNMMNmmMMMms+:.      ``.,
       |       :ydmmdhyo-...-:+shddmdhs`       `.
       |       oMMMd`             `-MMMM-       |
       |       oMMMd               `MMMM-       |
       |       oMMMd               `MMMM:       |
       |       oMMMd                MMMM:       |
       |       oMMMd                MMMM:       |
       |       oMMMd                NMMM/       |
       |       oMMMd                NMMM/       |
       |       oMMMd                mMMM/       |
       `+:.    oMMMd                mMMM+   .-:+`
          `.-==+hmNh                dmdh+==-.
                     -=-=::___::=-=-
###
class Placeholder
  constructor: (@input, @options) ->

    defaults = {
      placeholderCss:         'input-placeholder',
      placeholderFocusCss:    'focus',
      placeholderHiddenCss:   'with_value',
      wrapperCss:             'input-wrapper',
    }
    @options = $.extend {}, defaults, @options
    @_wrap()
    @_createPlaceholder()
    @_overrideDefVal()
    @hide() if @input.val().length

  hide: ->
    @placeholder.addClass(@options.placeholderHiddenCss)

  show: ->
    @placeholder.removeClass(@options.placeholderHiddenCss)

  focus: ->
    @placeholder.addClass(@options.placeholderFocusCss)
    if @input.val().length
      @hide()
    else
      @show()

  keyup: -> @focus()
    
  blur: ->
    @placeholder.removeClass(@options.placeholderFocusCss)
    @show() unless @input.val().length
    
  setNewContent: (content)->
    @placeholder.html(content)
    @input.data("placeholder", content)

# ============================================================PRIVATES==================================================
  ###
  @private
  ###
  _wrap: ->
    @wrapperDiv = $("<div class='#{@options.wrapperCss}'/>")
    @input.wrapAll(@wrapperDiv)
  ###
  @private
  ###
  _createPlaceholder: ->
    inputId = @input.attr("id") ? @_getRandomId()
    @input.attr("id",inputId)
    @_calculateMeasurements()
    @placeholder =
    $("<label class='#{@options.placeholderCss}' for='#{inputId}'>#{@input.attr("placeholder")}</label>")
    .css(
      top: @_topOffset(),
      left: @_leftOffset(),
      "line-height": @measurements.height,
      width: @measurements.width,
      height: @measurements.height)
    .click(->@focus())
    .insertBefore(@input)
    @_removeHtmlPlaceholder()

  ###
  @private
  ###
  _calculateMeasurements: ->
    @clone = @input.clone().insertBefore(@input).css(
      top: -99999
      left: -99999
      position: "absolute"
    ).show()

    @measurements or= {
      width: @clone.css("width")
      height: @clone.css("height")
      left: {
        padding:parseInt(@clone.css("padding-left").replace("px",''))
        border:parseInt(@clone.css("border-left-width").replace("px",''))
        margin:parseInt(@clone.css("margin-left").replace("px",''))
      }
      top: {
        padding:parseInt(@clone.css("padding-top").replace("px",''))
        border:parseInt(@clone.css("border-top-width").replace("px",''))
        margin:parseInt(@clone.css("margin-top").replace("px",''))
      }
    }
    @clone.remove()
    @measurements
    
  ###
  @private
  ###
  _getRandomId: ->
    id = ""
    id = "Placeholder_#{Math.floor(Math.random()*1000)}" while id.length == 0 || $("##{id}").length > 0
    id
  ###
  @private
  ###
  _removeHtmlPlaceholder: ->
    @input.data("placeholder",@input.attr("placeholder"))
    @input.attr("placeholder","")
  ###
  @private
  ###
  _leftOffset: ->
    left = @measurements.left
    left.padding + left.border + left.margin + 2
  ###
  @private
  ###
  _topOffset: ->
    top = @measurements.top
    top.padding + top.border + top.margin

  ###
  @private
  ###
  _overrideDefVal: ->
    return if $.fn.val == @_newVal
    $.fn.rVal = $.fn.val
    $.fn.val = @_newVal
  ###
  @private
  ###
  _newVal: (value) ->
    val = if value!=undefined then @rVal(value) else @rVal()
    @trigger('change') if @parent().hasClass('input-wrapper') and value!=undefined
    val


$.fn.placeholder = (options) ->
  initPlaceholder = (input)->
    placeholder = new Placeholder(input)
    input.data("placeholderInstance", placeholder)
    input
      .keyup(=>placeholder.keyup())
      .blur(=>placeholder.blur())
      .change(=>placeholder.keyup())
      .focus(=>placeholder.focus())

  newContent = options
  input = @[0]
  $input = @
  @.each ->
    input = $(@)
    if (newContent)
      input.data("placeholderInstance").setNewContent(newContent)
    else
      return input.data("placeholderInstance") if input.data("placeholderInstance")?.length #prevent double creation
      initPlaceholder(input)
