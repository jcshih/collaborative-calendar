import socket from './socket';

const elmDiv = document.getElementById("elm-main");
const elmApp = Elm.embed(Elm.CollaborativeCalendar, elmDiv);

let channel = socket.channel("reservations:booker", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })
