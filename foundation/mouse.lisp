(in-package #:phlo)

; todo - hide. everything should be logical coordinates.
; TODO - save and pass in modelview/projection/viewport to glu:un-project
; TODO - decide on standardizing between returning lists or multiple values
; TODO - cache mouse-z for the duration of a drag somehow cuz things break when cursor moves too fast
(defun mouse->gl (mouse-x mouse-y)
  (let ((viewport (gl:get-integer :viewport)))
    ;(format t "um: ~a ~%" (aref (gl:read-pixels mouse-x (- (elt viewport 3) mouse-y) 1 1 :depth-component :float) 0))
    (glu:un-project 
      mouse-x 
      (- (elt viewport 3) mouse-y) 
      0.99265945))) ; TODO - transparency breaks things 
      ;(aref (gl:read-pixels mouse-x (- (elt viewport 3) mouse-y) 1 1 :depth-component :float) 0))))


(defclass mouse ()
   ((last-move 
     :type          list        
     :accessor      last-move
     :initarg       :last-move
     :documentation ""
     :initform      '(0.0 0.0))    
   (last-down
     :type          list
     :accessor      last-down
     :initarg       :last-down
     :documentation ""
     :initform      '(0.0 0.0))
   (button
     :type          integer
     :accessor      button
     :initarg       :button
     :documentation ""
     :initform      nil)
   (over
     ;:type          box
     :accessor      over
     :initarg       :over
     :documentation "the object (if any) which the mouse is over"
     :initform      nil)
   (dragging
     ; :type            box? list?
     :accessor      dragging
     :initarg       :dragging
     :documentation ""
     :initform      nil)))


(defgeneric down (self button mouse-x mouse-y) (:documentation ""))
(defmethod down ((self mouse) button mouse-x mouse-y)
  (setf (button self) button)
  (setf (last-down self) (list mouse-x mouse-y))  
  (setf (dragging self) (over self))
  ;(format t "down ~a ~a ~a ~a ~%" self (button self) mouse-x mouse-y)
  )


(defgeneric up (self button mouse-x mouse-y) (:documentation ""))
(defmethod up ((self mouse) button mouse-x mouse-y)
  (setf (button self) nil)
  (setf (dragging self) nil)
  ;(format t "up ~a ~a ~a ~a ~%" self (button self) mouse-x mouse-y)
  )


(defgeneric move (self mouse-x mouse-y) (:documentation ""))
(defmethod move (self mouse-x mouse-y)
  (setf (last-move self) (list mouse-x mouse-y))
  (when (dragging self)
    (multiple-value-bind (gl-x gl-y) (mouse->gl mouse-x mouse-y)
      (setf (position (dragging self)) (list gl-x gl-y (third (position (dragging self))))))
    (glut:post-redisplay)))


