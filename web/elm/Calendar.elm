module Calendar (header, body) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Array exposing (Array, fromList, get)


-- VIEW

header : Int -> Int -> Html
header year month =
  thead []
    [ tr []
        [ td [ colspan 7 ]
            [ text ((getMonthName month) ++ " " ++ (toString year))
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
