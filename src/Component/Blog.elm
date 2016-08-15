module Component.Blog exposing (Model, init, Msg, update, view, Post)


import Bootstrap.Html exposing (..)
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Http
import Json.Decode as Json
import Json.Decode exposing ((:=))
import Task


-- MODEL

type alias Post =
  { title : String
  , content : String
  }

type alias Model =
  { postList  : List Post  }

init : (Model, Cmd Msg)
init = (Model [], fetchPosts)


-- UPDATE

type Msg = GetPosts
         | GotPosts (List Post)
         | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetPosts -> (model, fetchPosts)
    GotPosts ps -> ({model | postList = ps}, Cmd.none)
    FetchFail err -> (model, Cmd.none)
      

{-| Perform a GET request to API endpoint which serves list of latest posts |-}
fetchPosts : Cmd Msg
fetchPosts =
  let url = "http://localhost:3000/posts"
  in Task.perform FetchFail GotPosts (Http.get decodePosts url)


decodePosts : Json.Decoder (List Post)
decodePosts =
  let postDecoder =
        let title = "title" := Json.string
            content = "content" := Json.string
        in Json.object2 Post title content
      postListDecoder = Json.list postDecoder
  in "posts" := postListDecoder
  
            
-- VIEW

view : Model -> Html Msg
view model =
  div [] [ ul [] (List.map viewPostTitle model.postList) ]

viewPostTitle : Post -> Html Msg
viewPostTitle p = li [] [ text p.title ]                

