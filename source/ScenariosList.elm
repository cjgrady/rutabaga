module ScenariosList
    exposing
        ( Model
        , Msg
        , getPackages
        , init
        , update
        )

import List.Extra as List
import Http
import ProgramFlags exposing (Flags)
import Decoder
    exposing
        ( AtomObjectRecord
        , AtomList(..)
        , decodeAtomList
        , AtomObject(..)
        , decodeScenario
        , Scenario(..)
        , ScenarioRecord
        , decodeScenarioPackage
        , ScenarioPackage(..)
        , ScenarioPackageRecord
        )


type alias Model =
    { packageList : List AtomObjectRecord
    , packages : List ScenarioPackageRecord
    , programFlags : Flags
    }


type Msg
    = GotPackageList (List AtomObjectRecord)
    | GotPackage ScenarioPackageRecord
    | Nop


init : Flags -> Model
init flags =
    { packageList = []
    , packages = []
    , programFlags = flags
    }


getPackages : Flags -> (Msg -> msg) -> Cmd msg
getPackages { apiRoot } msgMap =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Accept" "application/json" ]
        , url = apiRoot ++ "scenpackage"
        , body = Http.emptyBody
        , expect = Http.expectJson decodeAtomList
        , timeout = Nothing
        , withCredentials = False
        }
        |> Http.send gotPackageList
        |> Cmd.map msgMap


gotPackageList : Result Http.Error AtomList -> Msg
gotPackageList result =
    case result of
        Ok (AtomList atoms) ->
            atoms |> List.map (\(AtomObject o) -> o) |> List.uniqueBy .id |> GotPackageList

        Err err ->
            Debug.log "Loading scenario package list failed" err
                |> always Nop


getPackage : Flags -> Int -> Cmd Msg
getPackage { apiRoot } id =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Accept" "application/json" ]
        , url = apiRoot ++ "scenpackage/" ++ (toString id)
        , body = Http.emptyBody
        , expect = Http.expectJson decodeScenarioPackage
        , timeout = Nothing
        , withCredentials = False
        }
        |> Http.send gotPackage


gotPackage : Result Http.Error ScenarioPackage -> Msg
gotPackage result =
    case result of
        Ok (ScenarioPackage p) ->
            GotPackage p

        Err err ->
            Debug.log "Loading scenario package failed" err
                |> always Nop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotPackageList atoms ->
            ( { model | packageList = atoms }, atoms |> List.map (.id >> getPackage model.programFlags) |> Cmd.batch )

        GotPackage p ->
            ( { model | packages = p :: model.packages }, Cmd.none )

        Nop ->
            ( model, Cmd.none )
