(function() {

  /*
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
  */

  var Placeholder;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Placeholder = (function() {

    function Placeholder(input, options) {
      var defaults;
      this.input = input;
      this.options = options;
      defaults = {
        placeholderCss: 'input-placeholder',
        placeholderFocusCss: 'focus',
        placeholderHiddenCss: 'with_value',
        wrapperCss: 'input-wrapper'
      };
      this.options = $.extend({}, defaults, this.options);
      this.input.keyup(__bind(function() {
        return this.checkContent();
      }, this)).blur(__bind(function() {
        return this.blur();
      }, this)).change(__bind(function() {
        return this.checkContent();
      }, this)).focus(__bind(function() {
        return this.focus();
      }, this));
      this.input.wrapAll($("<div class='" + this.options.wrapperCss + "'/>"));
      this._createPlaceholder();
      this._overrideDefVal();
      this.checkContent();
    }

    Placeholder.prototype.hide = function() {
      return this.placeholder.addClass(this.options.placeholderHiddenCss);
    };

    Placeholder.prototype.show = function() {
      return this.placeholder.removeClass(this.options.placeholderHiddenCss);
    };

    Placeholder.prototype.focus = function() {
      this.placeholder.addClass(this.options.placeholderFocusCss);
      return this.checkContent();
    };

    Placeholder.prototype.checkContent = function() {
      if (this.input.val().length) {
        return this.hide();
      } else {
        return this.show();
      }
    };

    Placeholder.prototype.blur = function() {
      this.placeholder.removeClass(this.options.placeholderFocusCss);
      return this.checkContent();
    };

    Placeholder.prototype.setNewContent = function(content) {
      this.placeholder.html(content);
      return this.input.data("placeholder", content);
    };

    /*
      #@private
    */

    Placeholder.prototype._createPlaceholder = function() {
      var inputId, _ref;
      inputId = (_ref = this.input.attr("id")) != null ? _ref : _.uniqueId('Placeholder_');
      this.input.attr("id", inputId);
      this._calculateMeasurements();
      this.placeholder = $("<label class='" + this.options.placeholderCss + "' for='" + inputId + "'>" + (this.input.attr("placeholder")) + "</label>").css({
        top: this._topOffset() + 'px',
        left: this._leftOffset() + 'px',
        "line-height": this.measurements.height + 'px',
        width: this.measurements.width + 'px',
        height: this.measurements.height + 'px'
      }).click(__bind(function() {
        this.focus();
        return $(this.input).focus();
      }, this)).insertBefore(this.input);
      return this._removeHtmlPlaceholder();
    };

    /*
      #@private
    */

    Placeholder.prototype._calculateMeasurements = function() {
      this.clone = this.input.clone().insertBefore(this.input).css({
        top: -99999,
        left: -99999,
        position: "absolute"
      }).show();
      this.measurements || (this.measurements = {
        width: this.clone.css("width").replace('px', ''),
        height: this.clone.css("height").replace('px', ''),
        left: {
          padding: parseInt(this.clone.css("padding-left").replace("px", '')),
          border: parseInt(this.clone.css("border-left-width").replace("px", '')),
          margin: parseInt(this.clone.css("margin-left").replace("px", ''))
        },
        top: {
          padding: parseInt(this.clone.css("padding-top").replace("px", '')),
          border: parseInt(this.clone.css("border-top-width").replace("px", '')),
          margin: parseInt(this.clone.css("margin-top").replace("px", ''))
        }
      });
      this.clone.remove();
      return this.measurements;
    };

    /*
      #@private
    */

    Placeholder.prototype._removeHtmlPlaceholder = function() {
      this.input.data("placeholder", this.input.attr("placeholder"));
      this.input.attr("placeholder", "");
      return this.input.attr("autocomplete", "off");
    };

    /*
      #@private
    */

    Placeholder.prototype._leftOffset = function() {
      var left;
      left = this.measurements.left;
      return left.padding + left.border + left.margin + 2;
    };

    /*
      #@private
    */

    Placeholder.prototype._topOffset = function() {
      var top;
      top = this.measurements.top;
      return top.padding + top.border + top.margin;
    };

    /*
      #@private
    */

    Placeholder.prototype._overrideDefVal = function() {
      if ($.fn.val === this._newVal) return;
      $.fn.rVal = $.fn.val;
      return $.fn.val = this._newVal;
    };

    /*
      #@private
    */

    Placeholder.prototype._newVal = function(value) {
      var val;
      val = value !== void 0 ? this.rVal(value) : this.rVal();
      if (this.parent().hasClass('input-wrapper') && value !== void 0) {
        this.trigger('change');
      }
      return val;
    };

    return Placeholder;

  })();

  $.fn.placeholder = function(options) {
    var $input, initPlaceholder, input, newContent;
    initPlaceholder = function(input) {
      var placeholder;
      placeholder = new Placeholder(input);
      return input.data("placeholderInstance", placeholder);
    };
    newContent = options;
    input = this[0];
    $input = this;
    return this.each(function() {
      var _ref;
      input = $(this);
      if (newContent) {
        return input.data("placeholderInstance").setNewContent(newContent);
      } else {
        if ((_ref = input.data("placeholderInstance")) != null ? _ref.length : void 0) {
          return input.data("placeholderInstance");
        }
        return initPlaceholder(input);
      }
    });
  };

}).call(this);
