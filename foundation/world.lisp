(in-package #:phlo)



;; TODO - determine the correct way of nuking these warnings
(defgeneric world-next-id (self))
(defgeneric extents (self))
(defvar *globals*)



(defclass world (system)
  ((id
	   :type          integer
	   :accessor      id
	   :initarg       :id
	   :documentation "Unique id for object"
	   :initform      (world-next-id *globals*))
   (size     
     :type          list           ; relative to screen aka containing world 
     :accessor      size
     :initarg       :size
     :documentation ""
     :initform      '(100.0 100.0 100.0))
   (inset
     :type          real
     :accessor      inset
     :initarg       :inset
     :documentation ""
     :initform      0.0)     
   (position 
     :type          list           ; cartesian-coordinates  what distance unit do they map to ?
     :accessor      position 
     :initarg       :position
     :documentation ""
     :initform      '(0.0 0.0 0.0))
   (rotation 
     :type          list           ; degrees along each axis
     :accessor      rotation
     :initarg       :rotation
     :documentation ""
     :initform      '(0.0 0.0 0.0))
   (extents
     :type          real
     :accessor      extents
     :initarg       :extents
     :documentation "unit square extents"
     :initform      (extents *globals*))))
     
	   
(defgeneric draw (self) (:documentation ""))
(defmethod draw ((self world))
  (loop for child in (children self) do 
    (draw child)))
     
     
;; geometry
; http://www.sbcl.org/manual/Style-Warnings.html#Style-Warnings
(defgeneric render-width  (self)) (defmethod render-width  (self) (first  (size self)))
(defgeneric render-height (self)) (defmethod render-height (self) (second (size self)))
(defgeneric render-depth  (self)) (defmethod render-depth  (self) (third  (size self)))
(defgeneric aspect-width  (self)) (defmethod aspect-width  (self) (/ (render-width  self) (render-height self)))
(defgeneric aspect-height (self)) (defmethod aspect-height (self) (/ (render-height self) (render-width  self)))
(defgeneric aspect-depth  (self)) (defmethod aspect-depth  (self) (/ (render-depth  self) (render-height self))) ; todo
(defgeneric bounds (self)
  (:documentation "left bottom back right top front")) ; todo this should be a ' somewhere that auto applies... 
(defmethod bounds (self)
  (list (- (min (* (extents self) (aspect-width  self)) (extents self)))
        (- (min (* (extents self) (aspect-height self)) (extents self)))
        (- (min (* (extents self) (aspect-depth  self)) (extents self)))
           (min (* (extents self) (aspect-width  self)) (extents self))
           (min (* (extents self) (aspect-height self)) (extents self))
           (min (* (extents self) (aspect-depth  self)) (extents self)))) 
(defgeneric left   (self)) (defmethod left   (self) (+ (first  (bounds self)) (inset self)))
(defgeneric bottom (self)) (defmethod bottom (self) (+ (second (bounds self)) (inset self)))
(defgeneric back   (self)) (defmethod back   (self) (+ (third  (bounds self)) (inset self)))
(defgeneric right  (self)) (defmethod right  (self) (- (fourth (bounds self)) (inset self)))
(defgeneric top    (self)) (defmethod top    (self) (- (fifth  (bounds self)) (inset self)))
(defgeneric front  (self)) (defmethod front  (self) (- (sixth  (bounds self)) (inset self)))
(defgeneric middle (self)) (defmethod middle (self) 0.0) ; TODO?
(defgeneric radius (self)) (defmethod radius (self) (extents self)) ; TODO?

(defgeneric width  (self)) (defmethod width  (self) (- (right self) (left   self))) ; experimental - used by line-graph
(defgeneric height (self)) (defmethod height (self) (- (top   self) (bottom self))) ; experimental - used by line-graph
(defgeneric depth  (self)) (defmethod depth  (self) (- (front self) (back   self))) ; experimental - used by line-graph
    
(defgeneric keyboard-down (self key mouse-x mouse-y))
(defmethod keyboard-down (self key mouse-x mouse-y))
;(defgeneric mouse    (self key mouse-x mouse-y))

