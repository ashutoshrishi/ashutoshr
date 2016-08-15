module Router exposing (Page (..), toHash, hashParser, pageParser
                       , defaultPage, routeNames )

import String
import Navigation
import UrlParser exposing (Parser, format, oneOf)

-- |Type representing different accessible pages which will load in the index
type Page = HomePage | BlogPage

--| Default page to be displayed in the Index page.  
defaultPage : Page
defaultPage = HomePage

--| Assoc list of Page -> human readable name.              
routeNames : List (Page, String)
routeNames =
  [ (HomePage, "home")
  , (BlogPage, "blog")
  ]

--| Convert the give [page] to it's corresponding url.
toHash : Page -> String
toHash page =
  case page of
    HomePage -> "#home"
    BlogPage -> "#blog"


{-| Generate a parser which converts the url in [location] to the [Page] type
or fail.
-} 
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
