(in-package #:phlo)

(defgeneric transparency (self)) ; TODO - Grrrr avoid warning from *globals* :-(

;; font stuff
;(defvar *box-font-name* "./ext/fonts/Lucida Grande.ttf")
(defvar *box-font-name* "./ext/fonts/Monaco.ttf")
(defvar *box-font-size* 12)
(defvar *box-font-resolution* 1) ; TODO - fix positioning bug when resolution != 1
  
(defvar *box-font-texture* (font:new-texture-font *box-font-name*))
(font:font-set-face-size *box-font-texture* (* *box-font-size* *box-font-resolution*) 100)
(defvar *box-font* *box-font-texture*)

;(defvar *box-font-polygon* (font:new-polygon-font *box-font-name*))
;(font:font-set-face-size *box-font-polygon* *box-font-size* 100)
;(font:font-set-depth *box-font-polygon* 1.0)
;(defvar *box-font* *box-font-polygon*)

; TODO: (font:font-delete *box-font*)



;; cleaner please
;(mapcar #'(lambda (c) (apply 'gl-double-vector c)) contents)
(defun explode-3 (lst)
  (values (first lst) (second lst) (third lst)))
(defun explode-4 (lst)
  (values (first lst) (second lst) (third lst) (fourth lst)))



;; da box de tinking it is being trapped inside
(defclass box (world)
  ((name 
     :type          string     
     :accessor      name                                                                                  
     :initarg       :name                                                                                 
     :documentation "Naming & parameterizing similiar patterns is one way of compressing descriptions of systems." 
     :initform      "my-name")
   (color 
     :type          list          ; rgba
     :accessor      color                                                                                  
     :initarg       :color                                                                                 
     :documentation "" 
     :initform      '(0.5 0.5 0.5 1.0))
   (mouse-over ; TODO - lose in favor of an argument to draw ?
	   ;:type          box???
	   :accessor      mouse-over
	   :initarg       :mouse-over
	   :documentation ""
	   :initform      nil)))
	

; - drawing -----------------------------------------------------------------
(defgeneric draw-self (self) (:documentation "override for specific shapes"))
(defmethod draw-self ((self box))   
	(multiple-value-call #'gl:color (explode-4 (color self)))
	(gl:rect (left self) (top self) (right self) (bottom self)))


(defgeneric draw-transforms (self) (:documentation ""))
(defmethod draw-transforms ((self box))
  (multiple-value-call #'gl:translate (explode-3 (position self)))
  (gl:rotate (first  (rotation self)) 1.0 0.0 0.0)
  (gl:rotate (second (rotation self)) 0.0 1.0 0.0)
  (gl:rotate (third  (rotation self)) 0.0 0.0 1.0)
  (let ((scale (/ (max (render-width self) (render-height self) (render-depth self)) (* (extents *globals*) 2))))
    (gl:scale scale scale scale)))


(defgeneric draw-bounds (self) (:documentation ""))
(defmethod draw-bounds ((self box))
  (gl:color 0.0 0.0 0.0 1.0)
  ;(multiple-value-call #'gl:color     (explode-4 (color    self)))
  (gl:begin :line-loop)
    (gl:vertex (left  self) (bottom self) 0.0) (gl:vertex (left  self) (top    self) 0.0)
    (gl:vertex (right self) (top    self) 0.0) (gl:vertex (right self) (bottom self) 0.0)          
  (gl:end))
	

(defgeneric draw-decorations (self) (:documentation ""))
(defmethod draw-decorations ((self box))
  (gl:with-pushed-matrix
	  (gl:color 0.0 0.0 0.0 1.0)
	  (let ((line-width (gl:get-float :line-width-range))) ; save line-width
	    (gl:line-width (* (aref line-width 0) 1.0))
	    (gl:begin :line-loop)
        (gl:vertex (left self) (bottom self) 0.0) 
        (gl:vertex (left self) (top self) 0.0)
        (gl:vertex (right self) (top self) 0.0) 
        (gl:vertex (right self) (bottom self) 0.0)          
      (gl:end)
      (gl:line-width (aref line-width 0)))))


(defgeneric draw-label (self) (:documentation ""))
(defmethod draw-label ((self box))
  (gl:with-pushed-matrix
    ; TODO - fix positioning bug when resolution != 1
    (gl:scale (/ 1 *box-font-resolution*) (/ 1 *box-font-resolution*) (/ 1 *box-font-resolution*))
    (let ((label-bounds (font:font-get-bbox *box-font* (name self)))) 
          (let ((label-width  (- (fourth label-bounds) (first  label-bounds)))
                (label-height (- (fifth  label-bounds) (second label-bounds))))
            ;(gl:color 0.0 0.0 0.0 1.0)
            (gl:translate (- (/ label-width 2.0)) (- (bottom self) (* label-height 2.0)) 0.0)
            (gl:disable :blend) (gl:enable :texture-2d) ; TODO - for some reason
            (font:font-render *box-font* (name self))
            (gl:disable :texture-2d) (gl:enable :blend) ; TODO - for some reason
            ))))


(defmethod draw ((self box))
  ;(gl:enable :texture-2d)
  ;(font:font-render *box-font* "(name self)")
  ;(gl:disable :texture-2d)
  (gl:load-name (id self))    ; TODO - we need some kind of object id <-> number mechanism
  (gl:with-pushed-matrix
    (draw-transforms self)
    ;(draw-bounds self)
    (when (transparency *globals*)                     ;; transparency
      (gl:enable :blend)                               ;; transparency
      (gl:blend-func :src-alpha :one-minus-src-alpha)  ;; transparency  
      (gl:disable :depth-test))                        ;; transparency

    (draw-self self)          ; custom drawing
      
    (when (transparency *globals*)                     ;; transparency
      (gl:disable :blend)                              ;; transparency  
      (gl:enable :depth-test))                         ;; transparency      
      
    (when (mouse-over self)
      (draw-label self)      ; TODO - font:* on texture fonts breaks transparency :(
      (draw-decorations self))
    (call-next-method))
  ; TODO draw children that are not internal and which are thus not subject to transforms
)





; Of all the slots in this class, only name conceivably exists in isolation to the rest of the universe
; All the rest are describing relations to other things in the universe

; look... in the real world there aren't any parts
; parts only exist when something is dead so it's
; stupid to think about decomposition in terms of
; real systems really... maybe when you pull it 
; apart sure... 

; TODO -> I don't like that you can't pass either space-sepped values or a list to a function but not both
;         especially w/ opengl calls. Is this true tho' ? Is there a way around ?



