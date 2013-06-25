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
//= require jquery.ui.all
//= require bootstrap
//= require best_in_place
//= require d3
//= require jshashtable
//= require feedbackvis
//= require_tree .

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

function error(message){
  n = noty({
    timeout: false,
    text: message,
    layout: "topRight",
    type: "error",
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

function make_image_selectable_with_button(element_str, button_str){
  current_selection = $(element_str).imgAreaSelect({
    instance: true,
    handles: true,
    disable: true,
    onSelectEnd: function(img, selection){
      if ((selection.x1 != selection.x2) && (selection.y1 != selection.y2)){
        $(button_str).removeClass("disabled")
      }else{
        $(button_str).addClass("disabled")
      }
    }
  });
  return current_selection
}

$(document).ready(function() {
  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();
  $(document).ajaxError(function(event, jqxhr, settings, exception){
    message = JSON.parse(jqxhr.responseText)
    if (message.model_error) {
      $.each(message.model_error, function(attribute, messages){
        $.each(messages, function(index, message){
          error(message);
        });
      });
    }

    if (message.error){
      error(message.error);
    }
  });
});

