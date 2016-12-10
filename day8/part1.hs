import qualified Data.Text as Text
import qualified Data.Text.IO as Text
import Text.Regex.Posix

data Instruction = 
    Rect Int Int
    | RotateRow Int Int
    | RotateCol Int Int deriving Show

data LightState = Lit | Unlit
instance Show (LightState) where
  show Lit = "#"
  show Unlit = "."

data Board = Board [[LightState]]
instance Show (Board) where
  show (Board slots) = foldr (\ x y -> (foldr (\ a b -> (show a) ++ b) "" x) ++ "\n" ++ y) "" slots

light _ = Lit
isLit Lit = True
isLit _ = False

widthInCols = 50
heightInRows = 6

initRow :: [LightState]
initRow = map (\x -> Unlit) [1..widthInCols]

initBoard :: Board
initBoard = Board $ map (\x -> initRow) [1..heightInRows]

-- Inefficient, but eh
replaceElem :: [a] -> Int -> a -> [a]
replaceElem lst index el =
    (take index lst) ++ [el] ++ (drop (index + 1) lst)

rotateRow :: Board -> Int -> Int -> Board
rotateRow (Board b) row offset =
    let
        currRow = b !! row
        (newSuffix, newPrefix) = splitAt ((length currRow) - offset) currRow
        newRow = newPrefix  ++ newSuffix
    in
        Board $ replaceElem b row newRow


rotateCol :: Board -> Int -> Int -> Board
rotateCol (Board b) col offset =
    let
        colElems = map (\x -> x !! col) b
        oneBasedOffset = offset + 1
        (newSuffix, newPrefix) = splitAt((length colElems) - offset) colElems
        newColElems = newPrefix ++ newSuffix
    in
        Board $ map (\ (row,newElem) -> replaceElem row col newElem) $ zip b newColElems


paintRect :: Board -> Int -> Int -> Board
paintRect (Board b) width height =
    let
        (rows, remaining) = splitAt height b
        columnFlipper =  (\(affectedCols, unaffected) -> (map light affectedCols) ++ unaffected) . (splitAt width)
        newRows = map columnFlipper rows
    in
        Board $ newRows ++ remaining


performInstruction :: Board -> Instruction -> Board
performInstruction board instr =
    case instr of
        Rect width height -> paintRect board width height
        RotateRow row offset -> rotateRow board row offset
        RotateCol col offset -> rotateCol board col offset


rectRegex = "rect ([0-9]+)x([0-9]+)"
rotateRowRegex = "rotate row y=([0-9]+) by ([0-9]+)"
rotateColRegex = "rotate column x=([0-9]+) by ([0-9]+)"


readInstruction :: String -> Instruction
readInstruction str =
    let
        makeInt x = (read x)::Int
        checks = map (\x -> str =~ x :: [[String]]) [rectRegex, rotateRowRegex, rotateColRegex]
    in
        case checks of
            [[[_, x, y]], [], []] -> Rect (makeInt x) (makeInt y)
            [[], [[_, x, y]], []] -> RotateRow (makeInt x) (makeInt y)
            [[], [], [[_, x, y]]] -> RotateCol (makeInt x) (makeInt y)


countLights (Board b) =
    foldl (\x y -> (length (filter isLit y)) + x) 0 b


main :: IO ()
main = do
    lines <- fmap Text.lines (Text.readFile "input.txt")
    let instructions = map readInstruction $ map Text.unpack lines
    let finalBoard = foldl performInstruction initBoard instructions
    let score = countLights finalBoard
    print finalBoard
    print score
