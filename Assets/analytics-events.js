document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('a[href*="play.google.com"]').forEach(function (link) {
    link.addEventListener('click', function () {
      var app = (link.href.includes('glucolog') || link.href.includes('glucoenzyme')) ? 'glucoenzyme' : 'glycotrace';
      if (typeof gtag !== 'undefined') {
        gtag('event', 'play_store_click', { app_name: app, page_location: window.location.href });
      }
    });
  });

  document.querySelectorAll('a[href*="demo.glycotrace.co.uk"], a[href*="glycotrace.co.uk/demo"]').forEach(function (link) {
    link.addEventListener('click', function () {
      if (typeof gtag !== 'undefined') {
        gtag('event', 'demo_click', { page_location: window.location.href });
      }
    });
  });
});
