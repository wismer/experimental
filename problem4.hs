module Main where

nums = reverse [101..999]
start = 999

palin :: (Show a) => a -> Bool
palin x = reverse (show x) == show x

findPalin n x pal
  | n == 101 = findPalin 999 (x - 1) pal
  | palin (n*x) && (n*x) > pal = findPalin (n - 1) x (n*x)
  | x == 101 = pal
  | otherwise = findPalin (n - 1) x pal

main = print (findPalin 999 999 101)
