 $(window).load(function() {
   var slider = new Slider("#price", {
     tooltip: 'always',
     range: true,
     min: 0,
     max: 10000,
     value: [0, 700]
   });
});
