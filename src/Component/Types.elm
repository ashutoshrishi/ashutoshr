module Component.Types exposing (..)

import Html exposing (..)
import Html.Attributes exposing ( class, style )
import Html.Events exposing ( onClick )
import Json.Decode as Json
import Json.Decode exposing ((:=))
import Date
import Date.Format exposing (format)
import Result exposing (toMaybe)
import String
import Markdown

type alias Post =
  { title   : String
  , content : String
  , slug    : String
  , created : Maybe Date.Date
  }

{-| Helper to find a particular post in a post list. -}
findPostBy : (Post -> a) -> a -> List Post -> Maybe Post
findPostBy pred target posts =
  let folder post acc =
        case acc of
          Nothing -> if pred post == target
                     then Just post
                     else Nothing
          _ -> acc
  in
    List.foldr folder Nothing posts


{-| Json decoder for a list of posts. -}
postListDecoder : Json.Decoder (List Post)
postListDecoder = "posts" := (Json.list postDecoder)


{-| Json decoder for a single post. -}
postDecoder : Json.Decoder Post
postDecoder =
  let title   = "title"   := Json.string
      content = "content" := Json.string
      slug    = "slug"    := Json.string
      created = "created" := Json.string
  in Json.object4 createPost title content slug created


{-| Render a markdown string `str` into HTML, which will be wrapped in a
div of class `cls`.
-}
renderMarkdown : String -> String -> Html msg
renderMarkdown str cls =
  let options =
        { githubFlavored = Just { tables=True, breaks=False }
        , defaultHighlighting = Just "haskell"
        , sanitize = False
        , smartypants = True
        }
  in
    if cls == ""
    then Markdown.toHtmlWith options [] str
    else Markdown.toHtmlWith options [ class cls ] str



{-| Render the body of a blog `post` (in markdown) to its HTML representaion.
The flag `isExcerpt` is True when the body is to be truncated with a link to
full post at the end. This link will invoke the `action` with the post slug
as its input.
-}
renderPostBody : Bool -> Post -> (String -> msg) -> Html msg
renderPostBody isExcerpt post action =
  if String.length post.content > 500 && isExcerpt
  then
    let excerpt = String.left 500 post.content ++ " ..."
    in
      div []
        [ renderMarkdown excerpt "post-content"
        , p []
          [ a [ onClick (action post.slug)
              , style [ ("cursor", "pointer") ]
              ]
              [ text "Read More"] ]
        ]
  else
    renderMarkdown post.content "post-content"



{-| Helper to apply transformations to fields before applying the Post
constructor.
-}
createPost : String -> String -> String -> String -> Post
createPost title content slug created =
  Post title content slug (toMaybe (Date.fromString created))


{-| Helper for fomatted the datetime of a blog post -}
formattedDate : Date.Date -> String
formattedDate date = format "%d %b %Y at %I:%M %p" date
