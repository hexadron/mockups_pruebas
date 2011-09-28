(function() {
  $(function() {
    new StartView({
      el: $('body')
    });
    new FanView({
      el: $('#taskbar ul.menu')
    });
    return new DnDView({
      el: $('body')
    });
  });
}).call(this);
