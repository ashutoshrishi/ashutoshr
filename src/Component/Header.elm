module Component.Header exposing (Model, Msg, update, init, view)

import Bootstrap.Html exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Bootstrap.Html exposing (..)
import Router exposing (..)
import Navigation

-- MODEL

type alias Model =
  { activePage : Page }


init : (Model, Cmd Msg)
init = (Model defaultPage, Cmd.none)

-- update

type Msg = ChangePage Page

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChangePage page ->
      let urlMsg = Navigation.modifyUrl (toHash page)
      in (Model page, urlMsg)
                       

-- VIEW

view : Model -> Html Msg
view model =
  let title = p [] [ text "Ashutosh Rishi Ranjan" ]
  in div [ class "header" ] [row_
    [ colMd_ 12 12 3 [ title ]
    , colMd_ 12 12 9 [ headerLinks model.activePage ]
    ]]


headerLinks : Page -> Html Msg
headerLinks active =
  ul [ class "nav nav-pills" ] (List.map (makeLink active) routeList)
    
makeLink : Page -> (String, Page) -> Html Msg
makeLink active (to, page) =
  let activeClass = if active == page then "current" else ""
      link = a [ onClick (ChangePage page) ] [ text to ]
  in li [ class activeClass ] [ link ]
