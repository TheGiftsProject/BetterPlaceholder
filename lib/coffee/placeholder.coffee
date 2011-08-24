###


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
    
    @placeholder =
    $("<label class='#{@options.placeholderCss}' for='#{inputId}'>#{@input.attr("placeholder")}</label>")
    .css(
      top: @_topOffset(),
      left: @_leftOffset(),
      "line-height": @input.css("height"),
      width: @input.css("width"),
      height: @input.css("height"))
    .click(->@focus())
    .insertBefore(@input)
    @_removeHtmlPlaceholder()

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
    @input.position().left+
    parseInt(@input.css("padding-left").replace("px",''))+
    parseInt(@input.css("border-left-width").replace("px",''))+
    parseInt(@input.css("margin-left").replace("px",''))+2
  ###
  @private
  ###
  _topOffset: ->
    @input.position().top+
    parseInt(@input.css("padding-top").replace("px",''))+
    parseInt(@input.css("border-top-width").replace("px",''))+
    parseInt(@input.css("margin-top").replace("px",''))

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
  input = @[0]
  $input = @
  @.each ->
    input = $(@)
    return input.data("placeholderInstance") if input.data("placeholder")?.length #prevent double creation
    placeholder = new Placeholder(input)
    input.data("placeholderInstance", placeholder)
    input.keyup(=>placeholder.keyup()).blur(=>placeholder.blur()).change(=>placeholder.keyup()).focus(=>placeholder.focus())
