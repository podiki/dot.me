;; For StumpWM
(use-modules (guix transformations))

(define transform1
  (options->transformation
    '((with-git-url
        .
        "stumwpm=https://github.com/stumpwm/stumpwm"))))

(concatenate-manifests
 (list
  (packages->manifest
  (list (transform1 (specification->package "stumpwm"))
        (list (transform1 (specification->package "stumpwm"))
              "lib")))
  (specifications->manifest
   '("sbcl"
     "sbcl-slime-swank"
     "sbcl-alexandria"
     "sbcl-anaphora"
     "xsetroot"
     ;"stumpwm"
     ;"stumpwm:lib"
     "sbcl-stumpwm-swm-gaps"
     "sbcl-stumpwm-ttf-fonts"))))
