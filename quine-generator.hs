import Data.Char
import Data.Map as M
import Control.Monad.State

describe :: String -> String
describe s = 
  let d = evalState (describe' (tail s)) M.empty
  in "This infinitely long tweet begins with an upper-case T followed by " ++ d

describe' :: String -> State (M.Map Char Integer) String
describe' (a : as) = do
  occurrences <- get
  let n = M.findWithDefault 0 a occurrences
  modify (M.insert a (n+1))
  let c = description n a ++ ", "
  b <- describe' as
  return $ c ++ b

determiner :: Integer -> Char -> String
determiner n _ | n == 1 = "another"
determiner n _ | n > 1 = "yet another"
determiner n 'a' = "an"
determiner n 'e' = "an"
determiner n 'f' = "an"
determiner n 'h' = "an"
determiner n 'i' = "an"
determiner n 'l' = "an"
determiner n 'm' = "an"
determiner n 'n' = "an"
determiner n 'o' = "an"
determiner n 'r' = "an"
determiner n 's' = "an"
determiner n 'x' = "an"
determiner n _ = "a"

description :: Integer -> Char -> String
description n ' ' = determiner n ' ' ++ " space"
description n ',' = determiner n ',' ++ " comma"
description n '-' = determiner n '-' ++ " hyphen"
description n x | isUpper x = determiner n 'a' ++ " upper-case " ++ [x]
description n x = determiner n x ++ " " ++ [toUpper x]

s :: String
s = describe s

main = do
  putStrLn s
