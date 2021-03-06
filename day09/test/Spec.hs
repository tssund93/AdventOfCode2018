import Lib

import Control.Monad (unless)
import Data.Foldable (toList)
import qualified Data.Sequence as S
import GHC.Exts (fromList)
import System.Exit (exitFailure)

main :: IO ()
main = do
    testCalculateHighScore
    testPlaceMarble
    testRemoveMarble
    testCounterClockwise
    testClockwise
    testAddScore

testEq :: (Eq a, Show a) => a -> a -> IO ()
testEq a b = do
    let check = a == b
    putStrLn $ show a ++ " == " ++ show b ++ ": " ++ show check
    unless check exitFailure

testCalculateHighScore :: IO ()
testCalculateHighScore = do
    testEq (calculateHighScore 9 25) 32
    testEq (calculateHighScore 10 1618) 8317
    testEq (calculateHighScore 13 7999) 146373
    testEq (calculateHighScore 17 1104) 2764
    testEq (calculateHighScore 21 6111) 54718
    testEq (calculateHighScore 30 5807) 37305

testPlaceMarble :: IO ()
testPlaceMarble = do
    testEq (toList $ placeMarble (fromList [0]) 1) [1, 0]
    testEq (toList $ placeMarble (fromList [1, 0]) 2) [2, 1, 0]
    testEq (toList $ placeMarble (fromList [2, 1, 0]) 3) [3, 0, 2, 1]
    testEq (toList $ placeMarble (fromList [3, 0, 2, 1]) 4) [4, 2, 1, 3, 0]
    testEq
        (toList $ placeMarble (fromList [4, 2, 1, 3, 0]) 5)
        [5, 1, 3, 0, 4, 2]

testRemoveMarble :: IO ()
testRemoveMarble =
    testEq
        ( toList $
            removeMarble
                ( fromList
                    [ 22
                    , 11
                    , 1
                    , 12
                    , 6
                    , 13
                    , 3
                    , 14
                    , 7
                    , 15
                    , 0
                    , 16
                    , 8
                    , 17
                    , 4
                    , 18
                    , 9
                    , 19
                    , 2
                    , 20
                    , 10
                    , 21
                    , 5
                    ]
                )
        )
        [ 19
        , 2
        , 20
        , 10
        , 21
        , 5
        , 22
        , 11
        , 1
        , 12
        , 6
        , 13
        , 3
        , 14
        , 7
        , 15
        , 0
        , 16
        , 8
        , 17
        , 4
        , 18
        ]

testCounterClockwise :: IO ()
testCounterClockwise = do
    testEq
        (toList $ counterClockwise (fromList [1, 2, 3, 4]) 1)
        ([4, 1, 2, 3] :: [Marble])
    testEq
        (toList $ counterClockwise (fromList [1, 2, 3, 4]) 2)
        ([3, 4, 1, 2] :: [Marble])
    testEq
        (toList $ counterClockwise (fromList [1, 2, 3, 4]) 3)
        ([2, 3, 4, 1] :: [Marble])
    testEq
        (toList $ counterClockwise (fromList [1, 2, 3, 4]) 4)
        ([1, 2, 3, 4] :: [Marble])

testClockwise :: IO ()
testClockwise = do
    testEq
        (toList $ clockwise (fromList [1, 2, 3, 4]) 1)
        ([2, 3, 4, 1] :: [Marble])
    testEq
        (toList $ clockwise (fromList [1, 2, 3, 4]) 2)
        ([3, 4, 1, 2] :: [Marble])
    testEq
        (toList $ clockwise (fromList [1, 2, 3, 4]) 3)
        ([4, 1, 2, 3] :: [Marble])
    testEq
        (toList $ clockwise (fromList [1, 2, 3, 4]) 4)
        ([1, 2, 3, 4] :: [Marble])

testAddScore :: IO ()
testAddScore =
    testEq
        ( addScore
            ( fromList
                [ 22
                , 11
                , 1
                , 12
                , 6
                , 13
                , 3
                , 14
                , 7
                , 15
                , 0
                , 16
                , 8
                , 17
                , 4
                , 18
                , 9
                , 19
                , 2
                , 20
                , 10
                , 21
                , 5
                ]
            )
            23
            (S.replicate 9 0)
            4
        )
        $ S.fromList [0, 0, 0, 0, 32, 0, 0, 0, 0]