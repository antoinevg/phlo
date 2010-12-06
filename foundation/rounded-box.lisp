(in-package #:phlo)


(defclass rounded-box (box) 
  ((radius
    :type          real
    :accessor      radius
    :initarg       :radius
    :documentation ""
    :initform      3.0)))
    

(defgeneric draw-rounded-box (self) (:documentation ""))
(defmethod draw-rounded-box (self)
  ; a rounded box
  (let ((sides  6) 
        (radius (radius self)))
    ; background
    (gl:begin :quads)
    	(gl:color 0.82 0.79 0.73 1.0)  ; color-1
    	(gl:vertex (- (right self) radius) (- (top self) radius) (middle self)) ; top-right
    	(gl:color 0.92 0.89 0.83 1.0)  ; color-2
    	(gl:vertex (+ (left  self) radius) (- (top self) radius) (middle self)) ; top-left
    	(gl:color 0.71 0.67 0.62 1.0)  ; color-3
    	(gl:vertex (+ (left  self) radius) (+ (bottom self) radius) (middle self)) ; bottom-left
    	(gl:color 0.61 0.57 0.52 1.0)	 ; color-4       	    		      	  
    	(gl:vertex (- (right self) radius) (+ (bottom self) radius) (middle self)) ; bottom-right
  	(gl:end)  
    ; corners and edges  
    (dotimes (corner 4)
      (gl:with-pushed-matrix
        (when (= corner 0) ; top-right
          (gl:begin :quads)
          	(gl:color 0.61 0.57 0.52 1.0) ; color-4	     
          	(gl:vertex (right self)            (+ (bottom self) radius) (middle self))   ;  100  - 90
          	(gl:vertex (- (right self) radius) (+ (bottom self) radius) (middle self))   ;   90  - 90          	
            (gl:color 0.82 0.79 0.73 1.0) ; color-1
          	(gl:vertex (- (right self) radius) (- (top self) radius) (middle self))      ;   90    90
          	(gl:vertex (right self)            (- (top self) radius) (middle self))      ;  100    90
          (gl:end)
          (gl:translate (- (right self) radius) (- (top self) radius) (middle self)))    ;   90    90  (3)
        (when (= corner 1) ; top-left
          (gl:begin :quads)
          	(gl:color 0.82 0.79 0.73 1.0) ; color-1           
          	(gl:vertex (- (right self) radius) (top self) (middle self))                 ;   90   100
          	(gl:vertex (- (right self) radius) (- (top self) radius) (middle self))      ;   90    90        	
            (gl:color 0.92 0.89 0.83 1.0) ; color-2       
          	(gl:vertex (+ (left  self) radius) (- (top self) radius) (middle self))      ; - 90    90
          	(gl:vertex (+ (left  self) radius) (top self) (middle self))                 ; - 90   100
          (gl:end)
          (gl:translate (+ (left self) radius) (- (top self) radius) (middle self)))     ; - 90    90  (3)
        (when (= corner 2) ; bottom-left         
          (gl:begin :quads)
            (gl:color 0.92 0.89 0.83 1.0) ; color-2       
          	(gl:vertex (left self)            (- (top self) radius) (middle self))       ; -100    90
          	(gl:vertex (+ (left self) radius) (- (top self) radius) (middle self))       ; - 90    90
            (gl:color 0.71 0.67 0.62 1.0) ; color-3
          	(gl:vertex (+ (left self) radius) (+ (bottom self) radius) (middle self))    ; - 90  - 90
          	(gl:vertex (left self)            (+ (bottom self) radius) (middle self))    ; -100  - 90       	  
          (gl:end)            
          (gl:translate (+ (left self) radius) (+ (bottom self) radius) (middle self)))  ; - 90  - 90  (3)
        (when (= corner 3) ; bottom-right
          (gl:begin :quads)
            (gl:color 0.71 0.67 0.62 1.0) ; color-3
            (gl:vertex (+ (left  self) radius) (bottom self) (middle self))              ; - 90  -100
          	(gl:vertex (+ (left  self) radius) (+ (bottom self) radius) (middle self))   ; - 90  - 90          
            (gl:color 0.61 0.57 0.52 1.0)	; color-4        	  
          	(gl:vertex (- (right self) radius) (+ (bottom self) radius) (middle self))   ;   90  - 90
          	(gl:vertex (- (right self) radius) (bottom self) (middle self))              ;   90  -100
        (gl:end)
          (gl:translate (- (right self) radius) (+ (bottom self) radius) (middle self))) ;   90  - 90 (3)            
        (gl:begin :triangle-fan)	        
          (gl:vertex 0.0 0.0 0.0)		        
          (dotimes (side (+ sides 1))
            (let ((theta (/ (* pi (+ side (* sides corner))) (* sides 2))))
              (gl:vertex (* radius (cos theta)) (* radius (sin theta)) (middle self))))
        (gl:end)))))
        
        
(defmethod draw-self ((self rounded-box))
  (draw-rounded-box self))
  