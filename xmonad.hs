-- default desktop configuration for Fedora

import System.Posix.Env (getEnv)
import Data.Maybe (maybe)

import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Config.Xfce
import XMonad.Config.Azerty
import XMonad.Hooks.SetWMName

main = do
  session <- getEnv "DESKTOP_SESSION"
  xmonad ( maybe desktopConfig desktop session ) { 
    terminal    = "xterm -bg black -fg lightgrey",
    modMask     = mod4Mask,
    keys        = \c -> azertyKeys c <+> keys desktopConfig c,
    startupHook = setWMName "LG3D"
  }
     
desktop "gnome" = gnomeConfig
desktop "xfce" = xfceConfig
desktop "xmonad-mate" = gnomeConfig
desktop _ = desktopConfig
