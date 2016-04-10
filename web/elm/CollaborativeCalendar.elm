module CollaborativeCalendar where

import Calendar

import Html exposing (..)
import Html.Events exposing (onClick)
import StartApp
import Effects exposing (Effects, Never)
import Task exposing (Task)


-- MODEL

type alias Model =
  { activeMonth : ActiveMonth
  }


type alias ActiveMonth =
  { year  : Int
  , month : Int
  , days  : List (List Int)
  }


init : Model
init =
  { activeMonth = initialActiveMonth
  }


-- UPDATE

type Action
  = NoOp
  | SetActiveMonth ActiveMonth
  | DecrementMonth
  | IncrementMonth


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


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ calendar address model.activeMonth
    ]


calendar : Signal.Address Action -> ActiveMonth -> Html
calendar address { year, month, days } =
  table []
    [ Calendar.header
        year
        month
        (onClick address DecrementMonth)
        (onClick address IncrementMonth)
    , Calendar.body days
    ]


-- SIGNALS

actions : Signal Action
actions =
  activeMonthSignal


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


-- EFFECTS

sendMonthRequest : (Int, Int) -> Effects Action
sendMonthRequest date =
  Signal.send monthRequestMailbox.address date
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
