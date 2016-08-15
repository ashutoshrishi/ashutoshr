module Router exposing (Page (..), toHash, hashParser, pageParser
                       , defaultPage, routeList )

import String
import Navigation
import UrlParser exposing (Parser, format, oneOf)

-- |Type representing different accessible pages which will load in the index
type Page = HomePage | BlogPage

defaultPage : Page
defaultPage = HomePage

routeList : List (String, Page)
routeList =
  [ ("home", HomePage)
  , ("blog", BlogPage)
  ]

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
