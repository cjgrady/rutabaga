{-
   Copyright (C) 2018, University of Kansas Center for Research

   Lifemapper Project, lifemapper [at] ku [dot] edu,
   Biodiversity Institute,
   1345 Jayhawk Boulevard, Lawrence, Kansas, 66045, USA

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or (at
   your option) any later version.

   This program is distributed in the hope that it will be useful, but
   WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
   02110-1301, USA.
-}


module Authentication exposing (Model, Msg, update, view, init, getUserName)

import Regex
import ProgramFlags exposing (Flags)
import Http
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options as Options
import Navigation as Nav


type alias LoginFields =
    { username : String
    , password : String
    , rejected : Bool
    }


type State
    = Unknown
    | NotLoggedIn LoginFields
    | LoggingIn LoginFields
    | LoggedIn String


type alias Model =
    State


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Unknown, requestUser flags )


type Msg
    = IsLoggedIn String
    | LoginFailed
    | IsAnon
    | UpdateUserName String
    | UpdatePassword String
    | DoLogin
    | DoLogOut
    | DoReload


getUserName : State -> Maybe String
getUserName state =
    case state of
        LoggedIn username ->
            Just username

        NotLoggedIn _ ->
            Just "anon"

        _ ->
            Nothing


update : Flags -> Msg -> State -> ( Bool, ( State, Cmd Msg ) )
update flags msg state =
    case msg of
        IsLoggedIn user ->
            ( True, LoggedIn user ! [] )

        UpdateUserName username ->
            case state of
                NotLoggedIn fields ->
                    ( False, NotLoggedIn { fields | username = username } ! [] )

                _ ->
                    ( False, state ! [] )

        UpdatePassword password ->
            case state of
                NotLoggedIn fields ->
                    ( False, NotLoggedIn { fields | password = password } ! [] )

                _ ->
                    ( False, state ! [] )

        DoLogin ->
            case state of
                NotLoggedIn fields ->
                    ( False, LoggingIn fields ! [ doLogin flags fields ] )

                _ ->
                    ( False, state ! [] )

        DoLogOut ->
            ( True, state ! [ doLogOut flags ] )

        DoReload ->
            ( False, state ! [ Nav.reload ] )

        LoginFailed ->
            case state of
                LoggingIn fields ->
                    ( False, NotLoggedIn { fields | rejected = True } ! [] )

                _ ->
                    ( False, NotLoggedIn { username = "", password = "", rejected = False } ! [] )

        IsAnon ->
            ( True, NotLoggedIn { username = "", password = "", rejected = False } ! [] )


doLogin : Flags -> LoginFields -> Cmd Msg
doLogin { apiRoot } { username, password } =
    Http.request
        { method = "POST"
        , headers = []
        , url = Regex.replace Regex.All (Regex.regex "v2/$") (\_ -> "login") apiRoot
        , body =
            Http.multipartBody
                [ Http.stringPart "userid" username
                , Http.stringPart "pword" password
                ]
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }
        |> Http.send gotLoginResult


doLogOut : Flags -> Cmd Msg
doLogOut { apiRoot } =
    Http.request
        { method = "GET"
        , headers = []
        , url = Regex.replace Regex.All (Regex.regex "v2/$") (\_ -> "logout") apiRoot
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }
        |> Http.send gotLoginResult


gotLoginResult : Result Http.Error String -> Msg
gotLoginResult result =
    case result of
        Ok string ->
            DoReload

        Err (Http.BadStatus bad) ->
            if bad.status.code == 403 then
                LoginFailed
            else
                Debug.log "Error checking logged in user" (toString bad) |> always LoginFailed

        Err err ->
            Debug.log "Error checking logged in user" (toString err) |> always LoginFailed


requestUser : Flags -> Cmd Msg
requestUser { apiRoot } =
    Http.request
        { method = "GET"
        , headers = []
        , url = Regex.replace Regex.All (Regex.regex "v2/$") (\_ -> "login") apiRoot
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }
        |> Http.send gotUser


gotUser : Result Http.Error String -> Msg
gotUser result =
    case result of
        Ok string ->
            if String.startsWith "Welcome " string then
                string
                    |> String.dropLeft (String.length "Welcome ")
                    |> IsLoggedIn
            else
                IsAnon

        Err err ->
            Debug.log "Error checking logged in user" (toString err) |> always LoginFailed


view : String -> State -> List (Html Msg)
view signUpHref state =
    let
        style =
            Html.Attributes.style [ ( "margin", "2px 5px" ) ]

        loginFormEls username password disableButton =
            [ Html.input
                [ Html.Attributes.type_ "text"
                , Html.Attributes.placeholder "Username"
                , Html.Attributes.value username
                , style
                , Html.Events.onInput UpdateUserName
                ]
                []
            , Html.input
                [ Html.Attributes.type_ "password"
                , Html.Attributes.placeholder "Password"
                , Html.Attributes.value password
                , style
                , Html.Events.onInput UpdatePassword
                ]
                []
            , Html.button
                [ Html.Events.onClick DoLogin
                , Html.Attributes.disabled disableButton
                , style
                ]
                [ Html.text "Login" ]
            , Html.p
                [ Html.Attributes.style [ ( "text-align", "right" ), ( "margin-right", "5px" ) ] ]
                [ Html.a [ Html.Attributes.href signUpHref ] [ Html.text "sign up" ] ]
            ]

        loginForm { username, password, rejected } disableButton =
            if rejected then
                (Html.p [ style ] [ Html.text "Invalid username or password." ]
                    :: (loginFormEls username password disableButton)
                )
            else
                loginFormEls username password disableButton
    in
        case state of
            LoggedIn userName ->
                [ Layout.link [ Options.onClick DoLogOut, Options.css "cursor" "pointer", Options.css "padding" "8px 20px" ]
                    [ Icon.i "exit_to_app", Html.text "Logout" ]
                ]

            Unknown ->
                []

            NotLoggedIn loginInfo ->
                loginForm loginInfo False

            LoggingIn loginInfo ->
                loginForm loginInfo True
