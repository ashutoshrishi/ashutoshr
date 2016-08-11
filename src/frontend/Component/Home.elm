module Component.Home exposing (..)

import Html exposing (..)
import Bootstrap.Html exposing (..)
import Html.Attributes exposing (..)

import Component.Header as Header

-- MODEL

type alias Model =
  { header : Header.Model }

init : Model
init = Model Header.init

-- VIEW

view : Model -> Html msg
view model =
  containerFluid_
    [ row_
        [ colMd_ 12 12 12
            [ Header.view model.header ]
        ]
    ]
