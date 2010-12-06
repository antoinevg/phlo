(in-package #:phlo)

; TODO - derive from animation

(defclass ball (box) 
  ((velocity 
     :type          list           ; motion-vector
     :accessor      velocity
     :initarg       :velocity
     :documentation ""
     :initform      '(0.2 0.3 0.2))))


(defmethod draw-bounds ((self ball)))

(defmethod draw-self ((self ball))  
  ;(format t "~a ~a~%" (type-of (first (position self))) (position self))
  ;(gl:light :light0 :spot-direction '(0.0 0.0 -1.0))
  (gl:light :light0 :position '(0.0 0.0 0.0 1.0))
  (gl:enable :depth-test)
  (gl:disable :lighting)
  (let ((resolution 16))
    (multiple-value-call #'gl:color     (explode-4 (color    self)))
  	(glut:solid-sphere (radius self) resolution resolution)
  	(gl:color 0.0 0.0 0.0 1.0)
  	(glut:wire-sphere (radius self) resolution resolution)  
  )
  (gl:enable :lighting)
  )
	


(defmethod tick ((self ball)) 
  (let ((x  (first  (position self)))
        (y  (second (position self)))
        (z  (third  (position self)))
        (dx (first  (velocity self)))
        (dy (second (velocity self)))
        (dz (third  (velocity self)))
        (rx (first  (rotation self)))
        (ry (second (rotation self)))
        (rz (third  (rotation self))))
    (when (or (> x (right  (the-world *globals*)))
              (< x (left   (the-world *globals*))))
      (setf dx (- dx)))
    (when (or (> y (top    (the-world *globals*)))
              (< y (bottom (the-world *globals*))))
      (setf dy (- dy)))
    (when (or (< z (back   (the-world *globals*)))
              (> z (front  (the-world *globals*))))
      (setf dz (- dz)))
    (incf x dx)
    (incf y dy)
    (incf z dz)
    ;(incf rx -1.0)
    ;(incf ry 2.0)
    ;(incf rz -3.0)
    (setf (position self) (list x y z))
    (setf (velocity self) (list dx dy dz))
    (setf (rotation self) (list rx ry rz))))



;; motion mix-in
(defclass motion ()
   ((velocity 
     :type          list           ; motion-vector
     :accessor      velocity
     :initarg       :velocity
     :documentation ""
     :initform      '(0.0 0.0 0.0))    
   (acceleration
     :type          float          ; x? distance per second
     :accessor      acceleration
     :initarg       :acceleration
     :documentation ""
     :initform      0.0)))

    