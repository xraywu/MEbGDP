// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  if ($("#prediction-results").length > 0) {
    setTimeout(updatePredictionResults, 5000);
  }
});

function updatePredictionResults() {
  if ($("#prediction-results").attr("data-result") != "true") {
  	var task_id = $("#prediction-results").attr("data-task-id");
    $.getScript("/predictions/pollAllResults.js?task_id=" + task_id)
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
