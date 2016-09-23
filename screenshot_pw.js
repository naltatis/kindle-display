var page = require('webpage').create();
page.viewportSize = {
  width: 1072,
  height: 1448
};
page.open('http://localhost:3000/', function() {
  window.setTimeout(function () {
    page.render('public/weather_pw.png');
    phantom.exit();
  }, 1000);
});