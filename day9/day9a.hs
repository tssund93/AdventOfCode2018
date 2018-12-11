module Main where

import           Data.List

type Marble = Int

main :: IO ()
main = do
  (playerCount, lastMarble) <- parseInput <$> getLine
  print $ calculateHighScore playerCount lastMarble

parseInput :: String -> (Int, Int)
parseInput s = let w = words s in (read (head w), read (w !! 6))

calculateHighScore :: Int -> Marble -> Int
calculateHighScore playerCount lastMarble =
  let scores = replicate playerCount 0
  in  maximum $ calculateHighScore' 0 scores [0] 0 1
 where
  calculateHighScore' :: Int -> [Int] -> [Marble] -> Marble -> Marble -> [Int]
  calculateHighScore' playerNum scores marbles currentMarble newMarble
    | newMarble > lastMarble
    = scores
    | newMarble `mod` 23 == 0
    = let (newMarbles, newCurrentMarble) = removeMarble marbles currentMarble
      in  calculateHighScore'
            (clockwise playerCount playerNum 1)
            (addScore marbles currentMarble newMarble scores playerNum)
            newMarbles
            newCurrentMarble
            (newMarble + 1)
    | otherwise
    = calculateHighScore' (clockwise playerCount playerNum 1)
                          scores
                          (placeMarble marbles newMarble currentMarble)
                          newMarble
                          (newMarble + 1)

addScore :: [Marble] -> Marble -> Marble -> [Int] -> Int -> [Int]
addScore marbles currentMarble newMarble scores playerNum =
  let (front, score : back         ) = splitAt playerNum scores
      (_    , marbleToBeRemoved : _) = case elemIndex currentMarble marbles of
        Just i  -> splitAt (counterClockwise (length marbles) i 7) marbles
        Nothing -> ([], marbles)
  in  front ++ (score + newMarble + marbleToBeRemoved : back)

placeMarble :: [Marble] -> Marble -> Marble -> [Marble]
placeMarble marbles marble currentMarble =
  let (front, back) = case elemIndex currentMarble marbles of
        Just i  -> splitAt (clockwise (length marbles) i 1 + 1) marbles
        Nothing -> ([], marbles)
  in  front ++ (marble : back)

removeMarble :: [Marble] -> Marble -> ([Marble], Marble)
removeMarble marbles currentMarble =
  let (front, _ : back) = case elemIndex currentMarble marbles of
        Just i  -> splitAt (counterClockwise (length marbles) i 7) marbles
        Nothing -> ([], marbles)
  in  (front ++ back, if not $ null back then head back else head front)

counterClockwise :: Int -> Int -> Int -> Int
counterClockwise count i distance = (i + count - distance) `mod` count

clockwise :: Int -> Int -> Int -> Int
clockwise count i distance = (i + distance) `mod` count

-------------------------------------------------------
-------- Tests ----------------------------------------
-------------------------------------------------------

tests :: IO ()
tests = do
  testCalculateHighScore
  testPlaceMarble
  testRemoveMarble
  testCounterClockwise
  testClockwise
  testAddScore

testEq :: (Eq a, Show a) => a -> a -> IO ()
testEq a b = putStrLn $ show a ++ " == " ++ show b ++ ": " ++ show (a == b)

testCalculateHighScore :: IO ()
testCalculateHighScore = do
  testEq (calculateHighScore 9 25)    32
  testEq (calculateHighScore 10 1618) 8317
  testEq (calculateHighScore 13 7999) 146373
  testEq (calculateHighScore 17 1104) 2764
  testEq (calculateHighScore 21 6111) 54718
  testEq (calculateHighScore 30 5807) 37305

testPlaceMarble :: IO ()
testPlaceMarble = do
  testEq (placeMarble [0] 1 0)             [0, 1]
  testEq (placeMarble [0, 1] 2 1)          [0, 2, 1]
  testEq (placeMarble [0, 2, 1] 3 2)       [0, 2, 1, 3]
  testEq (placeMarble [0, 2, 1, 3] 4 3)    [0, 4, 2, 1, 3]
  testEq (placeMarble [0, 4, 2, 1, 3] 5 4) [0, 4, 2, 5, 1, 3]

testRemoveMarble :: IO ()
testRemoveMarble = testEq
  (removeMarble
    [ 0
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
    ]
    22
  )
  ( [ 0
    , 16
    , 8
    , 17
    , 4
    , 18
    , 19
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
    ]
  , 19
  )

testCounterClockwise :: IO ()
testCounterClockwise = do
  testEq (counterClockwise 4 3 1) 2
  testEq (counterClockwise 4 3 2) 1
  testEq (counterClockwise 4 3 3) 0
  testEq (counterClockwise 4 3 4) 3

testClockwise :: IO ()
testClockwise = do
  testEq (clockwise 4 3 1) 0
  testEq (clockwise 4 3 2) 1
  testEq (clockwise 4 3 3) 2
  testEq (clockwise 4 3 4) 3

testAddScore :: IO ()
testAddScore = testEq
  (addScore
    [ 0
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
    ]
    22
    23
    (replicate 9 0)
    4
  )
  [0, 0, 0, 0, 32, 0, 0, 0, 0]
