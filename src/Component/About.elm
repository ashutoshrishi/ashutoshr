module Component.About exposing (view)

import Html exposing (..)
import Html.Attributes exposing ( class )
import Bootstrap.Html exposing (..)


view : Html msg
view =
  div [ class "about-page" ]
    [ row_
        [ colMd_ 12 12 6
            [ h2 [] [ text "About Me" ]
            , p  [] [ text aboutMe ]
            ]
        ]
    ]

{-| Immense rambling about me. -}
aboutMe : String
aboutMe = """

Hello, I am a Developer in Melbourne, and a recent graduate from University of
Melbourne (MSc. Computer Science). 

"""
          
