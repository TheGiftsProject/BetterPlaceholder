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
    # binding events
    @input
      .keyup(=>@checkContent())
      .blur(=>@blur())
      .change(=>@checkContent())
      .focus(=>@focus())

    @input.wrapAll($("<div class='#{@options.wrapperCss}'/>"))
    @_createPlaceholder()
    @_overrideDefVal()
    @checkContent()

  hide: ->
    @placeholder.addClass(@options.placeholderHiddenCss)

  show: ->
    @placeholder.removeClass(@options.placeholderHiddenCss)

  focus: ->
    @placeholder.addClass(@options.placeholderFocusCss)
    @checkContent()

  checkContent: ->
    if @input.val().length
      @hide()
    else
      @show()

  blur: ->
    @placeholder.removeClass(@options.placeholderFocusCss)
    @checkContent()

  setNewContent: (content)->
    @placeholder.html(content)
    @input.data("placeholder", content)

# ============================================================PRIVATES==================================================
  ###
  #@private
  ###
  _createPlaceholder: ->
    inputId = @input.attr("id") ? _.uniqueId('Placeholder_')
    @input.attr("id",inputId)
    @_calculateMeasurements()
    @placeholder = $("<label class='#{@options.placeholderCss}' for='#{inputId}'>#{@input.attr("placeholder")}</label>")
    .css(
      top: @_topOffset()+'px',
      left: @_leftOffset() + 'px',
      "line-height": @measurements.height + 'px',
      width: @measurements.width + 'px',
      height: @measurements.height + 'px'
    )
    .click(=>
      @focus()
      $(@input).focus()
    )
    .insertBefore(@input)
    @_removeHtmlPlaceholder()

  ###
  #@private
  ###
  _calculateMeasurements: ->
    @clone = @input.clone().insertBefore(@input).css(
      top: -99999
      left: -99999
      position: "absolute"
    ).show()

    @measurements or= {
      width: @clone.css("width").replace('px','')
      height: @clone.css("height").replace('px','')
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
  #@private
  ###
  _removeHtmlPlaceholder: ->
    @input.data("placeholder", @input.attr("placeholder"))
    @input.attr("placeholder", "")
    @input.attr("autocomplete", "off")
  ###
  #@private
  ###
  _leftOffset: ->
    left = @measurements.left
    left.padding + left.border + left.margin + 2
  ###
  #@private
  ###
  _topOffset: ->
    top = @measurements.top
    top.padding + top.border + top.margin

  ###
  #@private
  ###
  _overrideDefVal: ->
    return if $.fn.val == @_newVal
    $.fn.rVal = $.fn.val
    $.fn.val = @_newVal
  ###
  #@private
  ###
  _newVal: (value) ->
    val = if value!=undefined then @rVal(value) else @rVal()
    @trigger('change') if @parent().hasClass('input-wrapper') and value!=undefined
    val


$.fn.placeholder = (options) ->
  initPlaceholder = (input)->
    placeholder = new Placeholder(input)
    input.data("placeholderInstance", placeholder)

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
