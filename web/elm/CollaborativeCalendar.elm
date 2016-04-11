module CollaborativeCalendar where

import Calendar

import Html exposing (..)
import Html.Events exposing (onClick)
import StartApp
import Effects exposing (Effects, Never)
import Task exposing (Task)


-- MODEL

type alias Model =
  { activeMonth  : ActiveMonth
  , reservations : Reservations
  }


type alias ActiveMonth =
  { year  : Int
  , month : Int
  , days  : List (List Int)
  }


type alias Reservations =
  { user  : List Reservation
  , other : List Reservation
  }


type alias Reservation =
  { year  : Int
  , month : Int
  , day   : Int
  }


initialReservations : Reservations
initialReservations =
  { user  = []
  , other = []
  }


init : Model
init =
  { activeMonth  = initialActiveMonth
  , reservations = initialReservations
  }


-- UPDATE

type Action
  = NoOp
  | SetActiveMonth ActiveMonth
  | DecrementMonth
  | IncrementMonth
  | SetReservations Reservations
  | MakeReservation Reservation
  | CancelReservation Reservation
  | AddUserReservation Reservation
  | AddOtherReservation Reservation
  | RemoveUserReservation Reservation
  | RemoveOtherReservation Reservation


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp ->
      (model, Effects.none)

    SetActiveMonth month ->
      ({ model | activeMonth = month }, Effects.none)

    DecrementMonth ->
      let
        { year, month } = model.activeMonth
        (newYear, newMonth) = Calendar.advanceMonth year month -1
      in
        (model, sendMonthRequest (newYear, newMonth))

    IncrementMonth ->
      let
        { year, month } = model.activeMonth
        (newYear, newMonth) = Calendar.advanceMonth year month 1
      in
        (model, sendMonthRequest (newYear, newMonth))

    SetReservations reservations ->
      ({ model | reservations = reservations}, Effects.none)

    MakeReservation reservation ->
      (model, sendReservationRequest reservation)

    CancelReservation reservation ->
      (model, sendCancellationRequest reservation)

    AddUserReservation reservation ->
      let
        { reservations } = model
        { user } = reservations
        newReservations = { reservations | user = reservation :: user }
      in
        ({ model | reservations = newReservations }, Effects.none)

    AddOtherReservation reservation ->
      let
        { reservations } = model
        { other } = reservations
        newReservations = { reservations | other = reservation :: other }
      in
        ({ model | reservations = newReservations }, Effects.none)

    RemoveUserReservation reservation ->
      let
        { reservations } = model
        { user } = reservations
        newReservations =
          { reservations | user = List.filter (\r -> r /= reservation) user }
      in
        ({ model | reservations = newReservations }, Effects.none)

    RemoveOtherReservation reservation ->
      let
        { reservations } = model
        { other } = reservations
        newReservations =
          { reservations | other = List.filter (\r -> r /= reservation) other }
      in
        ({ model | reservations = newReservations }, Effects.none)


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ calendar address model.activeMonth model.reservations
    ]


calendar : Signal.Address Action -> ActiveMonth -> Reservations -> Html
calendar address { year, month, days } { user, other } =
  table []
    [ Calendar.header year month
        (onClick address DecrementMonth)
        (onClick address IncrementMonth)
    , Calendar.body days
        (user |> filterReservations year month |> List.map .day)
        (other |> filterReservations year month |> List.map .day)
        (\day -> onClick address (MakeReservation (Reservation year month day)))
        (\day -> onClick address (CancelReservation (Reservation year month day)))
    ]


filterReservations : Int -> Int -> List Reservation -> List Reservation
filterReservations y m reservations =
  List.filter (\{ year, month } -> y == year && m == month) reservations


-- SIGNALS

actions : Signal Action
actions =
  Signal.mergeMany
    [ activeMonthSignal
    , reservationsSignal
    , userReservationSignal
    , otherReservationSignal
    , userCancellationSignal
    , otherCancellationSignal
    ]


activeMonthSignal : Signal Action
activeMonthSignal =
  Signal.map SetActiveMonth getMonth


port initialActiveMonth : ActiveMonth


port getMonth : Signal ActiveMonth


port monthRequest : Signal (Int, Int)
port monthRequest =
  monthRequestMailbox.signal


monthRequestMailbox : Signal.Mailbox (Int, Int)
monthRequestMailbox =
  Signal.mailbox (0, 0)


port getReservations : Signal Reservations


reservationsSignal : Signal Action
reservationsSignal =
  Signal.map SetReservations getReservations


port reservationRequest : Signal Reservation
port reservationRequest =
  reservationRequestMailbox.signal


reservationRequestMailbox : Signal.Mailbox Reservation
reservationRequestMailbox =
  Signal.mailbox (Reservation 0 0 0)


port cancellationRequest : Signal Reservation
port cancellationRequest =
  cancellationRequestMailbox.signal


cancellationRequestMailbox : Signal.Mailbox Reservation
cancellationRequestMailbox =
  Signal.mailbox (Reservation 0 0 0)


port userReservation : Signal Reservation


userReservationSignal : Signal Action
userReservationSignal =
  Signal.map AddUserReservation userReservation


port otherReservation : Signal Reservation


otherReservationSignal : Signal Action
otherReservationSignal =
  Signal.map AddOtherReservation otherReservation


port userCancellation : Signal Reservation


userCancellationSignal : Signal Action
userCancellationSignal =
  Signal.map RemoveUserReservation userCancellation


port otherCancellation : Signal Reservation


otherCancellationSignal : Signal Action
otherCancellationSignal =
  Signal.map RemoveOtherReservation otherCancellation


-- EFFECTS

sendMonthRequest : (Int, Int) -> Effects Action
sendMonthRequest date =
  Signal.send monthRequestMailbox.address date
    |> Effects.task
    |> Effects.map (always NoOp)


sendReservationRequest : Reservation -> Effects Action
sendReservationRequest reservation =
  Signal.send reservationRequestMailbox.address reservation
    |> Effects.task
    |> Effects.map (always NoOp)


sendCancellationRequest : Reservation -> Effects Action
sendCancellationRequest reservation =
  Signal.send cancellationRequestMailbox.address reservation
    |> Effects.task
    |> Effects.map (always NoOp)


-- MAIN

app =
  StartApp.start
    { init = (init, Effects.none)
    , update = update
    , view = view
    , inputs = [ actions ]
    }


port tasks : Signal (Task Never ())
port tasks =
  app.tasks


main : Signal Html
main =
  app.html
