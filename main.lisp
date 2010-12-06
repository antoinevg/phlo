(require 'asdf)
(require 'cffi)
(require 'cl-opengl)
(require 'cl-glu)
(require 'cl-glut)

(load "package.lisp")
(load "ffi/ftgl.lisp") 
(load "ffi/glug.lisp")

(load "foundation/system.lisp")
(load "foundation/world.lisp")
(load "foundation/box.lisp")
(load "foundation/mouse.lisp")
(load "foundation/keyboard.lisp")
(load "foundation/rounded-box.lisp")
(load "foundation/text-box.lisp")
(load "foundation/line-graph.lisp")
(load "globals.lisp")	

(load "init.lisp")	
	
(in-package #:phlo)



; - utility -----------------------------------------------------------------
;(defmacro safe-cffi-callback (lisp-function &rest parameter-list &aux (callback-tmpname (gensym)))
;  `(prog2
;     (cffi:defcallback ,callback-tmpname :void ,parameter-list
;       (handler-case (,lisp-function ,@(mapcar #'car parameter-list))
;         (error (condition)
;           (setf (symbol-function ',lisp-function) (constantly nil))
;           (format t "Error in ~a: ~a~%" ',lisp-function condition))))
;     (cffi:callback ,callback-tmpname)))



; - rendering ---------------------------------------------------------------
(defun draw-grid ()
  (gl:with-pushed-matrix
    (gl:line-width 0.5)  
    (gl:translate 0.0 0.0 0.0)
    (gl:color 0.8 0.8 0.8 1.0)   
    (gl:begin :lines)
      (gl:vertex 0.0 (- (extents *globals*)) 0.0) 
	    (gl:vertex 0.0 (extents *globals*) 0.0)
      (gl:vertex (- (extents *globals*)) 0.0 0.0) 
	    (gl:vertex (extents *globals*) 0.0 0.0)        
    (gl:end))
  (gl:with-pushed-matrix
    (gl:translate 0.0 0.0 0.0)
    (gl:color 0.8 0.8 0.8 1.0)   
    (gl:begin :line-loop)
      (gl:vertex (- (extents *globals*)) (- (extents *globals*)) 0.0) 
	    (gl:vertex (- (extents *globals*)) (extents *globals*) 0.0)
      (gl:vertex (extents *globals*) (extents *globals*) 0.0) 
	    (gl:vertex (extents *globals*) (- (extents *globals*)) 0.0)          
    (gl:end))
  (gl:with-pushed-matrix
    (gl:translate 0.0 0.0 0.0)
    (gl:color 0.8 0.8 1.0 1.0)   
    (glut:wire-cube 200.0)))


(defun display (picking-mode pick-x pick-y)
  ;; clear screen and reset coordinate system
  (gl:clear :color-buffer :depth-buffer)
  (gl:matrix-mode :projection)  ; reset coordinate system before any matrix
  (gl:load-identity)            ; manipulations are performed
  ;; setup pick-matrix 
  (when (and picking-mode pick-x pick-y)
    (let ((viewport (gl:get-integer :viewport)))
      (glu:pick-matrix pick-x (- (elt viewport 3) (+ pick-y (elt viewport 1))) 1 1 viewport))) ; invert y coordinates
  ;; define clipping volume
  (glu:perspective 60 (display-aspect *globals*) 1 1000.0)
  (gl:matrix-mode :modelview)   ; all future transformations will
  (gl:load-identity)            ; affect what we draw aka Reset model transforms
  ;; position lights
  ;(gl:light :light0 :position '(0.0 0.0 (extents *globals*) 0.0))
  ;; position camera
  (let ((x  (first  (camera-position *globals*)))
        (y  (second (camera-position *globals*)))
        (z  (third  (camera-position *globals*)))
        (rx (fourth (camera-position *globals*)))
        (ry (fifth  (camera-position *globals*)))
        (rz (sixth  (camera-position *globals*))))
    (gl:translate x y z)
    (gl:rotate    rx 1.0 0.0 0.0)
    (gl:rotate    ry 0.0 1.0 0.0)
    (gl:rotate    rz 0.0 0.0 1.0))
  ;; initialize names stack for picking
  (gl:init-names)
  (gl:push-name 0)
  ;; draw the world
  (when (display-grid *globals*) 
    (draw-grid))  
  (gl:with-pushed-matrix
    (draw (the-world *globals*)))
  (gl:flush)
  (unless (and picking-mode pick-x pick-y)
    (glut:swap-buffers)))



; - callbacks ---------------------------------------------------------------
(cffi:defcallback display-callback :void ()
  (display NIL 0 0))


(cffi:defcallback timer-callback :void ((value :int))
  ;(format t "tick~%")
  (tick (the-world *globals*))
  (glut:timer-func (timer-delay *globals*) (cffi:callback timer-callback) value)
  (glut:post-redisplay))


(cffi:defcallback reshape-callback :void ((width :int) (height :int))
  (when (= height 0) ; prevent division by zero 
    (setf height 1))
  (gl:viewport 0 0 width height)
  (setf (display-size *globals*) (list width height)))
  
  
(cffi:defcallback keyboard-callback :void ((key :int) (mouse-x :int) (mouse-y :int))
  (when (focus (the-keyboard *globals*)))   
    (down (the-keyboard *globals*) key mouse-x mouse-y))
  
  
;(cffi:defcallback special-callback :void ((key glut:special-keys) (mouse-x :int) (mouse-y :int))
(cffi:defcallback special-callback :void ((key :int) (mouse-x :int) (mouse-y :int))
  (let ((x  (first  (camera-position *globals*)))
        (y  (second (camera-position *globals*)))
        (z  (third  (camera-position *globals*)))
        (rx (fourth (camera-position *globals*)))
        (ry (fifth  (camera-position *globals*)))
        (rz (sixth  (camera-position *globals*))))
    (case key 
      (100 (setq x  (+ x  (camera-nudge *globals*))))  ; :key-left     ?huh?
      (101 (setq y  (- y  (camera-nudge *globals*))))  ; :key-up       
      (102 (setq x  (- x  (camera-nudge *globals*))))  ; :key-right            
      (103 (setq y  (+ y  (camera-nudge *globals*))))  ; :key-down     
      (104 (setq z  (- z  (camera-nudge *globals*))))  ; :key-page-up  
      (105 (setq z  (+ z  (camera-nudge *globals*))))  ; :key-page-down
      (106 (setq rx (+ rx (camera-nudge *globals*))))  ; :key-home     
      (107 (setq rx (- rx (camera-nudge *globals*))))  ; :key-end      
      (52  (setq ry (+ ry (camera-nudge *globals*))))  ; :num-4     
      (54  (setq ry (- ry (camera-nudge *globals*))))  ; :num-6      
      (56  (setq rz (+ rz (camera-nudge *globals*))))  ; :num-8     
      (50  (setq rz (- rz (camera-nudge *globals*))))  ; :num-2      
    (otherwise    
      (format t "? ~a ~a ~a ~%" key mouse-x mouse-y)))
    (setf (camera-position *globals*) (list x y z rx ry rz)))
  (glut:post-redisplay))


;; called when the mouse moves and the mouse button is down
(cffi:defcallback motion-callback :void ((mouse-x :int) (mouse-y :int))
  (move (the-mouse *globals*) mouse-x mouse-y))


;; called when the mouse moves and the mouse button is up
(cffi:defcallback passive-motion-callback :void ((mouse-x :int) (mouse-y :int))
  ; perform picking
  (setf (picking-buffer *globals*) (make-array 8 :initial-element nil)) ; TODO this can't be good
  (gl:select-buffer (picking-buffer *globals*))
  (gl:render-mode :select)
  (display T mouse-x mouse-y)
  (gl:render-mode :render);(let ((number-of-hits (gl:render-mode :render)))
    (setf (over (the-mouse *globals*)) NIL)
    (setf (focus (the-keyboard *globals*)) NIL)
    (when T;(> number-of-hits 0) ; todo rewrite all of this to operate off picking-buffer rather than looping all entities
      ;(format t "hits: ~a buffer: ~a~%" number-of-hits (aref (picking-buffer *globals*) 3))
      (loop for child in (children (the-world *globals*)) do 
	      (setf (mouse-over child) nil)
        (when (eq (id child) (aref (picking-buffer *globals*) 3))
          ;(format t "Over: ~a ~%" (name child))
          (setf (mouse-over child) T) ; TODO - children shouldn't need to know. makes state difficult.
          (setf (over (the-mouse *globals*)) child)
          (setf (focus (the-keyboard *globals*)) child)
          ))
     (glut:post-redisplay))
  (move (the-mouse *globals*) mouse-x mouse-y))


(cffi:defcallback mouse-callback :void ((button :int) (state :int) (mouse-x :int) (mouse-y :int))
  ;(format t "~a~%" (glut:get-modifier-values))
  (case state 
    (1 (up (the-mouse *globals*) button mouse-x mouse-y))
    (0 (down (the-mouse *globals*) button mouse-x mouse-y))
    (otherwise (format t "ook~%"))))
;  (click (the-mouse *globals*) button state mouse-x mouse-y))

  
  
; - initialization ----------------------------------------------------------
(defun init-glut ()
  ;; init glut
  (glut:init-display-mode :double :rgba :depth) 
  ;(glut:init-display-mode :double :rgba :multisample :depth) ; :multisample -> anti-alias  
                                                             ; :depth       -> depth buffer (hidden line removal)
  ;(glut:init-display-string "rgb double depth>=16 samples=8")
  (glut:init-window-size (first  (display-size *globals*)) 
                         (second (display-size *globals*)))
  (glut:init-window-position 0 0)
  (glut:create-window "glphlo"))


(defun init-opengl ()
  ;; init gl
  ;(gl:enable :texture-2d) ; needed for ftgl texture text
  (gl:enable :depth-test) ; hidden surface removal
  ; lighting
  (gl:enable :lighting) ; lights
  (gl:light-model :light-model-ambient '(0.5 0.5 0.5 1.0))
  (gl:light :light0 :diffuse  '(0.4 0.4 0.4 1.0))      
  (gl:light :light0 :specular '(0.4 0.4 0.4 1.0))    
  (gl:enable :light0) 
  (gl:enable :color-material)
  (multiple-value-call #'gl:clear-color (explode-4 (background-color *globals*))))

  
; - entrypoint --------------------------------------------------------------
(defun main ()
  (init-glut)
  (init-opengl)
  ;; hook up callbacks 
  (glut:reshape-func             (cffi:callback reshape-callback))
  (glut:display-func             (cffi:callback display-callback))
  ;(glut:display-func             (safe-cffi-callback display-callback)) ; so we can call it from our picking handler  
  (glut:keyboard-func            (cffi:callback keyboard-callback))
  (glut:special-func             (cffi:callback special-callback))
  (glut:mouse-func               (cffi:callback mouse-callback))
  (glut:motion-func              (cffi:callback motion-callback)) 
  (glut:passive-motion-func      (cffi:callback passive-motion-callback))
  (glut:timer-func (timer-delay *globals*) (cffi:callback timer-callback) 1)
  ; & off we go
  ; (format t "foo function: ~a~%" (glug:foofn))
  (glut:main-loop)
  (format t "fin ~%"))
(main)
(format t "fini ~%")

