module Router exposing (Page (..), toHash, hashParser, pageParser
                       , defaultPage, routeNames, goErrorPage )

import String
import Navigation
import UrlParser exposing (Parser, format, oneOf, s, (</>), string)

-- |type representing different accessible pages which will load in the index
type Page = HomePage | BlogPage | PostPage String | ErrorPage 

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
    PostPage slug -> "#blog/post/" ++ slug
    ErrorPage -> "#error"


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
    [ format HomePage (s "home")
    , format PostPage (s "blog" </> s "post" </> string)
    , format BlogPage (s "blog")
    , format ErrorPage (s "error")
    ]

goErrorPage : Cmd msg
goErrorPage = Navigation.newUrl (toHash ErrorPage)
