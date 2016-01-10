// this executes the required modules for the main page
modulejs.define('main-page-init', [
    'video_player_init', 'intro_animation', 'nav_routes', 'explore_places_icon_animation', 'picture_gallery',
    'animate_crave_phone_slides', 'animate_share_phone_slides'
  ],
  function() {
    return {};
  });

// this executes the required modules for the privacy policy page
modulejs.define('policy-page-init', [
    'panels'
  ],
  function() {
    return {};
  });

// this executes the required modules for the terms of use page
modulejs.define('terms-page-init', [
    'panels'
  ],
  function() {
    return {};
  });


// this checks the current page for the div.js-page element with attribute data-page-name,
// then executes the correct module above for that page
(function() {
  var PAGES = {
    main: 'main-page-init',
    policy: 'policy-page-init',
    terms: 'terms-page-init'
  };

  $(function() {
    var pageName = $('.js-page').data('page-name');
    if (pageName && PAGES[pageName]) {
      modulejs.require(PAGES[pageName]);
    }
  });
})();
