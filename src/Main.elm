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
import Component.Post as PostComp
import Component.About as About


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
  , postModel : PostComp.Model
  }


init : Result String Page -> (Model, Cmd Msg)
init result =
  let (blogInit, bm) = Blog.init
      (headerInit, hm) =
        Header.init (Result.withDefault defaultPage result )
      (postInit, pm) = PostComp.init
      mainInit = Model defaultPage headerInit blogInit postInit
      (mainModel, updateMsg) = urlUpdate result mainInit                       
  in ( mainModel
     , Cmd.batch [ updateMsg, Cmd.map BlogMsg bm ]
     )


-- UPDATE

type Msg = BlogMsg Blog.Msg
         | HeaderMsg Header.Msg
         | PostMsg PostComp.Msg


  
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

    PostMsg pmsg ->
      let (newPostComp, newMsg) = PostComp.update pmsg model.postModel
      in ( { model | postModel = newPostComp }
         , Cmd.map PostMsg newMsg
         )
                 

{-| Called on a change of url with the result of url parser and the current
model. -}
urlUpdate : Result String Page -> Model -> (Model, Cmd Msg)
urlUpdate result model =
  case Debug.log "result" result of
    Err err ->
      (model, Navigation.modifyUrl (toHash model.page))
    Ok (PostPage slug) ->
      ( { model | page = PostPage slug}
      , Cmd.map PostMsg (PostComp.fetchPostBySlug slug model.postModel) ) 
    Ok page ->
      ({ model | page = page }, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
  
-- VIEW            

{-| View the Index page, with the content area changing according to the
current url page. -}
view : Model -> Html Msg
view model =
  container_
    [ App.map HeaderMsg (Header.view model.headerModel)
    , viewPage model
    , viewFooter
    ]


{-| Run the view function for the current page in the model. -}  
viewPage : Model -> Html Msg
viewPage model =
  case model.page of
    BlogPage -> App.map BlogMsg (Blog.view model.blogModel)
    PostPage slug ->
      App.map PostMsg (PostComp.view model.postModel)
    ErrorPage ->
      div [ class "error-404" ]
        [ glyphiconExclamationSign_
        , br [] []
        , text "404"
        ]
    AboutPage ->
      About.view

{-| Simple footer -}
viewFooter : Html Msg
viewFooter =
  div [ class "footer" ]
    [ row_
        [ colMd_ 12 12 4
            [ p [] [ glyphiconCopyrightMark_
                   , text " 2016 Ashutosh Rishi Ranjan"] ]
        ]
    ]
