(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  window.StartView = Backbone.View.extend({
    canHide: false,
    events: {
      'click': 'hide'
    },
    initialize: function() {
      return $('#start').fadeIn('slow', __bind(function() {
        return this.canHide = true;
      }, this));
    },
    hide: function() {
      if (this.canHide) {
        return $('#start').fadeOut('slow', function() {
          return this.canHide = false;
        });
      }
    }
  });
}).call(this);
