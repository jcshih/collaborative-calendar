module Calendar
  ( header, body, advanceMonth
  ) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Array exposing (Array, fromList, get)


-- VIEW

header : Int -> Int -> Attribute -> Attribute -> Html
header year month decrMonthHandler incrMonthHandler =
  thead []
    [ tr []
        [ td [ colspan 7 ]
            [ button [ decrMonthHandler, class "calendar__button--month-nav" ]
                [ text "<" ]
            , text ((getMonthName month) ++ " " ++ (toString year))
            , button [ incrMonthHandler, class "calendar__button--month-nav" ]
                [ text ">" ]
            ]
        ]
        , tr [] (List.map dayLabel [0..6])
    ]


body : List (List Int) -> List Int -> List Int -> (Int -> Attribute) -> (Int -> Attribute) -> Html
body days userReservations otherReservations makeReservation cancelReservation =
  tbody []
    (List.map (row userReservations otherReservations makeReservation cancelReservation) days)


dayLabel : Int -> Html
dayLabel day =
  td [] [ text (getDayName day) ]


row : List Int -> List Int -> (Int -> Attribute) -> (Int -> Attribute) -> List Int -> Html
row userReservations otherReservations makeReservation cancelReservation week =
  tr [] (List.map (date userReservations otherReservations makeReservation cancelReservation) week)


date : List Int -> List Int -> (Int -> Attribute) -> (Int -> Attribute) -> Int -> Html
date userReservations otherReservations makeReservation cancelReservation day =
  if day == 0 then
    td [ class "empty" ] [ div [ class "calendar__date-content" ] [] ]
  else if List.member day userReservations then
    reservedDate day cancelReservation
  else if List.member day otherReservations then
    unavailableDate day
  else
    availableDate day makeReservation


availableDate : Int -> (Int -> Attribute) -> Html
availableDate day makeReservation =
  td [ makeReservation day ] [ dateContent day ]


reservedDate : Int -> (Int -> Attribute) -> Html
reservedDate day cancelReservation =
  td [ cancelReservation day, class "calendar__date--reserved" ]
    [ dateContent day ]


unavailableDate : Int -> Html
unavailableDate day =
  td [ class "calendar__date--unavailable" ] [ dateContent day ]


dateContent : Int -> Html
dateContent day =
  div [ class "calendar__date-content" ] [ text (toString day) ]


-- HELPERS

monthNames : Array String
monthNames =
  fromList
    [ "Jan", "Feb", "Mar", "Apr", "May", "Jun"
    , "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ]

getMonthName : Int -> String
getMonthName monthIndex =
  Maybe.withDefault "" (get monthIndex monthNames)


dayNames : Array String
dayNames =
  fromList [ "Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat" ]


getDayName : Int -> String
getDayName dayIndex =
  Maybe.withDefault "" (get dayIndex dayNames)


advanceMonth : Int -> Int -> Int -> (Int, Int)
advanceMonth year month increment =
  let
    newMonth = month + increment
    newYear =
      if newMonth < 0 then
        year - 1
      else if newMonth > 11 then
        year + 1
      else
        year
  in
    (newYear, newMonth % 12)
