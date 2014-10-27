module Main where

isDivisible :: Integral a => a -> Bool
isDivisible x = mod x 3 == 0 || mod x 5 == 0
makeList :: Integral t => [t] -> [t]
makeList xs = [x | x <- xs, isDivisible x]
result = makeList[1..1000]

main = print (sum result)