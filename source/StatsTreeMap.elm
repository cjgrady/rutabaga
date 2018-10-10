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


module StatsTreeMap exposing (..)

import Html
import Html.Attributes
import Dict
import Set
import McpaModel
import ParseMcpa exposing (McpaData, parseMcpa)
import McpaTreeView exposing (viewTree)
import StatsMain


type alias Model =
    { mcpaModel : McpaModel.Model McpaData
    , statsModel : StatsMain.Model
    }


type Msg
    = McpaMsg McpaModel.Msg
    | StatsMsg StatsMain.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        McpaMsg msg_ ->
            let
                ( mcpaModel, cmd ) =
                    McpaModel.update msg_ model.mcpaModel
            in
                ( { model | mcpaModel = mcpaModel }, Cmd.map McpaMsg cmd )

        StatsMsg msg_ ->
            let
                ( statsModel, cmd ) =
                    StatsMain.update msg_ model.statsModel
            in
                ( { model | statsModel = statsModel }, Cmd.map StatsMsg cmd )


parseData : String -> ( List String, McpaData )
parseData data =
    case parseMcpa data of
        Ok result ->
            result

        Err err ->
            Debug.crash ("failed to decode MCPA matrix: " ++ err)


view : Model -> Html.Html Msg
view { mcpaModel, statsModel } =
    let
        selectedSiteIds =
            statsModel.selected |> Set.toList |> List.map toString |> String.join " "

        selectData cladeId =
            Dict.get ( cladeId, "Observed", mcpaModel.selectedVariable ) mcpaModel.data
    in
        Html.div
            [ Html.Attributes.style
                [ ( "display", "flex" )
                  -- , ( "justify-content", "space-between" )
                , ( "font-family", "sans-serif" )
                , ( "height", "100vh" )
                ]
            ]
            [ viewTree mcpaModel selectData |> Html.map McpaMsg
            , Html.div
                [ Html.Attributes.style
                    [ ( "display", "flex" )
                    , ( "flex-direction", "column" )
                    , ( "flex-grow", "1" )
                    ]
                ]
                [ Html.div
                    [ Html.Attributes.style [ ( "flex-shrink", "0" ), ( "margin", "0 12px" ) ] ]
                    [ Html.h3 [ Html.Attributes.style [ ( "text-align", "center" ), ( "text-decoration", "underline" ) ] ]
                        [ Html.text "Mappy McMapface" ]
                    , Html.div
                        [ Html.Attributes.class "leaflet-map"
                        , Html.Attributes.attribute "data-map-sites" selectedSiteIds
                          -- (mcpaModel.selectedNode |> Maybe.map toString |> Maybe.withDefault "")
                        , Html.Attributes.style
                            [ ( "max-width", "900px" )
                            , ( "height", "500px" )
                            , ( "margin-left", "auto" )
                            , ( "margin-right", "auto" )
                            ]
                        ]
                        []
                    ]
                , StatsMain.viewPlot statsModel |> Html.map StatsMsg
                ]
            ]


init : McpaModel.Flags -> ( Model, Cmd Msg )
init flags =
    let
        ( mcpaModel, mcpaCmd ) =
            McpaModel.init parseData flags

        ( statsModel, statsCmd ) =
            StatsMain.init
    in
        ( { mcpaModel = mcpaModel, statsModel = statsModel }
        , Cmd.batch
            [ Cmd.map McpaMsg mcpaCmd
            , Cmd.map StatsMsg statsCmd
            ]
        )


subscriptions : Model -> Sub Msg
subscriptions model =
    [ McpaModel.subscriptions model.mcpaModel |> Sub.map McpaMsg
    , StatsMain.subscriptions model.statsModel |> Sub.map StatsMsg
    ]
        |> Sub.batch


main : Program McpaModel.Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
