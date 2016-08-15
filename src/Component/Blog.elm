module Component.Blog exposing ( Model, init, Msg, update, view
                               , findPostInModelBySlug )


import Bootstrap.Html exposing (..)
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Json
import Json.Decode exposing ((:=))
import Task
import Navigation
import Router exposing (..)
import Component.Types exposing (..)


-- MODEL

type alias Model =
  { postList  : List Post }

init : (Model, Cmd Msg)
init = (Model [], fetchPosts)


-- UPDATE

type Msg = GetPosts
         | GotPosts (List Post)
         | FetchFail Http.Error
         | ViewPostBySlug String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetPosts -> (model, fetchPosts)
    GotPosts ps -> ({model | postList = ps}, Cmd.none)

    FetchFail err -> ( model, Cmd.none )

    ViewPostBySlug slug ->
      let navigate = Navigation.newUrl (toHash (PostPage slug))
      in (model, navigate)
      

  
            
-- VIEW

{-| Standard view to display all latest blog posts retrieved in the model. -}
view : Model -> Html Msg
view model =
  let postPage = List.map viewPost model.postList
  in container_
    [ row_
        [ colMd_ 12 12 12
            [ div [class "page-title"] [ text "LATEST POSTS"] ]
        ]
    , row_ [ colMd_ 12 12 6 postPage ] ]


{-| View a post on the main page of the blog -}      
viewPost : Post -> Html Msg
viewPost post =
  let titleLink =
        div [class "post-title"]
          [ a [ onClick (ViewPostBySlug post.slug) ] [text post.title] ]
      createdOn =
        case post.created of
          Nothing -> "some random day."
          Just date -> formattedDate date
  in div [class "post"]
    [ titleLink
    , div [class "post-date"] [text ("Written on " ++ createdOn)]
    , p [class "post-content"] [ text post.content ]
    ]


-- FETCHERS 

{-| Perform a GET request to API endpoint which serves list of latest posts |-}
fetchPosts : Cmd Msg
fetchPosts =
  let url = "http://localhost:3000/posts"
  in Task.perform FetchFail GotPosts (Http.get postListDecoder url)



-- SEARCHING


findPostInModelBySlug : String -> Model -> Maybe Post
findPostInModelBySlug slug model = findPostBy .slug slug model.postList       
