module Calendar (header, body, advanceMonth) where

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
        , tr [] (List.map dayLabel [ 0, 1, 2, 3, 4, 5, 6 ])
    ]


body : List (List Int) -> Html
body days =
  tbody [] (List.map row days)


dayLabel : Int -> Html
dayLabel day =
  td [] [ text (getDayName day) ]


row : List Int -> Html
row week =
  tr [] (List.map date week)


date : Int -> Html
date day =
  td [] [ text (toString day) ]


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
