port module Component.Editor exposing ( Model, init, Msg, update, view
                                      , subscriptions )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (startsWith, fromChar, endsWith, slice)
import Json.Decode exposing (at, string)
import Json.Encode
import Markdown

-- MODEL



type alias Model =
  { content : String
  , representaition : String
  , selected : Selection }

type alias Selection =
  { text  : String
  , start : Int
  , end   : Int
  }


defaultSelection = Selection "" 0 0

init : (Model, Cmd Msg)
init = (Model "" "" defaultSelection, Cmd.none)


-- UPDATE

port checkSelection : String -> Cmd msg


type Msg = Edited String
         | Selected Selection
         | CheckSelection
         | Bold | Underline


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Edited s ->
      let formatted = sanitiseContent (Debug.log "Content" s)
      in ( { model | content=Debug.log "Formatted" formatted }, Cmd.none )

    CheckSelection -> (model, checkSelection "editor-area")

    Bold -> (makeBold model, Cmd.none)
    Underline -> (makeUnderline model, Cmd.none)

    Selected sel ->
      ( { model | selected = Debug.log "SELECTED" sel }
      , Cmd.none
      )




-- SUBSCRIPTIONS

port getSelected : (Selection -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  getSelected Selected


-- VIEW

view : Model -> Html Msg
view model =
  let toolbar = viewToolbar model
  in div [ class "editor" ]
    [ div [ class "editor-top" ] [ toolbar ]
    , div [ class "editor-text"
          , contenteditable True
          , id "editor-area"
          , onMouseUp CheckSelection
          , on "input" (Json.Decode.map Edited innerHtmlDecoder)
          , property "innerHTML" (Json.Encode.string model.content) ]
        []
    , br [] []
    ]


viewToolbar : Model -> Html Msg
viewToolbar model =
  ul [ class "editor-toolbar" ]
    [ makeToolButton "Bold" Bold
    , makeToolButton "Underline" Underline
    ]

{- | Create an li button representing a tool on the toolbar
with a text [name] and an onclick event [action].
-}
makeToolButton : String -> Msg -> Html Msg
makeToolButton name action =
  li [ onClick action ] [ text name]



innerHtmlDecoder = at ["target", "innerHTML"] string

-- TEXT MANIPULATION

makeBold = selectionWrap '*'
makeUnderline = selectionWrap '_'


selectionWrap : Char -> Model -> Model
selectionWrap ch model =
  let sel = model.selected
      newContent =
        toggleWrapRange ch model.content sel.text sel.start sel.end
  in { model | content = newContent, selected = defaultSelection }


toggleWrapRange : Char    -- ^Character to wrap around selected text
                -> String -- ^The entire string encompassing the selected
                -> String -- ^The selected substring
                -> Int    -- ^start index of selection
                -> Int    -- ^end index of selection
                -> String -- ^result
toggleWrapRange c str sel start end =
  if sel == ""
  then str
  else
    let strLen = String.length str
        beginSlice = slice 0 start str
        endSlice   = slice end strLen str
        wrapped = toggleWrap c sel
    in beginSlice ++ wrapped ++ endSlice


toggleWrap : Char -> String -> String
toggleWrap c str =
  let wrap = fromChar c
  in if startsWith wrap str && endsWith wrap str
     then slice 1 -1 str
     else wrap ++ str ++ wrap


{-| Convert the <div><br></div> into newlines. -}
sanitiseContent : String -> String
sanitiseContent str = str
  -- String.join "\n" (String.split "<div><br></div>" str)
