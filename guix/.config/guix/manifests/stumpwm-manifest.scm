;; For StumpWM
(use-modules (guix transformations))

(define transform1
  (options->transformation
    '((with-git-url
        .
        "stumpwm=https://github.com/stumpwm/stumpwm"))))

(packages->manifest
  (list (transform1 (specification->package "stumpwm"))
        (list (transform1 (specification->package "stumpwm"))
              "lib")
        (transform1
          (specification->package "sbcl-stumpwm-swm-gaps"))
        (transform1
          (specification->package "sbcl-stumpwm-ttf-fonts"))
        (specification->package "sbcl")
        (specification->package "sbcl-slime-swank")
        (specification->package "sbcl-alexandria")
        (specification->package "sbcl-anaphora")
        (specification->package "xsetroot")))
