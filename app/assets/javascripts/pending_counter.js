$(document).ready(function(){
  $("#pending_time")
  var minutesLabel = document.getElementById("minutes");
  var secondsLabel = document.getElementById("seconds");
  var totalSeconds = parseInt(minutesLabel.innerHTML)*60;
  
  setInterval(setTime, 1000);
  function setTime()
  {
    ++totalSeconds;
    secondsLabel.innerHTML = totalSeconds%60;
    minutesLabel.innerHTML = parseInt(totalSeconds/60);
  }

});