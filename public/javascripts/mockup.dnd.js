(function() {
  window.DnDView = Backbone.View.extend({
    events: {
      'dragstart #taskbar li, .object': 'start',
      'dragend .object': 'rm',
      'dragover #whiteboard': 'over',
      'dragleave #whiteboard': 'leave',
      'drop #whiteboard': 'drop',
      'drop .object': 'dropInElem'
    },
    initialize: function() {
      return this.inPlace = false;
    },
    start: function(e) {
      var cad, opt;
      this.inPlace = false;
      opt = $(e.target);
      cad = opt.attr('class').contains('object') ? $('<div>').append(opt.clone()).remove().html() : opt.attr('data-content');
      return e.originalEvent.dataTransfer.setData('content', cad);
    },
    rm: function(e) {
      if (this.inPlace) {
        $(e.target).remove();
        return this.inPlace = false;
      }
    },
    over: function(e) {
      e.originalEvent.preventDefault();
      if ($(e.target).attr('id') === 'whiteboard') {
        return $(e.target).css('background-color', 'hsl(0, 0%, 90%)');
      }
    },
    leave: function(e) {
      var t;
      t = $(e.target);
      if (t.attr('id') === 'whiteboard') {
        return t.css('background-color', 'hsl(0, 0%, 100%)');
      }
    },
    drop: function(e) {
      if ($(e.target).attr('id') === 'whiteboard') {
        return this.put(e);
      }
    },
    put: function(e) {
      var evt, x, y;
      this.leave(e);
      evt = e.originalEvent;
      x = evt.clientX;
      y = evt.clientY;
      ($(evt.dataTransfer.getData('content')).css({
        top: y - 20,
        left: x - 20
      })).addClass('object').attr('draggable', 'true').appendTo('#whiteboard');
      return this.inPlace = true;
    },
    dropInElem: function(e) {
      return this.put(e);
    }
  });
}).call(this);
