-- default desktop configuration for Fedora

import System.Posix.Env (getEnv)
import Data.Maybe (maybe)

import Graphics.X11.ExtraTypes.XF86

import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Config.Xfce
import XMonad.Config.Azerty
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Util.Dzen

import qualified XMonad.Layout.IndependentScreens as LIS
import qualified Data.Map as M
-- import qualified XMonad.Util.Brightness as B

main = do
  session <- getEnv "DESKTOP_SESSION"
  xmonad ( maybe desktopConfig desktop session ) { 
    terminal    = "urxvt -bg black -fg lightgrey",
    manageHook  = manageDocks <+> manageHook desktopConfig,
    modMask     = mod4Mask,
    keys        = \c -> myAzertyKeys c <+> keys desktopConfig c,
    startupHook = setWMName "LG3D",
    layoutHook  = avoidStruts $ noBorders $ layout
  }

layout = tiled ||| Mirror tiled ||| Full
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 2
    ratio   = 1/2
    delta   = 3/100

toggledisplay = do
  screencount <- LIS.countScreens
  if screencount > 1
    then spawn "xrandr --output DP-3-1 --off"
    else spawn "~/.screenlayout/taf.sh"

myAzertyKeys x = M.union (myKeys x) (azertyKeys x)
myKeys x = M.union (M.fromList (newKeys x)) (keys def x) 
newKeys (XConfig {XMonad.modMask = modm}) = [
      ((mod4Mask, xK_a               ), spawn "arandr")
    , ((mod4Mask, xK_c               ), spawn "code")
    , ((mod4Mask, xK_f               ), spawn "firefox")
    , ((mod4Mask .|. shiftMask, xK_f ), spawn "firefox -P train")
    , ((mod4Mask, xK_g               ), sendMessage Expand)
    , ((mod4Mask, xK_i               ), spawn "idea")
    , ((mod4Mask, xK_l               ), spawn "slock")
    , ((mod4Mask, xK_o               ), spawn "terminator")
    , ((mod4Mask .|. shiftMask, xK_o ), spawn "terminator -l recette")
    , ((mod4Mask, xK_s               ), spawn "spotify")
    , ((0, xF86XK_Display            ), toggledisplay)
    , ((0, xF86XK_AudioMute          ), spawn "amixer set Master toggle")
    , ((0, xF86XK_AudioLowerVolume   ), spawn "amixer -c 0 set Master 1dB-")
    , ((0, xF86XK_AudioRaiseVolume   ), spawn "amixer -c 0 set Master 1dB+")
--    , ((0, xF86XK_MonBrightnessUp    ), B.increase)
--    , ((0, xF86XK_MonBrightnessDown  ), B.decrease)
  ]  
     
desktop "gnome" = gnomeConfig
desktop "xfce" = xfceConfig
desktop "xmonad-mate" = gnomeConfig
desktop _ = desktopConfig
