(in-package #:phlo)

(defclass globals () (
   (display-size
     :type          list    
     :accessor      display-size  ; TODO - automagic accessors please
     :initarg       :display-size ; TODO - automagic initargs  please
     :documentation ""
     :initform      '(800 600))
   (display-grid
     :type          boolean
     :accessor      display-grid
     :initarg       :display-grid
     :documentation ""
     :initform      t)          
   (camera-position
     :type          list 
     :accessor      camera-position
     :initarg       :camera-position
     :documentation "position-x position-y position-z rotation-x rotation-y rotation-z" ; (dx dy dz accel_x accel_y accel_z) ?
     :initform      '(0.0 0.0 -120.0 0.0 0.0 0.0))
   (camera-nudge
     :type          real
     :accessor      camera-nudge
     :initarg       :camera-nudge
     :documentation ""
     :initform      5.0)
   (timer-delay
     :type          integer     
     :accessor      timer-delay
     :initarg       :timer-delay
     :documentation ""
     :initform      10)
   (picking-buffer
     :type          list  
     :accessor      picking-buffer
     :initarg       :picking-buffer
     :documentation ""
     :initform      (make-array 8 :initial-element nil))
   (extents
     :type          real
     :accessor      extents
     :initarg       :extents
     :documentation "unit square extents"
     :initform      100.0)
   (the-world
     :type          world
     :accessor      the-world
     :initarg       :the-world
     :documentation ""
     :initform      NIL) ; circ dep means create after creating *globals*
   (the-mouse
     :type          mouse
     :accessor      the-mouse
     :initarg       :the-mouse
     :documentation ""
     :initform      (make-instance 'mouse))     
   (the-keyboard
     :type          keyboard
     :accessor      the-keyboard
     :initarg       :the-keyboard
     :documentation ""
     :initform      (make-instance 'keyboard))            
   (world-next-id
     :type          integer
     :accessor      _world-next-id
     :initarg       :world-next-id
     :documentation ""
     :initform      23)
   (background-color 
     :type          list
     :accessor      background-color
     :initarg       :background-color
     :initform      '(1.0 1.0 1.0 1.0))
   (transparency
     :type          boolean
     :accessor      transparency
     :initarg       :transparency
     :documentation ""
     :initform      T)     
))
(defvar *globals* (make-instance 'globals))

(defgeneric display-aspect (self) (:documentation ""))
(defmethod  display-aspect ((self globals)) (/ (first (display-size self)) (second (display-size self))))

(defgeneric world-next-id (self) (:documentation ""))
(defmethod  world-next-id ((self globals)) (setf (_world-next-id self) (+ (_world-next-id self) 1)))

; fix for circ dep 
;(setf (the-world *globals*) (make-instance 'world :size     '((* (extents *globals*) 2.0) 
;                                                              (* (extents *globals*) 2.0) 
;                                                              (* (extents *globals*) 2.0))
;                                                  :position '(0.0 0.0 0.0))) 

(setf (the-world *globals*) (make-instance 'world :size     '(200.0 200.0 200.0)
                                                  :position '(0.0 0.0 0.0))) 
