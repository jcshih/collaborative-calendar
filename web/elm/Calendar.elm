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
            [ button [ decrMonthHandler ] [ text "<" ]
            , text ((getMonthName month) ++ " " ++ (toString year))
            , button [ incrMonthHandler ] [ text ">" ]
            ]
        ]
        , tr [] (List.map dayLabel [0..6])
    ]


body : List (List Int) -> List Int -> List Int -> Html
body days userReservations otherReservations =
  tbody [] (List.map (row userReservations otherReservations) days)


dayLabel : Int -> Html
dayLabel day =
  td [] [ text (getDayName day) ]


row : List Int -> List Int -> List Int -> Html
row userReservations otherReservations week =
  tr [] (List.map (date userReservations otherReservations) week)


date : List Int -> List Int -> Int -> Html
date userReservations otherReservations day =
  if List.member day userReservations then
    reservedDate day
  else if List.member day otherReservations then
    unavailableDate day
  else
    availableDate day


availableDate : Int -> Html
availableDate day =
  td [] [ text (toString day) ]


reservedDate : Int -> Html
reservedDate day =
  td [ style [ ("background", "green") ] ] [ text (toString day) ]


unavailableDate : Int -> Html
unavailableDate day =
  td [ style [ ("background", "red") ] ] [ text (toString day) ]


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
