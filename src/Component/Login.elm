module Component.Login exposing (..)

import Html exposing (..)
import Bootstrap.Html exposing (..)
import Html.Attributes exposing (..)


-- Model



-- Update

type Msg = Login String String



-- View

view : Html Msg
view =
  div [ class "login-page" ]
    [ div [ class "login-box" ]
        [ h2 [] [ text "Login" ]
        , viewLoginForm
        ]
    ]


viewLoginForm : Html Msg
viewLoginForm =
  let makeInput ty pl =
        input [ type' ty, class "form-control", placeholder pl ] []
  in Html.form []
    [ formGroup_
        [ div [ class "input-group"]
            [ makeInput "email" "Email Address"
            , div [ class "input-group-addon"] [ glyphiconUser_ ]
            ]
        ]
    , formGroup_
        [ div [ class "input-group"]
            [ makeInput "password" "Password"
            , div [ class "input-group-addon"] [ glyphiconAsterisk_]
            ]
        ]
    , button [ type' "submit", class "btn btn-primary btn-block btn-lg" ]
      [ glyphiconLock_ ]
    ]
