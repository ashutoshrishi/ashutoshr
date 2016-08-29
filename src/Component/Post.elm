module Component.Post
    exposing
        ( Model
        , Msg
        , init
        , update
        , view
        , fetchPostBySlug
        )

import Bootstrap.Html exposing (..)
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onFocus, onClick, on)
import Component.Types exposing (..)
import Task
import Http
import Router exposing (goErrorPage)
import Markdown


-- Model


type alias Model =
    { displayedPost : Maybe Post }


init : ( Model, Cmd Msg )
init =
    ( Model Nothing, Cmd.none )



-- Update


type Msg
    = GetPostBySlug String
    | GotPost Post
    | FetchFail Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetPostBySlug slug ->
            ( model, fetchPostBySlug slug model )

        GotPost post ->
            ( { model | displayedPost = Just post }
            , Cmd.none
            )

        FetchFail err ->
            ( { model | displayedPost = Nothing }
            , goErrorPage
            )



-- view


view : Model -> Html Msg
view model =
    case model.displayedPost of
        Nothing ->
            text "Error"

        Just post ->
            container_
                [ row_
                    [ colMd_ 12 12 8
                        [ viewPost post ]
                    ]
                ]


viewPost : Post -> Html Msg
viewPost post =
    let
        title =
            div [ class "post-title" ]
                [ h1 [] [ text post.title ] ]

        createdOn =
            case post.created of
                Nothing ->
                    "some random day."

                Just date ->
                    formattedDate date
    in
        div [ class "post" ]
            [ br [] []
            , title
            , div [ class "post-date" ] [ text ("Written on " ++ createdOn) ]
            , br [] []
            , renderMarkdown post.content "post-content"
            ]



-- FETCHERS


{-| Makes a request to fetch a post identified by a [slug], only if the
currently displayed post is not the same.
-}
fetchPostBySlug : String -> Model -> Cmd Msg
fetchPostBySlug slug model =
    let
        url =
            "http://localhost:3000/post/slug/" ++ slug
    in
        case model.displayedPost of
            Nothing ->
                Task.perform FetchFail GotPost (Http.get postDecoder url)

            Just post ->
                if post.slug == slug then
                    Cmd.none
                else
                    Task.perform FetchFail GotPost (Http.get postDecoder url)
