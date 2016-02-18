import Data.List
import Data.Map (Map)
import qualified Data.Map as Map
import qualified Data.Set as Set
import Control.Applicative
import System.Environment

data Edge = Edge String String
	deriving (Eq, Ord)

edge :: String -> String -> Edge
edge a b
	| a < b     = Edge a b
	| otherwise = Edge b a

edgeToList :: Edge -> [String]
edgeToList (Edge a b) = [a,b]

main :: IO ()
main = do
	args <- getArgs
	let pth = args !! 0
	input <- loadInput pth

	let people1 = uniques (concatMap edgeToList (Map.keys input))
	print (maximumHappiness input people1)

neighbors :: [String] -> [Edge]
neighbors [] = []
neighbors (x:xs) = zipWith edge (x:xs) (xs ++ [x])

maximumHappiness :: Map Edge Int -> [String] -> Int          
maximumHappiness relationships people = maximum (score <$> permutations people)
	where score xs = sum [Map.findWithDefault 0 e relationships | e <- neighbors xs]

loadInput :: String -> IO (Map Edge Int)
loadInput path = Map.fromListWith (+) . map parseLine . lines <$> readFile path

parseLine :: String -> (Edge, Int)
parseLine str =
	case words (filter (/='.') str) of
	[a,"gains",n,b] -> (edge a b,   read n)
	[a,"loses",n,b] -> (edge a b, - read n)
	_ -> error ("Bad input line: " ++ str)

uniques :: Ord a => [a] -> [a]
uniques = Set.toList . Set.fromList
