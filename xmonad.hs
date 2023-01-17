import XMonad

import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive

myLayout = avoidStruts $ tiled ||| Mirror tiled ||| noBorders Full
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1      -- Default number of windows in the master pane
    ratio   = 1/2    -- Default proportion of screen occupied by master pane
    delta   = 3/100  -- Percent of screen to increment by when resizing panes

myManageHook :: ManageHook
myManageHook = composeAll
  [ isDialog  --> doFloat ]

myLogHook :: X ()
myLogHook = fadeInactiveLogHook 0.85

main :: IO()
main = xmonad $ ewmhFullscreen $ ewmh $ docks $ myConfig

myConfig = def
  { terminal    = "kitty"
  , modMask     = mod4Mask
  , layoutHook  = myLayout
  , manageHook  = myManageHook
  , logHook     = myLogHook
  , borderWidth = 0
  }
  `additionalKeysP`
  [ ("M-p",   spawn "rofi -show combi")
  , ("M-S-f", spawn "rofi -show filebrowser")
  -- Media keys
  , ("<XF86AudioMute>",         spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle") 
  , ("<XF86AudioRaiseVolume>",  spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
  , ("<XF86AudioLowerVolume>",  spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
  -- Brightness
  , ("<XF86MonBrightnessUp>",   spawn "light -A 10")
  , ("<XF86MonBrightnessDown>", spawn "light -U 10")
  ]
