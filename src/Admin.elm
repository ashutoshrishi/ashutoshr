
import Bootstrap.Html exposing (..)
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

import Component.Types exposing (..)


-- Model

main = 
  App.program
    { init          = init
    , view          = view
    , update        = update
    , subscriptions = subscriptions
    }


type alias Model =
  { loggedIn : Bool
  , postList : List Post
  , displayPage : AdminPage
  }

type AdminPage = PostListPage
               | AddPostPage


init : (Model, Cmd Msg)
init =
  ( Model False [] PostListPage
  , Cmd.none
  )

-- Update

type Msg = ChangePage AdminPage


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChangePage p ->
      ( { model | displayPage = p }
      , Cmd.none
      )


-- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- View


view : Model -> Html Msg
view model =
  let page = case model.displayPage of
               PostListPage -> viewPostList model
               AddPostPage -> h1 [] [ text "Add A new Post someday" ]
  in div []
    [ viewAdminBar
    , containerFluid_
        [ row_ [ viewIconBar ]
        , div [ class "admin-main" ] [ page ]
        ]
    ]


viewIconBar : Html Msg
viewIconBar =  
  div [ class "admin-nav" ]
    [ ul []
        [ li [] [ glyphiconList_ ]
        , li [] [ glyphiconPlus_ ]
        , li [] [ glyphiconHome_ ]
        ]
    ]
    
    
viewAdminBar : Html Msg
viewAdminBar =
  navbarDefault' "admin-top-bar"
    [ containerFluid_
        [ navbarHeader_
            [ a [ class "navbar-brand", href "#" ] [ text "ARR Blog Admin" ] ]
        ]
    ]


viewPostList : Model -> Html Msg
viewPostList model =
  div [ class "admin-post-list-row" ]
    [ row_ [ colMd_ 12 12 12               
               [ div [ class "admin-title"] [ text "Showing all Posts" ] ]
           ]
    , row_ [ colMd_ 12 12 6
               [ tableStriped_
                   [ thead []
                       [ th [] [ text "#" ]
                       , th [] [ text "Slug" ]
                       , th [] [ text "Date" ]
                       ]
                   ]
               ]
           ]
    ]
