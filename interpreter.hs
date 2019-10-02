import Control.Applicative
import Data.Char
import System.IO
import Control.Monad.State

type Parser a = State String a

takePrefix :: String -> String -> Maybe String
takePrefix [] t = Just t
takePrefix (s : ss) (t : tt) | s == t = takePrefix ss tt
                             | otherwise = Nothing

character :: Parser Char
character = do
  ccs <- get
  case ccs of
    [] -> error "End of input"
    c : cs -> do
      put cs
      return c

theChar :: Char -> Parser ()
theChar a = do
  ccs <- get
  case ccs of
    [] -> error "End of input"
    c : cs -> do
      put cs
      unless (a == c) $ error ("Expecting '" ++ [a] ++ "'")

theString :: String -> Parser ()
theString [] = return ()
theString (s : ss) = theChar s >> theString ss

peekChar :: Parser Char
peekChar = head <$> get

peekString :: String -> Parser Bool
peekString [] = return True
peekString s = do
  t <- get
  case takePrefix s t of
    Nothing -> return False
    Just t' -> put t' >> return True

data Determiner = A | An | Another | YetAnother deriving Show

peekDeterminer :: Parser (Maybe Determiner)
peekDeterminer = peekDict [("a ", A), ("an ", An), ("another ", Another), ("yet another ", YetAnother)]

peekSpecial :: Parser (Maybe Char)
peekSpecial = peekDict [("comma", ','), ("hyphen", '-'), ("space", ' ')]

peekDict :: [(String, a)] -> Parser (Maybe a)
peekDict [] = return Nothing
peekDict ((n, d) : ds) = do
  u <- peekString n
  if u
    then return (Just d)
    else peekDict ds

getLetter :: Parser Char
getLetter = do
  d <- peekDeterminer
  case d of
    Nothing -> error "Expecting a determiner"
    Just d -> do
      u <- peekString "upper-case "
      if u
        then getUpperCaseLetter
        else getOtherChar

getUpperCaseLetter :: Parser Char
getUpperCaseLetter = toUpper <$> character

getOtherChar :: Parser Char
getOtherChar = do
  u <- peekSpecial
  case u of
    Just u -> return u
    Nothing -> getOtherLetter

getOtherLetter :: Parser Char
getOtherLetter = toLower <$> character

spaces :: Parser ()
spaces = do
  theChar ' '
  u <- peekChar
  if u == ' '
    then spaces
    else return ()

getLetters :: Parser String
getLetters = 
  (:) <$> getLetter <*> (theChar ',' *> spaces *> peekString "followed by " *> getLetters)

header = "This infinitely long tweet begins with an upper-case T followed by " 

tweet :: Parser String
tweet = 
  theString header *> (('T' :) <$> getLetters)

main = do
  s <- getContents
  putStrLn $ evalState tweet s
