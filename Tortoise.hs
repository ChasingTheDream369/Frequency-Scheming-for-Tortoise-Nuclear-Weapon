module Tortoise where

import Data.Semigroup
import Data.List
import Test.QuickCheck

-- data type definitions

data Freq = Freq Int deriving (Show, Eq, Ord)
data Interval = Interval Int deriving (Eq, Ord)

type Count = Integer
data Histogram = Histogram [(Interval, Count)] deriving (Show, Eq)

data SigCard =
  SigCard {
    refHistogram :: Histogram,
    excluded :: [Interval]
  } deriving (Show, Eq)

data Verdict = RealWeapon | Dud deriving (Show, Eq)

-- helper functions
freq :: Int -> Freq
freq x = (Freq x)

interval :: Int -> Interval
interval x = (Interval x)

notImpl :: String -> a
notImpl x = error $ "'" ++ x ++ "'" ++ " not defined"

startPoint :: Interval -> Freq
startPoint (Interval x) = Freq (100*x)

startPointInt :: Interval -> Int
startPointInt (Interval x) = 100*x


endPoint :: Interval -> Freq
endPoint (Interval x) = Freq (100*x + 100)

endPointInt :: Interval -> Int
endPointInt (Interval x) = (100*x + 100)

-- ASSIGNMENT STARTS HERE --

-- Problem 1

inside :: Freq -> Interval -> Bool
inside (Freq x) r = (x >= (startPointInt r) && x < (endPointInt r))

 
instance Show Interval where
  show (r) = (show (startPointInt r))  ++ " to " ++ (show (endPointInt r))  

intervalOf :: Freq -> Interval
intervalOf (Freq x) = Interval (x `div` 100) 

instance Arbitrary Freq where
  arbitrary = freq <$> arbitrary

instance Arbitrary Interval where
  arbitrary = interval <$> arbitrary
  
getFreqInt :: Freq -> Int
getFreqInt (Freq x) = x

prop_inIntervalOf :: Freq -> Bool
prop_inIntervalOf (Freq x) = (x >= (startPointInt r) && x < (endPointInt r)) where r = (intervalOf (Freq x))

prop_inOneInterval :: Freq -> Interval -> Property
prop_inOneInterval (Freq x) (Interval y) = x > 0 && y == (x `div` 100) ==> 
              y == z where (Interval z) = (intervalOf (Freq x))  

-- Problem 2
sortHistogram :: [(Interval, Count)] -> [(Interval, Count)]  
sortHistogram xs = (sortBy (\(a,_) (b, _) -> compare a b) xs)

nubHistogram :: [(Interval, Count)] -> [(Interval, Count)]
nubHistogram xs = nubBy (\(a,_) (b,_) -> a == b) xs

remHistogram :: [(Interval, Count)] -> [(Interval, Count)]
remHistogram xs = filter (\(i,j) -> j > 0) xs

histogram :: [(Interval, Count)] -> Histogram
histogram xs = Histogram (remHistogram (nubHistogram (sortHistogram xs)))

instance Arbitrary Histogram where
    arbitrary = histogram <$> arbitrary

prop_histogram1 :: Histogram -> Bool
prop_histogram1 (Histogram hs) = (hs == sortHistogram hs)

prop_histogram2 :: Histogram -> Bool
prop_histogram2 (Histogram hs) = (hs == nubHistogram hs)

prop_histogram3 :: Histogram -> Bool
prop_histogram3 (Histogram hs) = (hs == remHistogram hs)

-- Problem 3
-- Used this link : https://stackoverflow.com/questions/70722973/count-the-number-of-occurences-of-each-element-and-return-them-as-a-list-of-tupl 
-- as an insipration for creating the solution below.

elemFreqByFirstOcc :: Eq a => [a] -> [(a, Count)]
elemFreqByFirstOcc [] = []
elemFreqByFirstOcc (x:xs) = (x, toInteger (length (filter (x ==) xs) + 1)) : elemFreqByFirstOcc (filter (x /=) xs)

mapInterval :: [Freq] -> [Interval]
mapInterval xs = map (\x -> (intervalOf x)) xs

process :: [Freq] -> Histogram
process xs = histogram (elemFreqByFirstOcc (mapInterval (xs)))

findInterval :: Int -> [(Interval, Count)] -> Count
findInterval = \elem -> \myList ->
  case myList of
    [] -> -1 -- if all elements checked, return False
    (Interval y, c):xs | y == elem -> c -- If head matches elem, return True
    _:xs -> findInterval elem xs -- Check for element membership in remaining list

mergeHist :: [(Interval, Count)] -> [(Interval, Count)] -> [(Interval, Count)]
mergeHist [] ys = []
mergeHist ((Interval x, f):xs) ys = case (findInterval x ys) of 
                                      -1 -> (Interval x, f): mergeHist xs ys
                                      c -> (Interval x, f + c) : mergeHist xs ys 
                                                          
                                                                

merge :: Histogram -> Histogram -> Histogram
merge (Histogram x) (Histogram y) = (histogram (mergeHist x y ++ mergeHist y x))

prop_mergeAssoc :: Histogram -> Histogram -> Histogram -> Bool
prop_mergeAssoc x y z = (x <> y) <> z == x <> (y <> z)   

prop_mergeId :: Histogram -> Bool
prop_mergeId x = (x <> mempty == x) && (mempty <> x == x) 

prop_mergeComm :: Histogram -> Histogram -> Bool
prop_mergeComm x y = (x <> y) == (y <> x)

instance Semigroup Histogram where
  (<>) = merge

instance Monoid Histogram where
  mappend = merge
  mempty = histogram []

-- Problem 4

report_refl :: Maybe Histogram
report_refl = Nothing

report_symm :: Maybe (Histogram, Histogram)
report_symm = Nothing

report_tran :: Maybe (Histogram, Histogram, Histogram)
report_tran = Just (histogram [(Interval 0, 2)], histogram [(Interval 0, 30)], histogram [(Interval 0, 50)])

-- Inspector O'Hare implemented match as follows:
match :: Histogram -> SigCard -> Verdict
match (Histogram h) (SigCard (Histogram r) v) =
  if d < 32 then RealWeapon else Dud where
    grab r (Histogram hs) = case filter (\x -> fst x == r) hs of
      [(_,x)] -> x
      _       -> 0
    squareDist (Histogram h1) (Histogram h2) = sum squares where
      common = sort . nub $ map fst h1 ++ map fst h2
      squares =
        map (\x -> (fromIntegral $ grab x (Histogram h1) - grab x (Histogram h2))**2)
            common
    d1 = squareDist (Histogram h) (Histogram r)
    h' = Histogram $ filter (\x -> fst x `elem` v) h
    r' = Histogram $ filter (\x -> fst x `elem` v) r
    d2 = squareDist h' r'
    d = sqrt (d1 - d2)

-- Use this reference card to find a false positive for `match`
refCard :: SigCard
refCard = SigCard (histogram r) v where
  r = [(Interval 4, 4000), (Interval 5, 6000), (Interval 6,300)]
  v = [Interval 5]
