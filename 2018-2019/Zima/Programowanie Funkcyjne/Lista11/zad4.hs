import System.IO

main = play [4,7,3,4,2] ["Gracz","Komputer"]

play::[Int] -> [String] -> IO()
play board players = do
  (newBoard,winner) <- take_turns board players
  if null winner
    then play newBoard players
    else do putStrLn (winner ++ " wygral!")
            return ()

take_turns::[Int] -> [String] -> IO ([Int],String)
take_turns board [] = return (board,[])
take_turns board (player:players) = do
  newBoard <- take_turn board player
  if sum newBoard == 0
    then return (newBoard,player)
    else take_turns newBoard players

take_turn::[Int] -> String -> IO [Int]
take_turn board player = do
  putStrLn ("\n" ++ "Tura: " ++ player)
  display_board board
  if player == "Player"
    then do
      row   <- get_row board
      stars <- get_int "Ile gwiazdek?" 1 (board!!row)
      return (replace_nth board row (board!!row - stars))
    else do
      row   <- return (find_first board)
      stars <- return 1
      return (replace_nth board row (board!!row - stars))
get_row::[Int] -> IO Int
get_row board = do
  row <- get_int "Ktory wiersz?" 1 (length board)
  if board!!(row-1) == 0
    then do putStrLn "Ten jest pusty"
            get_row board
    else return (row-1)

get_int::String -> Int -> Int -> IO Int
get_int msg lowest highest = do
  putStrLn msg
  input <- getLine
  let parsed = read input :: Int
  if parsed < lowest
    then badNumber "Za mala liczba"
    else if parsed > highest
      then badNumber "Za duza liczba"
      else return parsed
  where badNumber err = do putStrLn err
                           get_int msg lowest highest

display_board::[Int] -> IO()
display_board [] = return ()
display_board board = do
  putStrLn $ show (length board) ++ ":" ++ replicate (last board) '*'
  display_board (init board)
replace_nth::[Int] -> Int -> Int -> [Int]
replace_nth [] _ _ = []
replace_nth (x:xs) n new
  | n == 0 = new:xs
  | otherwise = x:(replace_nth xs (n-1) new)
find_first::[Int] -> Int
find_first (x:xs) = if x /= 0 then 0 else 1 + find_first xs
