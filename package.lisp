(defpackage :phlo
  (:use :common-lisp) ; :bind :toolbox)  ???
  (:shadow position vector)) ; grrrrr



;(defpackage #:phlo
;  (:shadowing-import-from common-lisp position vector)
;  (:export #:main)
;  (:use common-lisp
;        #:phlo-ffi-ftgl
;        #:phlo-foundation))


;(defpackage #:phlo-foundation
;  (:shadow position vector)
;  (:export #:box name position rotation vector size
;           #:fwoozle)
;  (:use common-lisp))  
;(in-package #:phlo-foundation)

