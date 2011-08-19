(function() {
  /*
   Author:
  */  var clones, desplegado, desplegar, evaluarDespliegue, moving, replegar;
  String.prototype.contains = function(chain) {
    return this.indexOf(chain) !== -1;
  };
  moving = false;
  desplegado = void 0;
  clones = [];
  desplegar = function(task) {
    var c, i, init_x, init_y, x, y, _i, _len;
    for (i = 1; i <= 5; i++) {
      c = (($(task)).clone().css({
        position: 'absolute',
        top: $(task).position().top,
        left: $(task).position().left,
        zIndex: 0
      })).addClass('clone').appendTo('#taskbar ul');
      clones.push(c);
    }
    init_y = 72;
    init_x = 2;
    y = init_y;
    x = init_x;
    for (_i = 0, _len = clones.length; _i < _len; _i++) {
      c = clones[_i];
      $(c).animate({
        top: "-=" + y,
        left: "+=" + x
      });
      'normal';
      x += init_x;
      y += init_y;
      init_x += 6;
    }
    desplegado = task;
    return moving = true;
  };
  replegar = function() {
    var c, dieCount, _i, _len, _results;
    dieCount = 0;
    _results = [];
    for (_i = 0, _len = clones.length; _i < _len; _i++) {
      c = clones[_i];
      _results.push($(c).animate({
        top: $(desplegado).position().top,
        left: $(desplegado).position().left
      }, 'normal', function() {
        dieCount++;
        if (dieCount === 5) {
          $('.clone').remove();
          moving = false;
          return clones = [];
        }
      }));
    }
    return _results;
  };
  evaluarDespliegue = function(task) {
    if (!moving && $(task).attr('class') === '_browser') {
      return despliegue();
    } else {
      return repliegue();
    }
  };
  $(function() {
    ($('#taskbar li')).bind('click', function(e) {
      e.preventDefault();
      return evaluarDespliegue(this);
    });
    ($('#taskbar li')).bind('dragstart', function() {
      var fn;
      if (moving) {
        fn = function() {
          return evaluarDespliegue(desplegado);
        };
        return setTimeout(fn, 400);
      }
    });
    return ($('.clone')).live('dragstart click', function(e) {
      var fn, time;
      time = e.type === 'click' ? 0 : 400;
      fn = function() {
        return evaluarDespliegue(desplegado);
      };
      return setTimeout(fn, time);
    });
  });
}).call(this);
