var ws = new WebSocket("ws://127.0.0.1:8889");
ws.onopen = function() {
    console.log('Connected');
};
var intervalId = window.setInterval(function(){
    ws.send("check...");
}, 3000);

function tweet() {
    let a = document.getElementById("tweet");
    console.log("hello");
}