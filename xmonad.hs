{-# OPTIONS_GHC -Wno-missing-signatures #-}
import XMonad
import XMonad.Util.EZConfig
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.ClickableWorkspaces (clickablePP)

myLayout =  smartSpacingWithEdge 10 $ avoidStruts $ tiled ||| Mirror tiled ||| noBorders Full
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1      -- Default number of windows in the master pane
    ratio   = 1/2    -- Default proportion of screen occupied by master pane
    delta   = 3/100  -- Percent of screen to increment by when resizing panes

mySB = statusBarProp "xmobar" (clickablePP xmobarPP)

myManageHook :: ManageHook
myManageHook = composeAll
  [ isDialog  --> doFloat ]

myLogHook :: X ()
myLogHook = fadeInactiveLogHook 0.85

main :: IO()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . docks
     . withEasySB mySB defToggleStrutsKey
     $ myConfig

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
  , ("M-d",   spawn "rofi -show drun -run-shell-command '{terminal} -e zsh -ic \"{cmd} && read\"'")
  , ("M-g",   do
      toggleWindowSpacingEnabled
      toggleScreenSpacingEnabled
    )
  -- Media keys
  , ("<XF86AudioMute>",         spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle") 
  , ("<XF86AudioRaiseVolume>",  spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
  , ("<XF86AudioLowerVolume>",  spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
  -- Brightness
  , ("<XF86MonBrightnessUp>",   spawn "light -A 10")
  , ("<XF86MonBrightnessDown>", spawn "light -U 10")
  ]
