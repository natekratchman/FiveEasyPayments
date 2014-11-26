$(document).ready(function(){

  if (window.location.pathname == '/') {
    var hoursLabel = document.getElementById("hours");
    var minutesLabel = document.getElementById("minutes");
    var secondsLabel = document.getElementById("seconds");
    var totalSeconds = parseInt(minutesLabel.innerHTML)*60;
    if(totalSeconds > 10){
      setInterval(setTime, 1000);
    }
    
    function setTime()
    {
      ++totalSeconds;
      secondsLabel.innerHTML = totalSeconds%60;
      minutesLabel.innerHTML = parseInt(totalSeconds/60);
    }
  }
});