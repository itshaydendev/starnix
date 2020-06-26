-- Imports ---------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Core ------------------------------------------------------------------------
import XMonad -- core libraries
import System.Exit (exitSuccess)

-- Hooks -----------------------------------------------------------------------
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog

-- Utilities -------------------------------------------------------------------
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Config.Desktop

-- Config Vars -----------------------------------------------------------------

myTerminal :: String
myTerminal = "alacritty"

myWorkspaces :: [String]
myWorkspaces = 
  [ "1:web", "2:dv1", "3:dv2",
    "4:dv3", "5:sys", "6:ct1",
    "7:ct2", "8:mus", "9:msc",
    "0:ms2", "-",     "="     
  ]

myModMask :: KeyMask
myModMask = mod4Mask

myBrowser :: String
myBrowser = "firefox"

myLauncher :: String
myLauncher = "rofi -show drun -lines 4"

myBorderWidth :: Dimension
myBorderWidth = 2
myBorderColor :: String
myBorderColor = "#111111"
myBorderActiveColor :: String
myBorderActiveColor = "#9c71C7"

-- Polybar ---------------------------------------------------------------------

wsOutput wsStr = do
  io $ appendFile "/tmp/.xmonad-workspace-log" (wsStr ++ "\n")

polybarPP = dynamicLogWithPP $ def {
  ppCurrent = wrap ("%{F#9C71C7}[%{F-}%{F#BEB3CD}") "%{F-}%{F#9C71C7}]%{F-}"
  , ppHidden = wrap ("%{F" ++ "#BEB3CD" ++ "} ") " %{F-}"
  , ppHiddenNoWindows = wrap ("%{F" ++ "#6B5A68" ++ "} ") " %{F-}"
  , ppUrgent = wrap ("%{F#8c414f}<%{F-}%{F#BEB3CD}") "%{F-}%{F#8c414f}>%{F-}"
  , ppSep = "  "
  , ppLayout = wrap ("%{F#9c71C7}") "%{F-}"
  , ppTitle = (\str -> "")
  -- , ppSort = fmap (.namedScratchpadFilterOutWorkspace) $ ppSort defaultPP
  , ppOutput = wsOutput
  }

-- Autostart -------------------------------------------------------------------

setFullscreenSupport :: X ()
setFullscreenSupport = withDisplay $ \dpy -> do
    r <- asks theRoot
    a <- getAtom "_NET_SUPPORTED"
    c <- getAtom "ATOM"
    supp <- mapM getAtom ["_NET_WM_STATE_HIDDEN"
                         ,"_NET_WM_STATE_FULLSCREEN" -- XXX Copy-pasted to add this line
                         ,"_NET_NUMBER_OF_DESKTOPS"
                         ,"_NET_CLIENT_LIST"
                         ,"_NET_CLIENT_LIST_STACKING"
                         ,"_NET_CURRENT_DESKTOP"
                         ,"_NET_DESKTOP_NAMES"
                         ,"_NET_ACTIVE_WINDOW"
                         ,"_NET_WM_DESKTOP"
                         ,"_NET_WM_STRUT"
                         ]
    io $ changeProperty32 dpy r a c propModeReplace (fmap fromIntegral supp)

myStartupHook :: X ()
myStartupHook = do
  spawn "feh --bg-fill --no-fehbg ~/.wallpaper"
  spawn "picom &"
  spawn "dunst &"
  spawn "sh ~/.config/polybar/launch.sh &"
  spawn "lxqt-policykit-agent"
  spawn "pkill dunst; dunst &"
  spawn "xsetroot -cursor_name left_ptr"
  setFullscreenSupport

-- Manage Hook -----------------------------------------------------------------

myManageHook = composeAll
  [ className =? "Pavucontrol" --> doFloat
  , manageDocks
  ]

-- Keybinds --------------------------------------------------------------------

spotDbusSend :: String
spotDbusSend = "dbus-send --type=method_call --dest=org.mpris.MediaPlayer2.spotify org.mpris.MediaPlayer2.Player."

myKeys :: [(String, X ())]
myKeys =
  -- Xmonad
  [ ("M-C-r", spawn "xmonad --recompile") -- Recompile config
  , ("M-S-r", spawn "xmonad --restart")   -- Restart WM
  , ("M-S-q", io exitSuccess)             -- Quit xmonad

  -- Open my terminal
  , ("M-<Return>", spawn myTerminal)

  -- App Launchers
  , ("M-p", spawn myLauncher) -- Rofi
  , ("<Print>", spawn "flameshot gui")

  -- Multimedia
  , ("<XF86AudioPlay>", spawn (spotDbusSend ++ "PlayPause"))
  , ("<XF86AudioNext>", spawn (spotDbusSend ++ "Next"))
  , ("<XF86AudioPrev>", spawn (spotDbusSend ++ "Previous"))
  , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -10%")
  , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +10%")
  , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
  , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 10")
  , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 10")
  ]

-- Entrypoint ------------------------------------------------------------------

main :: IO ()
main = xmonad $ myConfig

myConfig = desktopConfig
  { modMask = myModMask
  , borderWidth = myBorderWidth
  , normalBorderColor = myBorderColor
  , focusedBorderColor = myBorderActiveColor
  , terminal = myTerminal
  , workspaces = myWorkspaces
  , manageHook = myManageHook <+> manageHook desktopConfig

  , startupHook = myStartupHook
  , logHook = polybarPP
  } `additionalKeysP` myKeys