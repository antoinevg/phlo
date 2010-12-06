(in-package #:phlo)

(defclass animation (box) ())
;  ((arb 
;     :type          string     
;     :accessor      arb                                                                                  
;     :initarg       :arb                                                                                 
;     :initform      "arb")))


(defmethod tick ((self animation)) 
  (let ((rx (first  (rotation self)))
        (ry (second (rotation self)))
        (rz (third  (rotation self))))
    (setf rx (+ rx 0.05))
    (setf ry (+ ry 0.05))
    (setf rz (+ rz 0.05))    
    (setf (rotation self) (list rx ry rz))))


;  (let ((x (first  (position *my-box-1*)))
;        (y (second (position *my-box-1*)))
;        (z (third  (position *my-box-1*))))
;    ;(setf x (+ x 0.1))
;    ;(setf y (+ y 0.05))
;    (setf (position *my-box-1*) (list x y z))
