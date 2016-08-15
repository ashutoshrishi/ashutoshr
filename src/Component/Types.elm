module Component.Types exposing (..)

import Json.Decode as Json
import Json.Decode exposing ((:=))

type alias Post =
  { title   : String
  , content : String
  , slug    : String
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
  let title = "title" := Json.string
      content = "content" := Json.string
      slug = "slug" := Json.string
  in Json.object3 Post title content slug
                
  
