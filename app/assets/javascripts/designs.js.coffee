# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
@process_steps = (current_step, steps) ->
  if steps[current_step - 1] and steps[current_step - 1]()
    #if current_step + 1 >= steps.length
      #$("#process-btn").html("Submit")
    return current_step + 1
  else
    return current_step
