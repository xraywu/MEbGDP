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
//=require_tree .
//=require jquery
//=require jquery-ui
//=require jquery.qtip
//=require rails
//=require autocomplete-rails
//= require rails.validations
//= require jquery.colorbox

$(function() {
  if ($("#prediction-results").length > 0) {
    setTimeout(updatePredictionResults, 5000);
  }
});

function updatePredictionResults() {
  if ($("#prediction-results").attr("data-result") != "true") {
  	var task_id = $("#prediction-results").attr("data-task-id");
    $.getScript("/predictions/pollAllResult.js?task_id=" + task_id)
  	setTimeout(updatePredictionResults, 5000);
  }
}

function showOverlappedResults() {
  	var task_id = $("#prediction-results").attr("data-task-id");
    $.getScript("/predictions/showOverlappedResults.js?task_id=" + task_id)
}

function showAllResults() {
	var task_id = $("#prediction-results").attr("data-task-id");
    $.getScript("/predictions/showAllResults.js?task_id=" + task_id)
}
