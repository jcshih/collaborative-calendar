import socket from "./socket";
import { prettyDate } from "./util";
import { Calendar } from "calendar";
import alertify from "alertify.js";

alertify.logPosition("top right")
        .closeLogOnClick(true)
        .maxLogItems(4);

const cal = new Calendar();
const currentDate = new Date();
const currentYear = currentDate.getFullYear();
const currentMonth = currentDate.getMonth();

const initialActiveMonth = {
  year: currentYear,
  month: currentMonth,
  days: cal.monthDays(currentYear, currentMonth)
};
const initialReservation = { year: 0, month: 0, day: 0 };

const initialState = {
  initialActiveMonth,
  getMonth: initialActiveMonth,
  getReservations: {
    user: [],
    other: []
  },
  userReservation: initialReservation,
  otherReservation: initialReservation,
  userCancellation: initialReservation,
  otherCancellation: initialReservation
};

const elmDiv = document.getElementById("elm-main");
const elmApp = Elm.embed(Elm.CollaborativeCalendar, elmDiv, initialState);

const { ports } = elmApp;

let channel = socket.channel("reservations:booker", {});
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) });

ports.monthRequest.subscribe(([ year, month ]) => {
  ports.getMonth.send({
    year,
    month,
    days: cal.monthDays(year, month)
  });
});

ports.reservationRequest.subscribe(date => {
  channel.push("make_reservation", date)
         .receive("error", resp => console.log(resp));
});

ports.cancellationRequest.subscribe(date => {
  channel.push("cancel_reservation", date)
         .receive("error", resp => console.log(resp));
});

channel.on("all_reservations", reservations => {
  ports.getReservations.send(reservations);
});

channel.on("user_reservation_update", reservation => {
  ports.userReservation.send(reservation);
  alertify.success(`You have reserved ${prettyDate(reservation)}`);
});

channel.on("other_reservation_update", reservation => {
  ports.otherReservation.send(reservation);
  alertify.error(`Someone else has reserved ${prettyDate(reservation)}`);
});

channel.on("user_cancellation_update", reservation => {
  ports.userCancellation.send(reservation);
  alertify.success(`You have no longer reserved ${prettyDate(reservation)}`);
});

channel.on("other_cancellation_update", reservation => {
  ports.otherCancellation.send(reservation);
  alertify.error(`${prettyDate(reservation)} has become available`);
});
