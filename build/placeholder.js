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
      this._wrap();
      this._createPlaceholder();
      this._overrideDefVal();
      if (this.input.val().length) {
        this.hide();
      }
    }
    Placeholder.prototype.hide = function() {
      return this.placeholder.addClass(this.options.placeholderHiddenCss);
    };
    Placeholder.prototype.show = function() {
      return this.placeholder.removeClass(this.options.placeholderHiddenCss);
    };
    Placeholder.prototype.focus = function() {
      this.placeholder.addClass(this.options.placeholderFocusCss);
      if (this.input.val().length) {
        return this.hide();
      } else {
        return this.show();
      }
    };
    Placeholder.prototype.resize = function() {
      return this.placeholder.css({
        width: this.input.css("width"),
        height: this.input.css("height")
      });
    };
    Placeholder.prototype.keyup = function() {
      return this.focus();
    };
    Placeholder.prototype.blur = function() {
      this.placeholder.removeClass(this.options.placeholderFocusCss);
      if (!this.input.val().length) {
        return this.show();
      }
    };
    /*
      @private
      */
    Placeholder.prototype._wrap = function() {
      this.wrapperDiv = $("<div class='" + this.options.wrapperCss + "'/>");
      return this.input.wrapAll(this.wrapperDiv);
    };
    /*
      @private
      */
    Placeholder.prototype._createPlaceholder = function() {
      var inputId, _ref;
      inputId = (_ref = this.input.attr("id")) != null ? _ref : this._getRandomId();
      this.input.attr("id", inputId);
      this.placeholder = $("<label class='" + this.options.placeholderCss + "' for='" + inputId + "'>" + (this.input.attr("placeholder")) + "</label>").css({
        top: this._topOffset(),
        left: this._leftOffset(),
        "line-height": this.input.css("height"),
        width: this.input.css("width"),
        height: this.input.css("height")
      }).click(function() {
        return this.focus();
      }).insertBefore(this.input);
      return this._removeHtmlPlaceholder();
    };
    /*
      @private
      */
    Placeholder.prototype._getRandomId = function() {
      var id;
      id = "";
      while (id.length === 0 || $("#" + id).length > 0) {
        id = "Placeholder_" + (Math.floor(Math.random() * 1000));
      }
      return id;
    };
    /*
      @private
      */
    Placeholder.prototype._removeHtmlPlaceholder = function() {
      this.input.data("placeholder", this.input.attr("placeholder"));
      return this.input.attr("placeholder", "");
    };
    /*
      @private
      */
    Placeholder.prototype._leftOffset = function() {
      return this.input.position().left + parseInt(this.input.css("padding-left").replace("px", '')) + parseInt(this.input.css("border-left-width").replace("px", '')) + parseInt(this.input.css("margin-left").replace("px", '')) + 2;
    };
    /*
      @private
      */
    Placeholder.prototype._topOffset = function() {
      return this.input.position().top + parseInt(this.input.css("padding-top").replace("px", '')) + parseInt(this.input.css("border-top-width").replace("px", '')) + parseInt(this.input.css("margin-top").replace("px", ''));
    };
    /*
      @private
      */
    Placeholder.prototype._overrideDefVal = function() {
      if ($.fn.val === this._newVal) {
        return;
      }
      $.fn.rVal = $.fn.val;
      return $.fn.val = this._newVal;
    };
    /*
      @private
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
    var $input, input;
    input = this[0];
    $input = this;
    return this.each(function() {
      var placeholder, _ref;
      input = $(this);
      if ((_ref = input.data("placeholder")) != null ? _ref.length : void 0) {
        return input.data("placeholderInstance");
      }
      placeholder = new Placeholder(input);
      input.data("placeholderInstance", placeholder);
      return input.keyup(__bind(function() {
        return placeholder.keyup();
      }, this)).blur(__bind(function() {
        return placeholder.blur();
      }, this)).change(__bind(function() {
        return placeholder.keyup();
      }, this)).focus(__bind(function() {
        return placeholder.focus();
      }, this)).resize(__bind(function() {
        return placeholder.resize();
      }, this));
    });
  };
}).call(this);
