module Main where

sums = (sum [1..100])^2
sqrs = sum [x^2 | x <- [1..100]]
findSum = sums - sqrs

main = print (findSum)
