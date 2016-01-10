modulejs.define('intro_animation', function() {

  $(function() {

    var allSvg = Snap.selectAll('.__svg-animation');
    var numOfSvg = allSvg.length;

    function changeCurrentSvg(S_el, index) {
      S_el.removeClass('__active-svg');
      Snap('#mask' + ((index + 1) % numOfSvg)).addClass('__active-svg');
      rotateSvg();
    }

    function animation(type, S_el, index) {
      var circle = S_el.select('#mask-circle-' + index);
      if (type === 'show') {
        circle.animate({
          r: 1000
        }, 1000, function() {
          setTimeout(function() {
            animation('hide', S_el, index);
          }, 2000);
        });
      } else {
        circle.animate({
          r: 0
        }, 1000, function() {
          changeCurrentSvg(S_el, index);
        });
      }
    }

    function rotateSvg() {
      allSvg.forEach(function(el, i) {
        var S_el = Snap(el);
        if (S_el.hasClass('__active-svg')) {
          animation('show', S_el, i);
        }
      });
    }

    rotateSvg();

  });

  return {};
});
