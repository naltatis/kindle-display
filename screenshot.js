var page = require('webpage').create();
page.viewportSize = {
  width: 600,
  height: 800
};
page.open('http://localhost:3000/', function() {
  window.setTimeout(function () {
    page.render('public/weather.png');
    phantom.exit();
  }, 1000);
});