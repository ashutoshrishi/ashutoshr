import Bootstrap.Html exposing (..)
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import String
import Navigation
-- import UrlParser exposing (Parser, format, oneOf)
import Router exposing (..)
-- Components
import Component.Blog as Blog
import Component.Header as Header

main =
  Navigation.program (Navigation.makeParser hashParser)
    { init          = init
    , view          = view
    , update        = update
    , urlUpdate     = urlUpdate
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { page : Page
  , headerModel : Header.Model
  , blogModel : Blog.Model
  }


init : Result String Page -> (Model, Cmd Msg)
init result =
  let (blogInit, bm) = Blog.init
      (headerInit, hm) = Header.init
      mainInit = Model defaultPage headerInit blogInit
      (mainModel, _) = urlUpdate result mainInit                       
  in ( mainModel
     , Cmd.map BlogMsg bm )


-- UPDATE

type Msg = BlogMsg Blog.Msg
         | HeaderMsg Header.Msg

  
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    BlogMsg bmsg ->
      let (newModel, newMsg) = Blog.update bmsg model.blogModel
      in ( { model | blogModel = newModel}
         , Cmd.map BlogMsg newMsg
         )

    HeaderMsg hmsg ->
      let (newHeader, newMsg) = Header.update hmsg model.headerModel
      in ( { model | headerModel = newHeader}
         , Cmd.map HeaderMsg newMsg
         )
                 

{-| Called on a change of url with the result of url parser and the current
model. -}
urlUpdate : Result String Page -> Model -> (Model, Cmd Msg)
urlUpdate result model =
  case Debug.log "result" result of
    Err err ->
      (model, Navigation.modifyUrl (toHash model.page))
    Ok page ->
      ({ model | page = page }, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub msg
subscriptions model = Sub.none
  
-- VIEW            

{-| View the Index page, with the content area changing according to the
current url page. -}
view : Model -> Html Msg
view model =
  containerFluid_
    [ App.map HeaderMsg (Header.view model.headerModel)
    , row_ [ colMd_ 12 12 12 [ viewPage model ] ]
    ]


{-| Run the view function for the current page in the model. -}  
viewPage : Model -> Html Msg
viewPage model =
  case model.page of
    HomePage -> App.map BlogMsg (Blog.view model.blogModel)
    BlogPage -> App.map BlogMsg (Blog.view model.blogModel)
