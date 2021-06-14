import XMonad
import XMonad.Config.Desktop
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.NamedScratchpad
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Layout.ResizableTile
-- Simple two pane layout.
import XMonad.Layout.TwoPane
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Dwindle
import XMonad.Actions.WindowGo
import XMonad.Util.Paste (sendKey)
import XMonad.Actions.PerWindowKeys
import XMonad.Actions.CycleWS (toggleOrDoSkip)
import XMonad.Actions.SpawnOn(manageSpawn)
import XMonad.Util.SpawnOnce (spawnOnce, spawnOnOnce)
import XMonad.Hooks.ManageHelpers (isDialog, doCenterFloat, transience')
import System.Exit
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt (confirmPrompt)
import XMonad.Actions.CopyWindow
import XMonad.Operations
import XMonad.Layout.LayoutHints
import XMonad.Layout.ThreeColumns (ThreeCol(ThreeColMid))
import XMonad.Layout.CenteredMaster
import MiddleColumn
import XMonad.Layout.SimpleFloat
import XMonad.Layout.PerWorkspace (onWorkspace)

baseConfig = desktopConfig

main = do
    xmonad $ ewmhFullscreen $ baseConfig -- ewmh from desktopConfig
        { terminal = "kitty"
        , modMask  = mod4Mask
        , focusFollowsMouse = False
        --, clickJustFocuses = True
        , borderWidth = 0
        , startupHook = startupHook baseConfig <+> myStartupHook -- add EZ checkkeys?
        , workspaces = myWorkspaces
        , logHook = myLogHook
        , layoutHook = desktopLayoutModifiers $ mySpacing $ myLayout
        , manageHook = manageHook baseConfig <+> manageSpawn <+> myManageHook
        }
        `additionalKeysP` myKeys

myKeys = [ ("M-t", namedScratchpadAction scratchpads "term"),
           ("M-m", namedScratchpadAction scratchpads "element"),
           ("M-n", namedScratchpadAction scratchpads "signal"),
           ("M-e", runOrRaiseNext "emacs" (className =? "Emacs")),
           ("M-f", runOrRaiseNext "firefox" (className =? "firefox")),
           ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +2.5%"),
           ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -2.5%"),
           ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle"),
           ("M-S-q", confirmPrompt myXPConfig "exit" (io exitSuccess)),
           ("M-S-t", withFocused $ windows . W.sink),
           ("M-S-h", sendMessage MirrorShrink),
           ("M-S-l", sendMessage MirrorExpand),
           -- Window Copying Bindings
           ("M-S-a", windows copyToAll), -- Pin to all workspaces
           ("M-C-a", killAllOtherCopies), -- remove window from all but current
           ("M-S-c", kill1), -- remove window from current, kill if only one
           ("M-a", withFocused centerWindow),
           ("M-S-f", sendMessage $ JumpToLayout "Full"),
           ("M-d", spawn "exec rofi -show run"),
           ("M-p", spawn "exec rofi-pass"),
           ("M-c", spawn "exec rofi -show calc -modi calc -no-show-match -no-sort > /dev/null") ] ++
         --("C-v", viewTest) ]
         [ (otherModMasks ++ "M-" ++ [key], action tag)
           | (tag, key)  <- zip myWorkspaces "123456"
           , (otherModMasks, action) <- [ ("", toggleOrDoSkip ["NSP"] W.greedyView)
                                          , ("S-", windows . W.shift)]
         ]
      -- where
      --   viewTest :: X ()
      --   viewTest =
      --     withFocused $ \w -> do
      --       b <- isBrowser w
      --       if b
      --         then (sendKey noModMask xK_KP_Page_Down) --(spawn "xdotool key Page_Down")
      --         else (spawn "xdotool type --clearmodifiers -delay 0 'test'")--(spawn "xvkbd -text '\\[Page_Up]'")--(spawn "xdotool keyup --delay 80 ctrl+y && xdotool key --delay 80 ctrl+v") --(sendKey controlMask xK_v)
        
      --   isBrowser :: Window -> X Bool
      --   isBrowser =
      --     fmap (== "firefox") . runQuery className

centerWindow :: Window -> X ()
centerWindow win = do
  (_, W.RationalRect x y w h) <- floatLocation win
  windows $ W.float win (W.RationalRect ((1 - w) / 2) ((1 - h) / 2) w h)
  return ()

myWorkspaces = ["fire","school","code","term","photo","steam"]

-- filter out the scratchpad workspace from polybar xworkspaces
myLogHook = ewmhDesktopsLogHookCustom namedScratchpadFilterOutWorkspace

myStartupHook :: X ()
myStartupHook = composeAll
  [ spawnOnce "dex -ae xmonad" -- use dex for autostart .desktop entries
  , spawnOnce "udiskie --tray"
  , spawnOnce "xscreensaver -no-splash"
  , spawnOnce "blueshift-tray -c ~/blueshift.conf"
  , spawnOnce "$HOME/.config/polybar/launch.sh"
  , spawnOnce "picom --experimental-backends -b"
    -- xiccd seems to not fully load(?) X atom ICC profile, so do this also
    -- but doesn't seem to work (need to wait for xiccd first?), and end up
    -- running it again after startup
  , spawnOnce "sleep 3; dispwin -L"
  , spawnOnOnce "term" "kitty zsh -c \"journalctl -fb\""
  , spawnOnOnce "term" "sleep 0.5; kitty zsh -c htop"
  , spawnOnOnce "term" "sleep 1; kitty" ]

myManageHook = composeAll
  [ namedScratchpadManageHook scratchpads
  , className =? "qv4l2" --> doCenterFloat
  , className =? "zoom" --> doFloat
  , title =? "Picture-in-Picture" --> doFloat
  , isDialog --> doCenterFloat
  -- move transient windows like dialogs/alerts on top of their parents
  , transience' ]

-- myLayout = gaps [(U,18), (R,23)] $ Tall 1 (3/100) (1/2) ||| Full  -- leave gaps at the top and right

defaultThreeColumn :: (Float, Float, Float)
defaultThreeColumn = (0.25, 0.5, 0.25)

myLayout = onWorkspace "steam" simpleFloat $ layoutHintsWithPlacement (0.5, 0.5) -- or use layoutHintsToCenter to reduce gaps
           (tiled
           -- ||| Mirror tiled
           ||| twopane
           -- ||| Mirror twopane
           ||| getMiddleColumnSaneDefault 1 0.5 defaultThreeColumn
           ||| centerMaster twopane
           ||| ThreeColMid 1 (3/100) (1/2)
           ||| emptyBSP
           ||| Spiral R XMonad.Layout.Dwindle.CW (3/2) (11/10) -- R means the non-main windows are put to the right
           ||| ResizableTall 1 (3/100) (1/2) []
           ||| Full)  -- leave gaps at the top and right

  where
     -- The last parameter is fraction to multiply the slave window heights
     -- with. Useless here.
     tiled = spacing 3 $ ResizableTall nmaster delta ratio []
     -- In this layout the second pane will only show the focused window.
     twopane = spacing 3 $ TwoPane delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 2/100

mySpacing = spacingRaw True             -- Only for >1 window
                       -- The bottom edge seems to look narrower than it is
                       (Border 0 15 10 10) -- Size of screen edge gaps
                       True             -- Enable screen edge gaps
                       (Border 10 10 10 10) -- Size of window gaps
                       True             -- Enable window gaps

-- myLayout = avoidStruts $ mySpacing

-- scratchPads
scratchpads :: [NamedScratchpad]
scratchpads = [
    NS "term" "kitty --title=termscratch" (title =? "termscratch")
        (customFloating $ W.RationalRect (1/3) (1/4) (1/3) (1/2)),

    NS "element" "element-desktop" (className =? "Element")
        (customFloating $ W.RationalRect (1/3) (1/4) (1/3) (1/2)),

    NS "signal" "signal-desktop --use-tray-icon" (className =? "Signal")
        (customFloating $ W.RationalRect (3/5) (4/6) (1/5) (1/6)),

    NS "pavucontrol" "pavucontrol" (className =? "Pavucontrol")
        (customFloating $ W.RationalRect (1/4) (1/4) (2/4) (2/4))
  ]

-- | Customize the way 'XMonad.Prompt' looks and behaves.  It's a
-- great replacement for dzen.
myXPConfig :: XPConfig
myXPConfig = def
  { position          = CenteredAt 0.5 0.5
  , alwaysHighlight   = True
  , promptBorderWidth = 0
  , font              = "xft:monospace:size=15"
  }
