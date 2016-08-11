import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import String
import Navigation
import UrlParser exposing (Parser, format, oneOf)
-- Components
import Component.Home as Home

main =
  Navigation.program (Navigation.makeParser hashParser)
    { init = init
    , view = view
    , update = update
    , urlUpdate = urlUpdate
    , subscriptions = subscriptions
    }

-- URL parser

type Page = HomePage | BlogPage

toHash : Page -> String
toHash page =
  case page of
    HomePage -> "#home"
    BlogPage -> "#blog"


hashParser : Navigation.Location -> Result String Page
hashParser location =
  let hashed = (String.dropLeft 1 location.hash)
  in UrlParser.parse identity pageParser hashed

    
pageParser : Parser (Page -> a) a
pageParser =
  oneOf
    [ format HomePage (UrlParser.s "home")
    , format BlogPage (UrlParser.s "blog")
    ]


-- MODEL
type alias Model =
  { page : Page }


init : Result String Page -> (Model, Cmd msg)
init result = urlUpdate result (Model HomePage)

-- UPDATE


update : msg -> Model -> (Model, Cmd msg)
update _ model = (model, Cmd.none)
                 

urlUpdate : Result String Page -> Model -> (Model, Cmd msg)
urlUpdate result model =
  case Debug.log "result" result of
    Err _ ->
      (model, Navigation.modifyUrl (toHash model.page))
    Ok page ->
      ({ model
        | page = page
       }, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub msg
subscriptions model =
  Sub.none
  
-- VIEW            

view : Model -> Html msg
view model = viewPage model


viewPage : Model -> Html msg
viewPage model =
  case model.page of
    HomePage -> Home.view Home.init
    BlogPage -> div [] [text "BLOG NOT IMPLEMENTED"]
