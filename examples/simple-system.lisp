(in-package #:phlo)

(defclass simple-system (box) 
  ((x
     :type          real
     :accessor      x                                                                                 
     :initarg       :x                                                                                 
     :initform      0.0))) ; loop-start



; it can be specced from the 'inside'
(defmethod tick ((self simple-system))
  (when (< (x self) (* 2.0 pi))
    (incf (x self) 0.01)
    ; (print (x self))
    ))


; or

; it can be specced from the 'outside' 

  ;:data     (loop for x from 0.0 to (* 2.0 pi) by 0.01 collect (sin x))))
  ;:data     (loop for x from 0.0 to 360.0 by 1.0 collect (sin (deg->radians x)))))


; what is time ?
; what is instantaneous ?
; what is continuous ?
; what is quantized ?


; okay, computers are definitely quantized in their operation and they definitely
; may be or may not or may be and may be or may be and may not in their construction.


