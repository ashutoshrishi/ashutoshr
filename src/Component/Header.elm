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
  let title = p [] [ text "ARR" ]
      logo = img [ src "assets/images/logo-retina@2x.png"
                 , height 100 ] []
  in div [ class "header" ]
    [ row_
      [ colMd_ 12 12 4
          [ div [class "logo"]
              [ div [class "logo-image"] [ logo ]
              , div [class "logo-text"] [ text "ARR" ]
              ]
          ]
      , colMd_ 12 12 8 [headerLinks model.activePage]        
      ]
    ]


{-| Create a horizantal list of links to all the routes in [routeNames]. The
page that is currently active and displayed in the model will be highlighted
differently and hence [active] is threaded through the function.
-}    
headerLinks : Page -> Html Msg
headerLinks active =
  let links =
        List.append socialLinks
          <| List.map (makeLink active) <| List.reverse routeNames
          
  in ul [ class "nav nav-pills" ] links
    

{-| Creates a link with text [to], clicking which invokes a message to change
the models' active page to [page]. The link corresponding to the page [active]
is the current displayed page and will be styled a bit differently.
-}    
makeLink : Page -> (Page, String) -> Html Msg
makeLink active (page, to) =
  let activeClass = if active == page then "current" else ""
      link = a [ onClick (ChangePage page) ] [ text to ]
  in li [ class activeClass ] [ link ]


{-| List of links which lead away from the blog -}    
socialLinks : List (Html Msg)
socialLinks =
  let linkTo name to =
        li [] [ a [ href to ] [ text name ]
              ]
      links = [ ("bitbucket", "https://bitbucket.org/ashutoshrishi")
              , ("github", "https://github.com/ashutoshrishi")
              ]
  in List.map (uncurry linkTo) links
