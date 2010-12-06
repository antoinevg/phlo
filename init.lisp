(in-package #:phlo)

(load "examples/animation.lisp")
(load "examples/ball.lisp")
(load "examples/simple-system.lisp")

; - eden -------------------------------------------------------------------

(defvar *a-box-1* (make-instance 'box :color '(0.6 0.6 1.0 0.75))) 
(setf (slot-value *a-box-1* 'name) "the name of *a-box-1*")
(setf (position   *a-box-1*) '(-25.0 0.0 0.0))
(setf (size       *a-box-1*) '(50.0 50.0 0.0))
(defvar *a-box-2* (make-instance 'box :color '(1.0 0.0 0.0 0.75))) 
(setf (slot-value *a-box-2* 'name) "*a-box-2*")
(setf (position   *a-box-2*) '(25.0 12.5 0.0))
(setf (size       *a-box-2*) '(50.0 25.0 0.0))
(setf (rotation   *a-box-2*) '(50.0 0.0 0.0))
(defvar *a-box-3* (make-instance 'box :name "*a-box-3*" :size '(25.0 25.0 25.0) :color '(0.0 1.0 0.0 0.75))) 
(defvar *a-box-4* (make-instance 'box :name     "*a-box-3*" 
                                       :size     '(50.0 50.0 50.0) 
                                       :position '(0.0 100.0 0.0) ; TODO want be able to pass: '(left bottom middle)
                                       :color    '(0.0 0.0 1.0 0.75))) 
(add-child *a-box-1* *a-box-4*)
(add-child *a-box-3* *a-box-4*)
(add-child *a-box-1* *a-box-3*)
; either world-box needs to be a kind of box - maybe a camera derived from a box ?
; or we want a way to pull these directly out of the environment
;(setf (the-world *globals*) (list *a-box-1* *a-box-2* *a-box-3* *a-box-4* *a-animation-1* *a-text-box-1*))
;(add-child (the-world *globals*) *a-box-1*)
;(add-child (the-world *globals*) *a-box-2*)
;(add-child (the-world *globals*) *a-box-3*)
;(add-child (the-world *globals*) *a-box-4*)
;(add-child (the-world *globals*) *an-animation-1*)



(defvar *an-animation-1* (make-instance 'animation :name     "*an-animation-1*"
                                                   :size     '(50.0 50.0 50.0)
                                                   :position '(-50.0 -50.0 0.0)
                                                   :color    '(1.0 0.0 1.0 0.75)))
(add-child *a-box-4* *an-animation-1*)



(defvar *a-ball-1* (make-instance 'ball :name     "*a-ball-1*"
                                         :size     '(25.0 25.0 25.0)
                                         :position '(10.0 0.0 100.0)
                                         :color    '(1.0 0.0 0.0 1.0)))
;(defvar *a-ball-2* (make-instance 'ball :name     "*a-ball-2*"
;                                         :size     '(10.0 10.0 10.0)
;                                         :position '(-100.0 0.0 100.0)
;                                         :color    '(0.0 0.0 1.0 1.0)
;                                         :velocity '(0.7 0.3 0.6)))

;(defvar *a-ball-3* (make-instance 'ball :name     "*a-ball-3*"
;                                         :size     '(15.0 15.0 15.0)
;                                         :position '(-100.0 0.0 100.0)
;                                         :color    '(0.0 0.0 1.0 1.0)
;                                         :velocity '(0.2 0.1 0.01)))
(add-child (the-world *globals*) *a-ball-1*)
;(add-child (the-world *globals*) *a-ball-2*)
;(add-child (the-world *globals*) *a-ball-3*)


(defvar *a-text-box-1* (make-instance 'text-box :name     "*a-text-box-1*"
                                                :size     '(50.0 50.0 0.0)
                                                :position '(50.0 -50.0 0.0)))
;(defvar *a-text-box-2* (make-instance 'text-box :name     "*a-text-box-2*"
;                                                 :size     '(100.0 50.0 0.0)
;                                                 :position '(-50.0 -50.0 0.0)))
;(defvar *a-text-box-3* (make-instance 'text-box :name     "*a-text-box-3*"
;                                                 :size     '(50.0 100.0 0.0)
;                                                 :position '(0.0 0.0 0.0)))
;(defvar *a-text-box-4* (make-instance 'text-box :name     "*a-text-box-4*"
;                                                 :size     '(100.0 100.0 0.0)
;                                                 :position '(0.0 50.0 0.0)))
(add-child (the-world *globals*) *a-text-box-1*)
;(add-child (the-world *globals*) *a-text-box-2*)
;(add-child (the-world *globals*) *a-text-box-3*)
;(add-child (the-world *globals*) *a-text-box-4*)


(defun deg->radians (deg)
  "Convert degrees and minutes to radians."
  (* (+ (truncate deg) (* (rem deg 1) 100/60)) pi 1/180))
(defvar *a-line-graph-1* (make-instance 'line-graph 
  :name     "*a-line-graph-1*"
  :size     '(100.0 50.0 50.0)
  :position '(0.0 0.0 0.0)
  ;:data     (loop for x from 0.0 to (* 2.0 pi) by 0.01 collect (sin x))))
  :data     (loop for x from 0.0 to 360.0 by 1.0 collect (sin (deg->radians x)))))
;loop for x from 0.0 to 360.0 by 1.0 do
;  (setf (data *a-line-graph-1*) (append (data *a-line-graph-1*) (list (sin (deg->radians x))))))
(add-child (the-world *globals*) *a-line-graph-1*)

  
(defvar *a-simple-system* (make-instance 'simple-system :name  "*a-simple-system*"
                                                        :size  '(25.0 25.0 25.0)
                                                        :color '(1.0 0.0 0.0 1.0)
                                                        :position '(-50.0 0.0 0.0)))
(add-child (the-world *globals*) *a-simple-system*)                                                        
