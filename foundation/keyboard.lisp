(in-package #:phlo)

(defclass keyboard ()
  ((focus
    :type box
    :accessor      focus
    :initarg       :focus
    :documentation ""
    :initform      nil)))
    
    
; TODO - is there a way to have a class method down with a different signature to the one in mouse ?
;(defgeneric press (self key mouse-x mouse-y) (:documentation ""))
(defmethod down ((self keyboard) key mouse-x mouse-y) 
  (when (focus self)
    (keyboard-down (focus self) key mouse-x mouse-y)
    (format t "~:c" (code-char key))
    (force-output)))


