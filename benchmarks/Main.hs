module Main where

import Gauge.Main

import Algo.MutableSet (mutableSet)
import Algo.ListRank   (listRank)
import Algo.Rootfix    (rootfix)
import Algo.Leaffix    (leaffix)
import Algo.AwShCC     (awshcc)
import Algo.HybCC      (hybcc)
import Algo.Quickhull  (quickhull)
import Algo.Spectral   (spectral)
import Algo.Tridiag    (tridiag)

import TestData.ParenTree (parenTree)
import TestData.Graph     (randomGraph)

import qualified Data.Vector.Mutable as MV
import qualified Data.Vector.Unboxed as U
import Data.Word
import System.Random.Stateful

useSize :: Int
useSize = 2000000

useSeed :: Int
useSeed = 42

main :: IO ()
main = do
  gen <- newIOGenM (mkStdGen useSeed)

  let (lparens, rparens) = parenTree useSize
  (nodes, edges1, edges2) <- randomGraph gen useSize
  lparens `seq` rparens `seq` nodes `seq` edges1 `seq` edges2 `seq` return ()

  let randomVector l = U.replicateM l (uniformDoublePositive01M gen)
  as <- randomVector useSize
  bs <- randomVector useSize
  cs <- randomVector useSize
  ds <- randomVector useSize
  sp <- randomVector (floor $ sqrt $ fromIntegral useSize)
  as `seq` bs `seq` cs `seq` ds `seq` sp `seq` return ()

  vi <- MV.new useSize

  defaultMain
    [ bench "listRank"   $ whnf listRank useSize
    , bench "rootfix"    $ whnf rootfix (lparens, rparens)
    , bench "leaffix"    $ whnf leaffix (lparens, rparens)
    , bench "awshcc"     $ whnf awshcc (nodes, edges1, edges2)
    , bench "hybcc"      $ whnf hybcc  (nodes, edges1, edges2)
    , bench "quickhull"  $ whnf quickhull (as,bs)
    , bench "spectral"   $ whnf spectral sp
    , bench "tridiag"    $ whnf tridiag (as,bs,cs,ds)
    , bench "mutableSet" $ nfIO $ mutableSet vi
    ]
