import socket from "./socket";
import { Calendar } from "calendar";

const cal = new Calendar();
const currentDate = new Date();
const currentYear = currentDate.getFullYear();
const currentMonth = currentDate.getMonth();

const initialActiveMonth = {
  year: currentYear,
  month: currentMonth,
  days: cal.monthDays(currentYear, currentMonth)
};
const initialState = {
  initialActiveMonth,
  getMonth: initialActiveMonth,
  getReservations: {
    user: [],
    other: []
  }
};

const elmDiv = document.getElementById("elm-main");
const elmApp = Elm.embed(Elm.CollaborativeCalendar, elmDiv, initialState);

const { getMonth, monthRequest, getReservations } = elmApp.ports;

monthRequest.subscribe(([ year, month ]) => {
  getMonth.send({
    year,
    month,
    days: cal.monthDays(year, month)
  });
});

let channel = socket.channel("reservations:booker", {});
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) });

channel.on("all_reservations", reservations => {
  getReservations.send(reservations);
});
