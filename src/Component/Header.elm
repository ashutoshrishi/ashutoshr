module Component.Header exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.Html exposing (..)

-- MODEL

type Model = EmptyModel

init : Model
init = EmptyModel

-- update


-- VIEW

view : Model -> Html msg
view model =
  div []
    [ h3 [] [ text "Ashutosh Rishi Ranjan" ]
    , hr [] []
    ]
