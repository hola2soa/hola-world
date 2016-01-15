 $(window).load(function() {
   var slider = new Slider("#price", {
     tooltip: 'always',
     range: true,
     min: 0,
     max: 1000,
     value: [100, 700]
   });

   $( "#search_button" ).click(function() {
     $( "#search_form" ).submit(function(event) {
       event.preventDefault();
       url = $(this).attr('action');
       
       var values = $(this).serialize();

     });
   });
});
