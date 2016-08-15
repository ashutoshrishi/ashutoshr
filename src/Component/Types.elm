module Component.Types exposing (..)

import Json.Decode as Json
import Json.Decode exposing ((:=))
import Date
import Date.Format exposing (format)
import Result exposing (toMaybe)

type alias Post =
  { title   : String
  , content : String
  , slug    : String
  , created : Maybe Date.Date
  }

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


  
postListDecoder : Json.Decoder (List Post)
postListDecoder = "posts" := (Json.list postDecoder)


postDecoder : Json.Decoder Post
postDecoder =
  let title   = "title"   := Json.string
      content = "content" := Json.string
      slug    = "slug"    := Json.string
      created = "created" := Json.string
  in Json.object4 createPost title content slug created
                

{-| Helper to apply transformations to fields before applying the Post
constructor.  
-}
createPost : String -> String -> String -> String -> Post
createPost title content slug created =
  Post title content slug (toMaybe (Date.fromString created))


formattedDate : Date.Date -> String
formattedDate date = format "%d %b %Y at %I:%M %p" date
