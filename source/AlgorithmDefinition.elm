{-
Copyright (C) 2017, University of Kansas Center for Research

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
module AlgorithmDefinition
    exposing
        ( Algorithm
        , Parameter
        , ParameterType(..)
        , ParameterOption
        , algorithms
        , getAlgorithmByCode
        )

import Json.Decode exposing (Decoder, field, string, list, succeed, fail, andThen, map, decodeString)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import List.Extra exposing (find)


type alias Algorithm =
    { code : String
    , name : String
    , version : String
    , authors : String
    , link : String
    , software : String
    , description : String
    , parameters : List Parameter
    }


type alias Parameter =
    { name : String
    , displayName : String
    , min : Maybe String
    , max : Maybe String
    , default : Maybe String
    , dataType : ParameterType
    , doc : String
    , options : List ParameterOption
    }


type ParameterType
    = IntegerParam
    | FloatParam


typeFromString : String -> Decoder ParameterType
typeFromString s =
    case s of
        "Integer" ->
            succeed IntegerParam

        "Float" ->
            succeed FloatParam

        t ->
            fail ("Unknown type: " ++ t ++ ". Expected 'Integer' or 'Float'.")


type alias ParameterOption =
    { name : String
    , value : Int
    }


optionValueFromString : String -> Decoder Int
optionValueFromString s =
    case String.toInt s of
        Err msg ->
            fail msg

        Ok v ->
            succeed v


getAlgorithmByCode : String -> Maybe Algorithm
getAlgorithmByCode code =
    find (\alg -> alg.code == code) algorithms


algorithms : List Algorithm
algorithms =
    case decodeString (list algorithm) json of
        Err msg ->
            Debug.crash msg

        Ok algs ->
            algs


algorithm : Decoder Algorithm
algorithm =
    decode Algorithm
        |> required "code" string
        |> required "name" string
        |> required "version" string
        |> required "authors" string
        |> required "link" string
        |> required "software" string
        |> required "description" string
        |> required "parameters" (list parameter)


parameter : Decoder Parameter
parameter =
    decode Parameter
        |> required "name" string
        |> required "displayName" string
        |> optional "min" (map Just string) Nothing
        |> optional "max" (map Just string) Nothing
        |> optional "default" (map Just string) Nothing
        |> required "type" (string |> andThen typeFromString)
        |> required "doc" string
        |> optional "options" (field "option" (list parameterOption)) []


parameterOption : Decoder ParameterOption
parameterOption =
    decode ParameterOption
        |> required "name" string
        |> required "value" (string |> andThen optionValueFromString)


json : String
json =
    """
[
    {
        "authors": "Chopra, Paras, modified by Alex Oshika Avilla and Fabricio Augusto Rodrigues",
        "link": "http://openmodeller.sourceforge.net/algorithms/ann.html",
        "software": "openModeller",
        "description": "An artificial neural network (ANN), also called a simulated neural network (SNN) or commonly just neural network (NN), is an interconnected group of artificial neurons that uses a mathematical or computational model for information processing based on a connectionistic approach to computation. In most cases an ANN is an adaptive system that changes its structure based on external or internal information that flows through the network. In more practical terms, neural networks are non-linear statistical data modeling or decision making tools. They can be used to model complex relationships between inputs and outputs or to find patterns in data. Content retrieved from Wikipedia on the 06th of May, 2008: http://en.wikipedia.org/wiki/Neural_network ",
        "parameters": [
            {
                "doc": "Number of neurons in the hidden layer (additional layer to the input and output layers, not connected externally). ",
                "name": "HiddenLayerNeurons",
                "displayName": "Hidden Layer Neurons",
                "min": "1",
                "type": "Integer",
                "default": "14"
            },
            {
                "doc": "Learning Rate. Training parameter that controls the size of weight and bias changes during learning. ",
                "name": "LearningRate",
                "displayName": "Learning Rate",
                "min": "0",
                "max": "1",
                "type": "Float",
                "default": "0.3"
            },
            {
                "doc": "Momentum simply adds a fraction m of the previous weight update to the current one. The momentum parameter is used to prevent the system from converging to a local minimum or saddle point. A high momentum parameter can also help to increase the speed of convergence of the system. However, setting the momentum parameter too high can create a risk of overshooting the minimum, which can cause the system to become unstable. A momentum coefficient that is too low cannot reliably avoid local minima, and can also slow down the training of the system. ",
                "name": "Momentum",
                "displayName": "Momentum",
                "min": "0",
                "max": "1",
                "type": "Float",
                "default": "0.05"
            },
            {
                "doc": "0 = train by epoch, 1 = train by minimum error ",
                "options": {
                    "option": [
                        {
                            "name": "Train by Epoch",
                            "value": "0"
                        },
                        {
                            "name": "Train by Minimum Error",
                            "value": "1"
                        }
                    ]
                },
                "name": "Choice",
                "displayName": "Choice",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Determines when training will stop once the number of iterations exceeds epochs. When training by minimum error, this represents the maximum number of iterations. ",
                "name": "Epoch",
                "displayName": "Epoch",
                "min": "1",
                "type": "Integer",
                "default": "5000000"
            },
            {
                "doc": "Minimum mean square error of the epoch. Square root of the sum of squared differences between the network targets and actual outputs divided by number of patterns (only for training by minimum error). ",
                "name": "MinimumError",
                "displayName": "Minimum Error",
                "min": "0",
                "max": "0.5",
                "type": "Float",
                "default": "0.01"
            }
        ],
        "code": "ANN",
        "name": "Artificial Neural Network",
        "version": "0.2"
    },
    {
        "authors": "Steven J. Phillips, Miroslav Dudík, Robert E. Schapire",
        "link": "https://www.cs.princeton.edu/~schapire/maxent/",
        "software": "Maxent",
        "description": "A program for maximum entropy modelling of species geographic distributions, written by Steven Phillips, Miro Dudik and Rob Schapire, with support from AT&T Labs-Research, Princeton University, and the Center for Biodiversity and Conservation, American Museum of Natural History. Thank you to the authors of the following free software packages which we have used here: ptolemy/plot, gui/layouts, gnu/getopt and com/mindprod/ledatastream. The model for a species is determined from a set of environmental or climate layers (or \\"coverages\\") for a set of grid cells in a landscape, together with a set of sample locations where the species has been observed. The model expresses the suitability of each grid cell as a function of the environmental variables at that grid cell. A high value of the function at a particular grid cell indicates that the grid cell is predicted to have suitable conditions for that species. The computed model is a probability distribution over all the grid cells. The distribution chosen is the one that has maximum entropy subject to some constraints: it must have the same expectation for each feature (derived from the environmental layers) as the average over sample locations. ",
        "parameters": [
            {
                "doc": "Add all samples to the background, even if they have combinations of environmental values that are already present in the background. (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "addallsamplestobackground",
                "displayName": "Add All Samples to Background",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "Add to the background any sample for which has a combination of environmental values that isn't already present in the background. (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "addsamplestobackground",
                "displayName": "Add Samples to Background",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "Add this number of pixels to the radius of white/purple dots for samples on pictures of predictions. Negative values reduce size of dots. ",
                "name": "adjustsampleradius",
                "displayName": "Adjust Sample Radius",
                "min": "0",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "During model training, allow use of samples that have nodata values for one or more environmental variables. (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "allowpartialdata",
                "displayName": "Use Samples with Some Missing Data",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "If 0, maxentResults.csv file is reinitialized before each run ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "appendtoresultsfile",
                "displayName": "Append Summary Results to maxentResults File",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "Apply a threshold rule, generating a binary output grid in addition to the regular prediction grid. ( 0 : None 1 : 'Fixed cumulative value 1', 2 : 'Fixed cumulative value 5', 3 : 'Fixed cumulative value 10', 4 : 'Minimum training presence', 5 : '10 percentile training presence', 6 : 'Equal training sensitivity and specificity', 7 : 'Maximum training sensitivity plus specificity', 8 : 'Equal test sensitivity and specificity', 9 : 'Maximum test sensitivity plus specificity', 10 : 'Equate entropy of thresholded and origial distributions' ) ",
                "options": {
                    "option": [
                        {
                            "name": "None",
                            "value": "0"
                        },
                        {
                            "name": "Fixed cumulative value 1",
                            "value": "1"
                        },
                        {
                            "name": "Fixed cumulative value 5",
                            "value": "2"
                        },
                        {
                            "name": "Fixed cumulative value 10",
                            "value": "3"
                        },
                        {
                            "name": "Minimum training presence",
                            "value": "4"
                        },
                        {
                            "name": "10 percentile training presence",
                            "value": "5"
                        },
                        {
                            "name": "Equal training sensitivity and specificity",
                            "value": "6"
                        },
                        {
                            "name": "Maximum training sensitivity plus specificity",
                            "value": "7"
                        },
                        {
                            "name": "Equal test sensitivity and specificity",
                            "value": "8"
                        },
                        {
                            "name": "Maximum test sensitivity plus specificity",
                            "value": "9"
                        },
                        {
                            "name": "Equate entropy of thresholded and origial distributions",
                            "value": "10"
                        }
                    ]
                },
                "name": "applythresholdrule",
                "displayName": "Apply Threshold Rule",
                "min": "0",
                "max": "10",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "Automatically select which feature classes to use, based on number of training samples. (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "autofeature",
                "displayName": "Enable Auto Features",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Regularization parameter to be applied to all categorical features; negative value enables automatic setting ",
                "name": "beta_categorical",
                "displayName": "Beta Categorical",
                "type": "Float",
                "default": "-1.0"
            },
            {
                "doc": "Regularization parameter to be applied to all hinge features; negative value enables automatic setting. ",
                "name": "beta_hinge",
                "displayName": "Beta Hinge",
                "type": "Float",
                "default": "-1.0"
            },
            {
                "doc": "Regularization parameter to be applied to all linear, quadratic and product features; netagive value enables automatic setting ",
                "name": "beta_lqp",
                "displayName": "Beta Linear / Quadratic / Product",
                "type": "Float",
                "default": "-1.0"
            },
            {
                "doc": "Regularization parameter to be applied to all threshold features; negative value enables automatic setting ",
                "name": "beta_threshold",
                "displayName": "Beta Threshold",
                "type": "Float",
                "default": "-1.0"
            },
            {
                "doc": "Multiply all automatic regularization parameters by this number. A higher number gives a more spread-out distribution. ",
                "name": "betamultiplier",
                "displayName": "Beta Multiplier",
                "min": "0",
                "type": "Float",
                "default": "1.0"
            },
            {
                "doc": "Stop training when the drop in log loss per iteration drops below this number ",
                "name": "convergencethreshold",
                "displayName": "Convergence Threshold",
                "min": "0",
                "type": "Float",
                "default": "0.00001"
            },
            {
                "doc": "Default prevalence of the species: probability of presence at ordinary occurrence points. See Elith et al., Diversity and Distributions, 2011 for details. ",
                "name": "defaultprevalence",
                "displayName": "Default Prevalence",
                "min": "0.0",
                "max": "1.0",
                "type": "Float",
                "default": "0.5"
            },
            {
                "doc": "Apply clamping when projecting (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "doclamp",
                "displayName": "Do Clamping",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Predict to regions of environmental space outside the limits encountered during training (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "extrapolate",
                "displayName": "Extrapolate",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Reduce prediction at each point in projections by the difference between clamped and non-clamped output at that point (0: no, 1:yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "fadebyclamping",
                "displayName": "Fade By Clamping",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "Allow hinge features to be used (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "hinge",
                "displayName": "Enable Hinge Features",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Number of samples at which hinge features start being used ",
                "name": "hingethreshold",
                "displayName": "Hinge Features Threshold",
                "min": "0",
                "type": "Integer",
                "default": "15"
            },
            {
                "doc": "Measure importance of each environmental variable by training with each environmental variable first omitted, then used in isolation (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "jackknife",
                "displayName": "Do Jackknife to Measure Variable Importance",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "Number of samples at which quadratic features start being used ",
                "name": "l2lqthreshold",
                "displayName": "Linear to Linear / Quadratic Threshold",
                "min": "0",
                "type": "Integer",
                "default": "10"
            },
            {
                "doc": "Allow linear features to be used (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "linear",
                "displayName": "Enable Linear Features",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "If selected, all pictures of models will use a logarithmic scale for color-coding (0: no, 1: yes)) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "logscale",
                "displayName": "Logscale Raw / Cumulative Pictures",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Number of samples at which product and threshold features start being used ",
                "name": "lq2lqptthreshold",
                "displayName": "Linear / Quadratic to Linear / Quadratic / Product / Threshold Features Threshold",
                "min": "0",
                "type": "Integer",
                "default": "80"
            },
            {
                "doc": "If this number of background points / grid cells is larger than this number, then this number of cells is chosen randomly for background points points ",
                "name": "maximumbackground",
                "displayName": "Maximum Number of Background Points",
                "min": "0",
                "type": "Integer",
                "default": "10000"
            },
            {
                "doc": "Stop training after this many iterations of the optimization algorithm ",
                "name": "maximumiterations",
                "displayName": "Maximum Number of Training Iterations",
                "min": "0",
                "type": "Integer",
                "default": "500"
            },
            {
                "doc": "Representation of probabilities used in writing output grids. (0: raw, 1: logistic, 2: cumulative) ",
                "options": {
                    "option": [
                        {
                            "name": "Raw",
                            "value": "0"
                        },
                        {
                            "name": "Logistic",
                            "value": "1"
                        },
                        {
                            "name": "Cumulative",
                            "value": "2"
                        }
                    ]
                },
                "name": "outputformat",
                "displayName": "Output Format",
                "min": "0",
                "max": "2",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Write output grids. Turning this off when doing replicate runs causes only the summary grids (average, std deviation, etc.) to be written, not those for the individual runs. (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "outputgrids",
                "displayName": "Write Output Grids",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Write separate maxentResults file for each species (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "perspeciesresults",
                "displayName": "Per Species Results",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "Create a .png image for each output grid (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "pictures",
                "displayName": "Generate Pictures",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Write various plots for inclusion in .html output (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "plots",
                "displayName": "Generate Plots",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Allow product features to be used (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "product",
                "displayName": "Enable Product Features",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Allow quadtratic features to be used (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "quadratic",
                "displayName": "Enable Quadratic Features",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "If selected, a different random seed will be used for each run, so a different random test / train partition (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "randomseed",
                "displayName": "Random Seed",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "Percentage of presence localities to be randomly set aside as test poits, used to compute AUC, omission, etc. ",
                "name": "randomtestpoints",
                "displayName": "Random Test Points Percentage",
                "min": "0",
                "max": "100",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "Number of replicate runs to do when cross-validating, boostrapping or doing sampling with replacement runs. If this number is greater than 1, future projection will be disabled as multiple ruleset lambdas files will be generated. ",
                "name": "replicates",
                "displayName": "Number of Replicates",
                "min": "1",
                "type": "Integer",
                "default": "1",
                "allowProjectionsIfValue": "1"
            },
            {
                "doc": "If replicates > 1, do multiple runs of this type. Crossvalidate: samples divided into replicates folds; each fold in turn used for test data. Bootstrap: replicate sample sets chosen by sampling with replacement. Subsample: replicate sample sets chosen by removing random test percentage without replacement to be used for evaluation. (0: Crossvalidate, 1: Bootstrap, 2: Subsample) ",
                "options": {
                    "option": [
                        {
                            "name": "Cross-validate",
                            "value": "0"
                        },
                        {
                            "name": "Bootstrap",
                            "value": "1"
                        },
                        {
                            "name": "Subsample",
                            "value": "2"
                        }
                    ]
                },
                "name": "replicatetype",
                "displayName": "Replicate Type",
                "min": "0",
                "max": "2",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "Remove duplicate presence records. If environmental data are in grids, duplicates are records in the same grid cell. Otherwise, duplicates are records with identical coordinates. (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "removeduplicates",
                "displayName": "Remove Duplicates",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Create graphs showing how predicted relative probability of occurrence depends on the value of each environmental variable. (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "responsecurves",
                "displayName": "Generate Response Curves",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "Instead of showing the logistic value for the y axis in response curves, show the exponent (a linear combination of features) (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "responsecurvesexponent",
                "displayName": "Response Curves Exponent",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "Allow threshold features to be used (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "threshold",
                "displayName": "Enable Threshold Features",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Give detailed diagnostics for debugging (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "verbose",
                "displayName": "Produce Verbose Output",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "Write .csv file with predictions at background points (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "writebackgroundpredictions",
                "displayName": "Write Background Predictions",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "Write a grid that shows the spatial distribution of clamping. At each point, the value is the absolute difference between prediction values with and without clamping. (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "writeclampgrid",
                "displayName": "Write Clamp Grid",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "A multidimensional environmental similarity surface (MESS) shows where novel climate conditions exist in the projection layers. The analysis shows botht he degree of novelness and the variable that is most out of range. (0: no, 1: yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "writemess",
                "displayName": "Do MESS Analysis When Projecting",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Write output files containing the data used to make response curves, for import into external plotting software ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "writeplotdata",
                "displayName": "Write Plot Data",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "0"
            }
        ],
        "code": "ATT_MAXENT",
        "name": "Maximum Entropy - ATT Implementation",
        "version": "3.3.3k"
    },
    {
        "authors": "Nix, H. A.",
        "link": "http://openmodeller.sourceforge.net/algorithms/bioclim.html",
        "software": "openModeller",
        "description": "Implements the Bioclimatic Envelope Algorithm. For each given environmental variable the algorithm finds the mean and standard deviation (assuming normal distribution) associated to the occurrence points. Each variable has its own envelope represented by the interval [m - c*s, m + c*s], where 'm' is the mean; 'c' is the cutoff input parameter; and 's' is the standard deviation. Besides the envelope, each environmental variable has additional upper and lower limits taken from the maximum and minimum values related to the set of occurrence points. In this model, any point can be classified as: Suitable: if all associated environmental values fall within the calculated envelopes; Marginal: if one or more associated environmental value falls outside the calculated envelope, but still within the upper and lower limits. Unsuitable: if one or more associated enviromental value falls outside the upper and lower limits. Bioclim's categorical output is mapped to probabilities of 1.0, 0.5 and 0.0 respectively. ",
        "parameters": [
            {
                "doc": "Standard deviation cutoff for all bioclimatic envelopes. Examples of (fraction of inclusion, parameter value) are: (50.0%, 0.674); (68.3%, 1.000); (90.0%, 1.645); (95.0%, 1.960); (99.7%, 3.000) ",
                "name": "StandardDeviationCutoff",
                "displayName": "Standard Deviation Cutoff",
                "min": "0.0",
                "type": "Float",
                "default": "0.674"
            }
        ],
        "code": "BIOCLIM",
        "name": "Bioclim",
        "version": "0.2"
    },
    {
        "authors": "Neil Caithness",
        "link": "http://openmodeller.sourceforge.net/algorithms/csmbs.html",
        "software": "openModeller",
        "description": "Climate Space Model [CSM] is a principle components based algorithm developed by Dr. Neil Caithness. The component selection process in this algorithm implementation is based on the Broken-Stick cutoff where any component with an eigenvalue less than (n stddevs above a randomised sample) is discarded. The original CSM was written as series of Matlab functions. ",
        "parameters": [
            {
                "doc": "The Broken Stick method of selecting the number of components to keep is carried out by randomising the row order of each column in the environmental matrix and then obtaining the eigen value for the randomised matrix. This is repeatedly carried out for the amount of times specified by the user here. ",
                "name": "Randomisations",
                "displayName": "Number of Randomizations",
                "min": "1",
                "max": "1000",
                "type": "Integer",
                "default": "8"
            },
            {
                "doc": "When all the eigen values for the 'shuffled' environmental matrix have been summed this number of standard deviations is added to the mean of the eigen values. Any components whose eigen values are above this threshold are retained. ",
                "name": "StandardDeviations",
                "displayName": "Stnadard Deviations",
                "min": "-10",
                "max": "10",
                "type": "Float",
                "default": "2.0"
            },
            {
                "doc": "If not enough components are selected, the model produced will be erroneous or fail. Usually three or more components are acceptable ",
                "name": "MinComponents",
                "displayName": "Minimum Number of Components",
                "min": "1",
                "max": "20",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Set this to 1 to show extremely verbose diagnostics. Set this to 0 to disable verbose diagnostics ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "VerboseDebugging",
                "displayName": "Enable Verbose Debugging",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "0"
            }
        ],
        "code": "CSMBS",
        "name": "Climate Space Model",
        "version": "0.4"
    },
    {
        "authors": "Stockwell, D. R. B., modified by Ricardo Scachetti Pereira",
        "link": "http://openmodeller.sourceforge.net/algorithms/dg_garp.html",
        "software": "openModeller",
        "description": "GARP is a genetic algorithm that creates ecological niche models for species. The models describe environmental conditions under which the species should be able to maintain populations. For input, GARP uses a set of point localities where the species is known to occur and a set of geographic layers representing the environmental parameters that might limit the species' capabilities to survive. ",
        "parameters": [
            {
                "doc": "Maximum number of iterations (generations) run by the Genetic Algorithm ",
                "name": "MaxGenerations",
                "displayName": "Maximum Number of Generations",
                "min": "1",
                "type": "Integer",
                "default": "400"
            },
            {
                "doc": "Defines the convergence value that makes the algorithm stop (before reaching MaxGenerations). ",
                "name": "ConvergenceLimit",
                "displayName": "Convergence Limit",
                "min": "0",
                "max": "1",
                "type": "Float",
                "default": "0.01"
            },
            {
                "doc": "Maximum number of rules to be kept in solution. ",
                "name": "PopulationSize",
                "displayName": "Population Size",
                "min": "1",
                "max": "500",
                "type": "Integer",
                "default": "50"
            },
            {
                "doc": "Number of points sampled (with replacement) used to test rules. ",
                "name": "Resamples",
                "displayName": "Number of Resamples",
                "min": "1",
                "max": "100000",
                "type": "Integer",
                "default": "2500"
            }
        ],
        "code": "DG_GARP",
        "name": "GARP - DesktopGARP implementation",
        "version": "1.1 alpha"
    },
    {
        "authors": "Anderson, R. P., D. Lew, D. and A. T. Peterson.",
        "link": "http://openmodeller.sourceforge.net/algorithms/dg_garp_bs.html",
        "software": "openModeller",
        "description": "GARP is a genetic algorithm that creates ecological niche models for species. The models describe environmental conditions under which the species should be able to maintain populations. For input, GARP uses a set of point localities where the species is known to occur and a set of geographic layers representing the environmental parameters that might limit the species' capabilities to survive. ",
        "parameters": [
            {
                "doc": "Percentage of occurrence data to be used to train models. ",
                "name": "TrainingProportion",
                "displayName": "Training Proportion",
                "min": "0",
                "max": "100",
                "type": "Float",
                "default": "50"
            },
            {
                "doc": "Maximum number of GARP runs to be performed. ",
                "name": "TotalRuns",
                "displayName": "Total Number of Runs",
                "min": "0",
                "max": "10000",
                "type": "Integer",
                "default": "20"
            },
            {
                "doc": "Maximum acceptable omission error. Set to 100% to use only soft omission. ",
                "name": "HardOmissionThreshold",
                "displayName": "Hard Omission Threshold",
                "min": "0",
                "max": "100",
                "type": "Float",
                "default": "100"
            },
            {
                "doc": "Minimum number of models below omission threshold. ",
                "name": "ModelsUnderOmissionThreshold",
                "displayName": "Models Under Omission Threshold",
                "min": "0",
                "max": "10000",
                "type": "Integer",
                "default": "20"
            },
            {
                "doc": "Percentage of distribution models to be taken regarding commission error. ",
                "name": "CommissionThreshold",
                "displayName": "Commission Threshold",
                "min": "0",
                "max": "100",
                "type": "Float",
                "default": "50"
            },
            {
                "doc": "Number of samples used to calculate commission error. ",
                "name": "CommissionSampleSize",
                "displayName": "Commission Sample Size",
                "min": "1",
                "type": "Integer",
                "default": "10000"
            },
            {
                "doc": "Maximum number of threads of executions to run simultaneously. ",
                "name": "MaxThreads",
                "displayName": "Maximum Number of Threads",
                "min": "1",
                "max": "1024",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Maximum number of iterations (generations) run by the Genetic Algorithm. ",
                "name": "MaxGenerations",
                "displayName": "Maximum Number of Generations",
                "min": "1",
                "type": "Integer",
                "default": "400"
            },
            {
                "doc": "Defines the convergence value that makes the algorithm stop (before reaching MaxGenerations). ",
                "name": "ConvergenceLimit",
                "displayName": "Convergence Limit",
                "min": "0",
                "max": "1",
                "type": "Float",
                "default": "0.01"
            },
            {
                "doc": "Maximum number of rules to be kept in solution. ",
                "name": "PopulationSize",
                "displayName": "Population Size",
                "min": "1",
                "max": "500",
                "type": "Integer",
                "default": "50"
            },
            {
                "doc": "Number of points sampled (with replacement) used to test rules. ",
                "name": "Resamples",
                "displayName": "Number of Resamples",
                "min": "1",
                "max": "100000",
                "type": "Integer",
                "default": "2500"
            }
        ],
        "code": "DG_GARP_BS",
        "name": "GARP with Best Subsets - DesktopGARP implementation",
        "version": "3.0.2"
    },
    {
        "authors": "Mauro E. S. Munoz, Renato De Giovanni, Danilo J. S. Bellini",
        "link": "http://openmodeller.sourceforge.net/algorithms/envdist.html",
        "software": "openModeller",
        "description": "Generic algorithm based on environmental dissimilarity metrics. When used with the Gower metric and maximum distance 1, this algorithm should produce the same result of the algorithm known as DOMAIN. ",
        "parameters": [
            {
                "doc": "Metric used to calculate distances: 1=Euclidean, 2=Mahalanobis, 3=Manhattan/Gower, 4=Chebyshev ",
                "options": {
                    "option": [
                        {
                            "name": "Euclidean",
                            "value": "1"
                        },
                        {
                            "name": "Mahalanobis",
                            "value": "2"
                        },
                        {
                            "name": "Manhattan / Gower",
                            "value": "3"
                        },
                        {
                            "name": "Chebyshev",
                            "value": "4"
                        }
                    ]
                },
                "name": "DistanceType",
                "displayName": "Distance Type",
                "min": "1",
                "max": "4",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Nearest 'n' points whose mean value will be the reference when calculating environmental distances. When set to 1, distances will be measured to the closest point, which is the same behavior of the previously existing minimum distance algorithm. When set to 0, distances will be measured to the average of all presence points, which is the same behavior of the previously existing distance to average algorithm. Intermediate values between 1 and the total number of presence points are now accepted. ",
                "name": "NearestPoints",
                "displayName": "Nearest N Points",
                "min": "0",
                "max": "1000",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Maximum distance to the reference in the environmental space, above which the conditions will be considered unsuitable for presence. Since 1 corresponds to the biggest possible distance between any two points in the environment space, setting the maximum distance to this value means that all points in the environmental space will have an associated probability. The probability of presence for points that fall within the range of the maximum distance is inversely proportional to the distance to the reference point (linear decay). The only exception is when the maximum distance is 1 and the metric is Mahalanobis, which will produce probabilities following the chi-square distribution. ",
                "name": "MaxDistance",
                "displayName": "Maximum Environmental Distance",
                "min": "0",
                "max": "1",
                "type": "Float",
                "default": "0.1"
            }
        ],
        "code": "ENVDIST",
        "name": "Environmental Distance",
        "version": "0.5"
    },
    {
        "authors": "Stockwell, D. R. B., modified by Ricardo Scachetti Pereira",
        "link": "http://openmodeller.sourceforge.net/algorithms/garp.html",
        "software": "openModeller",
        "description": "GARP is a genetic algorithm that creates ecological niche models for species. The models describe environmental conditions under which the species should be able to maintain populations. For input, GARP uses a set of point localities where the species is known to occur and a set of geographic layers representing the environmental parameters that might limit the species' capabilities to survive. This implementation is a complete rewrite of the DesktopGarp code, and it also contains the following changes/improvements: (1) Gene values changed from integers (between 1 and 253) to floating point numbers (between -1.0 and 1.0). This avoids precision problems in environment values during projection (for example, if an environment variable has the value 2.56 in some raster cell and 2.76 in another one, DesktopGarp rounds them off to 3). (2) Atomic rules were removed since they seem to have little significance compared to the other rules. (3) Heuristic operator parameters (percentage of mutation and crossover per iteration) are now static since they used to converge to fixed values during the very first iterations. This implementation simply keeps the converged values. (4) A bug was fixed in the procedure responsible for ordering the rules. When a rule was only replacing another, it was being included in the wrong position. ",
        "parameters": [
            {
                "doc": "Maximum number of iterations (generations) run by the Genetic Algorithm. ",
                "name": "MaxGenerations",
                "displayName": "Maximum Number of Generations",
                "min": "1",
                "type": "Integer",
                "default": "400"
            },
            {
                "doc": "Defines the convergence value that makes the algorithm stop (before reaching MaxGenerations). ",
                "name": "ConvergenceLimit",
                "displayName": "Convergence Limit",
                "min": "0",
                "max": "1",
                "type": "Float",
                "default": "0.01"
            },
            {
                "doc": "Maximum number of rules to be kept in solution. ",
                "name": "PopulationSize",
                "displayName": "Population Size",
                "min": "1",
                "max": "500",
                "type": "Integer",
                "default": "50"
            },
            {
                "doc": "Number of points sampled (with replacement) used to test rules. ",
                "name": "Resamples",
                "displayName": "Number of Resamples",
                "min": "1",
                "max": "100000",
                "type": "Integer",
                "default": "2500"
            }
        ],
        "code": "GARP",
        "name": "GARP",
        "version": "3.3"
    },
    {
        "authors": "Anderson, R. P., D. Lew, D. and A. T. Peterson.",
        "link": "http://openmodeller.sourceforge.net/algorithms/garp_bs.html",
        "software": "openModeller",
        "description": "GARP is a genetic algorithm that creates ecological niche models for species. The models describe environmental conditions under which the species should be able to maintain populations. For input, GARP uses a set of point localities where the species is known to occur and a set of geographic layers representing the environmental parameters that might limit the species' capabilities to survive. This algorithm applies the Best Subsets procedure using the new openModeller implementation in each GARP run. Please refer to GARP single run algorithm description for more information about the differences between DesktopGarp and the new GARP implementation. ",
        "parameters": [
            {
                "doc": "Percentage of occurrence data to be used to train models. ",
                "name": "TrainingProportion",
                "displayName": "Training Proportion",
                "min": "0",
                "max": "100",
                "type": "Float",
                "default": "50"
            },
            {
                "doc": "Maximum number of GARP runs to be performed. ",
                "name": "TotalRuns",
                "displayName": "Total Number of Runs",
                "min": "0",
                "max": "10000",
                "type": "Integer",
                "default": "20"
            },
            {
                "doc": "Maximum acceptable omission error. Set to 100% to use only soft omission. ",
                "name": "HardOmissionThreshold",
                "displayName": "Hard Omission Threshold",
                "min": "0",
                "max": "100",
                "type": "Float",
                "default": "100"
            },
            {
                "doc": "Minimum number of models below omission threshold. ",
                "name": "ModelsUnderOmissionThreshold",
                "displayName": "Models Under Omission Threshold",
                "min": "0",
                "max": "10000",
                "type": "Integer",
                "default": "20"
            },
            {
                "doc": "Percentage of distribution of models to be taken regarding commission error. ",
                "name": "CommissionThreshold",
                "displayName": "Commission Threshold",
                "min": "0",
                "max": "100",
                "type": "Float",
                "default": "50"
            },
            {
                "doc": "Number of samples used to calculate commission error. ",
                "name": "CommissionSampleSize",
                "displayName": "Commission Sample Size",
                "min": "1",
                "type": "Integer",
                "default": "10000"
            },
            {
                "doc": "Maximum number of threads of executions to run simultaneously. ",
                "name": "MaxThreads",
                "displayName": "Maximum Number of Threads",
                "min": "1",
                "max": "1024",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Maximum number of iterations (generations) run by the Genetic Algorithm. ",
                "name": "MaxGenerations",
                "displayName": "Maximum Number of Generations",
                "min": "1",
                "type": "Integer",
                "default": "400"
            },
            {
                "doc": "Defines the convergence value that makes the algorithm stop (before reaching MaxGenerations). ",
                "name": "ConvergenceLimit",
                "displayName": "Convergence Limit",
                "min": "0",
                "max": "1",
                "type": "Float",
                "default": "0.01"
            },
            {
                "doc": "Maximum number of rules to be kept in solution. ",
                "name": "PopulationSize",
                "displayName": "Population Size",
                "min": "1",
                "max": "500",
                "type": "Integer",
                "default": "50"
            },
            {
                "doc": "Number of points sampled (with replacement) used to test rules. ",
                "name": "Resamples",
                "displayName": "Number of Resamples",
                "min": "1",
                "max": "100000",
                "type": "Integer",
                "default": "2500"
            }
        ],
        "code": "GARP_BS",
        "name": "GARP with Best Subsets",
        "version": "3.0.4"
    },
    {
        "authors": "Steven J. Phillips, Miroslav Dudík, Robert E. Schapire",
        "link": "http://openmodeller.sourceforge.net/algorithms/maxent.html",
        "software": "openModeller",
        "description": "The principle of maximum entropy is a method for analyzing available qualitative information in order to determine a unique epistemic probability distribution. It states that the least biased distribution that encodes certain given information is that which maximizes the information entropy (content retrieved from Wikipedia on the 19th of May, 2008: http://en.wikipedia.org/wiki/Maximum_entropy). This implementation in openModeller follows the same approach of Maxent (Phillips et al. 2004). It was compared with Maxent 3.3.3e through a standard experiment using all possible combinations of parameters, generating models with the same number of iterations, at least a 90% rate of matching best features considering all iterations, distribution maps with a correlation (r) greater than 0.999 and no difference in the final loss. However, previous implementations of this algorithm (before version 1.0) used to generate quite different results. The first versions were based on an existing third-party Maximum Entropy library which produced low quality models compared with all other algorithms. After that, the algorithm was re-written a couple of times by Elisangela Rodrigues as part of her Doctorate. Finally, the EUBrazil-OpenBio project funded the remaining work to make this algorithm compatible with Maxent. Please note that not all functionality available from Maxent is available here - in particular the possibility of using collecting bias and categorical maps is not present, as well as many specific parameters for advanced users. However, you should be able to get compatible results for all other available parameters. ",
        "parameters": [
            {
                "doc": "Number of background points to be generated. ",
                "name": "NumberOfBackgroundPoints",
                "displayName": "Number of Background Points",
                "min": "0",
                "max": "10000",
                "type": "Integer",
                "default": "10000"
            },
            {
                "doc": "When absence points are provided, this parameter can be used to instruct the algorithm to use them as background points. This would prevent the algorithm to randomly generate them, also facilitating comparisons between different algorithms. ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "UseAbsencesAsBackground",
                "displayName": "Use Absences As Background",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "Include input points in the background: 0=No, 1=Yes. ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "IncludePresencePointsInBackground",
                "displayName": "Include Presence Points In Background",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Number of iterations. ",
                "name": "NumberOfIterations",
                "displayName": "Number of Iterations",
                "min": "1",
                "type": "Integer",
                "default": "500"
            },
            {
                "doc": "Tolerance for detecting model convergence. ",
                "name": "TerminateTolerance",
                "displayName": "Terminate Tolerance",
                "min": "0",
                "type": "Float",
                "default": "0.00001"
            },
            {
                "doc": "Output format: 1 = Raw, 2 = Logistic. ",
                "options": {
                    "option": [
                        {
                            "name": "Raw",
                            "value": "1"
                        },
                        {
                            "name": "Logistic",
                            "value": "2"
                        }
                    ]
                },
                "name": "OutputFormat",
                "displayName": "Output Format",
                "min": "1",
                "max": "2",
                "type": "Integer",
                "default": "2"
            },
            {
                "doc": "Enable quadratic features (0=no, 1=yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "QuadraticFeatures",
                "displayName": "Enable Quadratic Features",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Enable product features (0=no, 1=yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "ProductFeatures",
                "displayName": "Enable Product Features",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Enable hinge features (0=no, 1=yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "HingeFeatures",
                "displayName": "Enable Hinge Features",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Enable threshold features (0=no, 1=yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "ThresholdFeatures",
                "displayName": "Enable Threshold Features",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Enable auto features (0=no, 1=yes) ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "AutoFeatures",
                "displayName": "Enable Auto Features",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Number of samples at which product and threshold features start being used (only when auto features is enabled). ",
                "name": "MinSamplesForProductThreshold",
                "displayName": "Minimum Samples For Product and Threshold Features",
                "min": "1",
                "type": "Integer",
                "default": "80"
            },
            {
                "doc": "Number of samples at which quadratic features start being used (only when auto features is enabled). ",
                "name": "MinSamplesForQuadratic",
                "displayName": "Minimum Number of Samples for Quadratic Features",
                "min": "1",
                "type": "Integer",
                "default": "10"
            },
            {
                "doc": "Number of samples at which hinge features start being used (only when auto features is enabled). ",
                "name": "MinSamplesForHinge",
                "displayName": "Minimum Number of Samples For Hinge Features",
                "min": "1",
                "type": "Integer",
                "default": "15"
            }
        ],
        "code": "MAXENT",
        "name": "Maximum Entropy - openModeller Implementation",
        "version": "1.0"
    },
    {
        "authors": "Vladimir N. Vapnik",
        "link": "http://openmodeller.sourceforge.net/algorithms/svm.html",
        "software": "openModeller",
        "description": "Support vector machines map input vectors to a higher dimensional space where a maximal separating hyperplane is constructed. Two parallel hyperplanes are constructed on each side of the hyperplane that separates the data. The separating hyperplane is the hyperplane that maximises the distance between the two parallel hyperplanes. An assumption is made that the larger the margin or distance between these parallel hyperplanes the better the generalisation error of the classifier will be. The model produced by support vector classification only depends on a subset of the training data, because the cost function for building the model does not care about training points that lie beyond the margin. Content retrieved from Wikipedia on the 13th of June, 2007: http://en.wikipedia.org/w/index.php?title=Support_vector_machine&oldid=136646498. The openModeller implementation of SVMs makes use of the libsvm library version 2.85: Chih-Chung Chang and Chih-Jen Lin, LIBSVM: a library for support vector machines, 2001. Software available at http://www.csie.ntu.edu.tw/~cjlin/libsvm. Release history: version 0.1: initial release version 0.2: New parameter to specify the number of pseudo-absences to be generated; upgraded to libsvm 2.85; fixed memory leaks version 0.3: when absences are needed and the number of pseudo absences to be generated is zero, it will default to the same number of presences version 0.4: included missing serialization of C version 0.5: the indication if the algorithm needed normalized environmental data was not working when the algorithm was loaded from an existing model. ",
        "parameters": [
            {
                "doc": "Type of SVM: 0 = C-SVC, 1 = Nu-SVC, 2 = one-class SVM ",
                "options": {
                    "option": [
                        {
                            "name": "C-SVC",
                            "value": "0"
                        },
                        {
                            "name": "Nu-SVC",
                            "value": "1"
                        },
                        {
                            "name": "One-class SVM",
                            "value": "2"
                        }
                    ]
                },
                "name": "SvmType",
                "displayName": "SVM Type",
                "min": "0",
                "max": "2",
                "type": "Integer",
                "default": "0"
            },
            {
                "doc": "Type of kernel function: 0 = linear: u'*v , 1 = polynomial: (gamma*u'*v + coef0)^degree , 2 = radial basis function: exp(-gamma*|u-v|^2) ",
                "options": {
                    "option": [
                        {
                            "name": "Linear: u'*v",
                            "value": "0"
                        },
                        {
                            "name": "Polynomial: (gamma*u'*v + coef0) ^ degree",
                            "value": "1"
                        },
                        {
                            "name": "Radial basis function: exp(-gamma*|u-v|^2)",
                            "value": "2"
                        }
                    ]
                },
                "name": "KernelType",
                "displayName": "Kernel Type",
                "min": "0",
                "max": "4",
                "type": "Integer",
                "default": "2"
            },
            {
                "doc": "Degree in kernel function (only for polynomial kernels). ",
                "name": "Degree",
                "displayName": "Polynomial Kernel Degree",
                "min": "0",
                "type": "Integer",
                "default": "3"
            },
            {
                "doc": "Gamma in kernel function (only for polynomial and radial basis kernels). When set to zero, the default value will actually be 1/k, where k is the number of layers. ",
                "name": "Gamma",
                "displayName": "Kernel Gamma",
                "type": "Float",
                "default": "0"
            },
            {
                "doc": "Coef0 in kernel function (only for polynomial kernels). ",
                "name": "Coef0",
                "displayName": "Polynomial Kernel Coef0",
                "type": "Float",
                "default": "0"
            },
            {
                "doc": "Cost (only for C-SVC types). ",
                "name": "C",
                "displayName": "Cost",
                "min": "0",
                "type": "Float",
                "default": "1"
            },
            {
                "doc": "Nu (only for Nu-SVC and one-class SVM). ",
                "name": "Nu",
                "displayName": "Nu",
                "min": "0.001",
                "max": "1",
                "type": "Float",
                "default": "0.5"
            },
            {
                "doc": "Indicates if the output should be a probability instead of a binary response (only available for C-SVC and Nu-SVC). ",
                "options": {
                    "option": [
                        {
                            "name": "No",
                            "value": "0"
                        },
                        {
                            "name": "Yes",
                            "value": "1"
                        }
                    ]
                },
                "name": "ProbabilisticOutput",
                "displayName": "Generate Probabilistic Output",
                "min": "0",
                "max": "1",
                "type": "Integer",
                "default": "1"
            },
            {
                "doc": "Number of pseudo-absences to be generated (only for C-SVC and Nu-SVC when no absences have been provided). When absences are needed, a zero parameter will default to the same number of presences. ",
                "name": "NumberOfPseudoAbsences",
                "displayName": "Number of Pseudo Absences",
                "min": "0",
                "type": "Integer",
                "default": "0"
            }
        ],
        "code": "SVM",
        "name": "Support Vector Machines",
        "version": "0.5"
    }
]
"""
