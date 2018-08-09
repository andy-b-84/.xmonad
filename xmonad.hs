-- default desktop configuration for Fedora

import System.Posix.Env (getEnv)
import Data.Maybe (maybe)

import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Config.Xfce
import XMonad.Config.Azerty
import qualified Data.Map as M
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders (noBorders)
import Graphics.X11.ExtraTypes.XF86

main = do
  session <- getEnv "DESKTOP_SESSION"
  xmonad ( maybe desktopConfig desktop session ) { 
    terminal    = "xterm -bg black -fg lightgrey",
    modMask     = mod4Mask,
    keys        = \c -> myAzertyKeys c <+> keys desktopConfig c,
    startupHook = setWMName "LG3D",
    layoutHook  = noBorders $ layout
  }

layout = tiled ||| Mirror tiled ||| Full
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 2
    ratio   = 1/2
    delta   = 3/100

myAzertyKeys x = M.union (myKeys x) (azertyKeys x)
myKeys x = M.union (M.fromList (newKeys x)) (keys def x) 
newKeys (XConfig {XMonad.modMask = modm}) = [
      ((mod4Mask, xK_l            ), spawn "slock")
    , ((mod4Mask, xK_g            ), sendMessage Expand)
    , ((0, xF86XK_AudioMute       ), spawn "amixer set Master toggle")
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master -")
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master +")
  ]  
     
desktop "gnome" = gnomeConfig
desktop "xfce" = xfceConfig
desktop "xmonad-mate" = gnomeConfig
desktop _ = desktopConfig
