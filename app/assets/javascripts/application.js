// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery.ui.all
//= require best_in_place
//= require d3
//= require jshashtable
//= require feedbackvis
//= require_tree .

$(document).ready(function() {
  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();
});

function warning(message){
  n = noty({
    timeout: false,
    text: message,
    layout: "topRight",
    type: "warning",
    closeWith: ['click','hover'],
    callback: {
      afterShow: function(){
        setTimeout(function(){
          n.close();
        },4000);
      }
    }
  });
}

function information(message){
  n = noty({
    timeout: false,
    text: message,
    layout: "topRight",
    type: "information",
    closeWith: ['click','hover'],
    callback: {
      afterShow: function(){
        setTimeout(function(){
          n.close();
        },4000);
      }
    }
  });
}
