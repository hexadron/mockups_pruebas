(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  window.FanView = Backbone.View.extend({
    deploying: false,
    deployed: void 0,
    clones: [],
    textos: [
      {
        id: '_titulo',
        content: '<h1>titulo</h1>'
      }, {
        id: '_subtitulo',
        content: '<h2>subtitulo</h2>'
      }, {
        id: '_parrafo',
        content: '<p>Lorem Ipsum Lalala</p>'
      }, {
        id: '_label',
        content: '<h4>label</h4>'
      }
    ],
    formas: [
      {
        id: '_cuadrado',
        content: "<div class='square'></div>"
      }, {
        id: '_circulo',
        content: "<div class='circle'></div>"
      }
    ],
    controles: [
      {
        id: '_boton',
        content: 'boton'
      }, {
        id: '_radio',
        content: 'radio'
      }, {
        id: '_checkbox',
        content: 'checkbox'
      }
    ],
    cont_textos: [
      {
        id: '_textbox',
        content: 'textbox'
      }, {
        id: '_textarea',
        content: 'textarea'
      }
    ],
    contenedores: [
      {
        id: '_panel',
        content: 'panel'
      }, {
        id: '_navegador',
        content: "<div class='navigator'></div>"
      }, {
        id: '_ventana',
        content: 'ventana'
      }
    ],
    events: {
      'click li:not(.clone)': 'evalDeployment',
      'dragstart li': 'lagRetract',
      'dragstart .clone': 'lagRetract'
    },
    initialize: function() {
      var arreglo, t, _i, _j, _len, _len2, _ref;
      _ref = [this.textos, this.formas, this.controles, this.cont_textos, this.contenedores];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        arreglo = _ref[_i];
        for (_j = 0, _len2 = arreglo.length; _j < _len2; _j++) {
          t = arreglo[_j];
          t.content = this.setAsInnerClass(t.content);
        }
      }
      return this.clones = {};
    },
    evalDeployment: function(e) {
      var clonefound, elem, fn, _results;
      elem = $(e.target);
      clonefound = false;
      fn = __bind(function(elem) {
        var f;
        if (!this.deploying && elem.hasClass('.clone') === false) {
          return this.deploy(elem);
        } else if (elem[0] === this.deployed[0]) {
          return this.retract((function() {}), elem);
        } else if (elem.hasClass("_item")) {
          f = __bind(function() {
            return this.deploy(elem);
          }, this);
          return this.retract(f, elem);
        }
      }, this);
      _results = [];
      while (!clonefound) {
        if ((elem.attr('class') != null) && elem.attr('class').startsWith('_')) {
          clonefound = true;
        }
        if (clonefound) {
          fn(elem);
        }
        _results.push(elem = elem.parent());
      }
      return _results;
    },
    deploy: function(item) {
      var c, collection, i, init_x, init_y, typeclass, x, y, _i, _j, _len, _len2, _ref;
      typeclass = $(item).attr('class').split(' ')[0];
      if (!$(item).hasClass('_item')) {
        this.clones[typeclass] = [];
        collection = this.getArray(typeclass.substring(1, typeclass.length));
        for (_i = 0, _len = collection.length; _i < _len; _i++) {
          i = collection[_i];
          c = ($(item)).clone();
          c.addClass('clone');
          c.css({
            position: 'absolute',
            top: $(item).position().top,
            left: $(item).position().left,
            zIndex: 0
          });
          c.appendTo('#taskbar ul');
          c.removeAttr('id');
          c.attr('id', i.id);
          c.attr('data-content', i.content);
          this.clones[typeclass].push(c);
          $(item).addClass('_item');
        }
      }
      init_y = 65;
      init_x = 0;
      y = init_y;
      x = init_x;
      _ref = this.clones[typeclass];
      for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
        c = _ref[_j];
        $(c).animate({
          top: "-" + y,
          left: "+=" + x
        });
        x += init_x;
        y += init_y;
        init_x += 5;
      }
      this.deployed = item;
      return this.deploying = true;
    },
    retract: function(callback, elem) {
      var c, dieCount, myclones, that, type, _i, _len, _ref, _results;
      dieCount = 1;
      type = elem.attr('class').split(' ')[0];
      that = this;
      _ref = this.clones[type];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        myclones = this.clones[type];
        _results.push($(c).animate({
          top: $(this.deployed).position().top,
          left: $(this.deployed).position().left
        }, 'normal', __bind(function() {
          if (dieCount === myclones.length) {
            that.deploying = false;
            this.clones[type][this.clones[type].length - 1].addClass('_item');
            if (callback != null) {
              callback.call();
            }
          }
          return dieCount++;
        }, this)));
      }
      return _results;
    },
    cloneSelect: function(e) {
      var clonefound, elem, fn, _results;
      clonefound = false;
      fn = __bind(function(e) {
        var content, id, type;
        type = "" + (e.attr('class').split(' ')[0]);
        id = e.attr('id');
        content = e.html();
        $("." + type + ":not(.clone)").attr('id', id).html(content);
        return this.retract((function() {}), e);
      }, this);
      elem = $(e.target);
      _results = [];
      while (!clonefound) {
        if ((elem.attr('class') != null) && elem.attr('class').contains('clone')) {
          clonefound = true;
        }
        if (clonefound) {
          fn(elem);
        }
        _results.push(elem = elem.parent());
      }
      return _results;
    },
    lagRetract: function() {
      var fn, that;
      that = this;
      if (this.deploying) {
        fn = function() {
          return that.retract((function() {}), that.deployed);
        };
        return setTimeout(fn, 400);
      }
    },
    getArray: function(type) {
      switch (type) {
        case 'text':
          return this.textos;
        case 'shape':
          return this.formas;
        case 'control':
          return this.controles;
        case 'textcontainer':
          return this.cont_textos;
        case 'container':
          return this.contenedores;
      }
    },
    setAsInnerClass: function(str) {
      return "<div class='inner'>" + str + "</div>";
    }
  });
}).call(this);
