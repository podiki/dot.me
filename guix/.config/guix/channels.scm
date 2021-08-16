(cons* (channel
        (name 'nonguix)
        (url "https://gitlab.com/nonguix/nonguix")
        ;; Enable signature verification:
        (introduction
         (make-channel-introduction
          "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
          (openpgp-fingerprint
           "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
       (channel
        (name 'guix-pod)
        (url "file:///home/john/codemonkey/guix-pod")
        (branch "main"))
       (channel
        (name 'flat)
        (url "https://github.com/flatwhatson/guix-channel.git")
        (introduction
         (make-channel-introduction
          "33f86a4b48205c0dc19d7c036c85393f0766f806"
          (openpgp-fingerprint
           "736A C00E 1254 378B A982  7AF6 9DBE 8265 81B6 4490"))))
       (channel
          (name 'pkill9-free)
          (url "https://gitlab.com/pkill-9/guix-packages-free"))
       %default-channels)
