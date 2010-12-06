(in-package #:phlo)

;(defvar *text-box-font-name* "/Library/Fonts/Courier New Bold.ttf")
(defvar *text-box-font-name* "./ext/fonts/Monaco.ttf")
(defvar *text-box-font-size* 8)
(defvar *text-box-font-resolution* 1) ; TODO - fix positioning bugs when resolution != 1
  
(defvar *text-box-font* (font:new-texture-font *text-box-font-name*))
(font:font-set-face-size *text-box-font* (* *text-box-font-size* *text-box-font-resolution*) 100)

#|
(defvar *text-box-font-bbox*   (font:font-get-bbox *text-box-font* "ABCdefGHIjklMNOpqrSTUvwxyz"))
(defvar *text-box-font-height* (- (fifth  *text-box-font-bbox*) (second *text-box-font-bbox*)))
|#


(defclass text-box (rounded-box) 
  ((text
    :type          string
    :accessor      text
    :initarg       :text
    :documentation ""
    :initform      NIL)))
    
    
(defmethod keyboard-down ((self text-box) key mouse-x mouse-y)
  (setf (text self) (concatenate 'string (text self) (string (code-char key)))))
  

(defmethod draw-self ((self text-box))
  (gl:disable :lighting)
  
  (call-next-method) ; get the rounded-box drawn :)
    	
  ; text  
  (when (text self)
    (gl:with-pushed-matrix
      (gl:disable :blend)      
      (gl:enable :texture-2d)
      (gl:translate (left self) (top self) 0.0) ; origin
      (gl:translate 0.0 (- (font:font-line-height *text-box-font*)) 0.0) ; text-height
      (gl:translate 6.0 -3.0 0.0) ; inset
      (gl:color 0.0 0.0 0.0 1.0)
      ;(gl:scale (/ 1 *text-box-font-resolution*) (/ 1 *text-box-font-resolution*) (/ 1 *text-box-font-resolution*))
      (let ((x-position 0.0)); (y-position 0.0))
        (loop for char across (text self) do 
          (case (char-code char)
            (13        (gl:translate (- x-position) 0.0 0.0)
                       (setf x-position 0.0)
                       (gl:translate 0.0 -9.0 0.0)
                       ;(gl:translate 0.0 (- (font:font-line-height *text-box-font*)) 0.0)
                       ;(incf y-position (font:font-line-height *text-box-font*))
                       )
            (otherwise (font:font-render *text-box-font* (string char))
                       (gl:translate 5.0 0.0 0.0)
                       (incf x-position 5.0)))))
      (gl:disable :texture-2d)
      (gl:enable :blend)))
  (gl:enable :lighting))

