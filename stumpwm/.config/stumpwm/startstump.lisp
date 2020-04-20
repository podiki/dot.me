(require :stumpwm)
(require :swank)

;;==============================================================================
;; swank setup
;;==============================================================================
(swank-loader:init)
(swank:create-server :port 4004
                     :style swank:*communication-style*
                     :dont-close t)

;; start stumpwm
(stumpwm:stumpwm)
