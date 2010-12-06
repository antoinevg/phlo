(in-package #:phlo)


; Thought -> a graph can be generated from data or from a function... so graphs really should not
;            have a data slot but rather an input.
;         -> also, ideally graphs would be getting data either as a straight list of numbers 
;            and assuming fixed temporal interval or in the form of (x,y[,z]) doubles or triples.

(defclass line-graph (rounded-box) 
  ((data
    :type          list
    :accessor      data
    :initarg       :data
    :documentation ""
    :initform      '(2 3 4 1 -5 1 6 3 -4 2 5 6 -3 2))))
    

(defun draw-axis (start end ticks axis)
  (gl:line-width 0.5)         ; TODO - parameter
  (gl:color 0.0 0.0 0.0 1.0)  ; TODO - parameter
  (gl:begin :lines)
    (multiple-value-call #'gl:vertex (explode-3 start))
    (multiple-value-call #'gl:vertex (explode-3 end))
    (let ((tick-size 1.5)     ; TODO - parameter
          (tick-start NIL)
          (tick-end   NIL)
          (tick-skip  NIL))
      (when (eq axis 'x)
        (setf tick-start (mapcar #'- start (list 0.0 tick-size 0.0)))
        (setf tick-end   (mapcar #'+ start (list 0.0 tick-size 0.0)))
        (setf tick-skip  (append tick-skip (list (/ (- (first end) (first start)) (- ticks 1)) 0.0 0.0))))
      (when (eq axis 'y) 
        (setf tick-start (mapcar #'- start (list tick-size 0.0 0.0)))
        (setf tick-end start)
        ;(setf tick-end   (mapcar #'+ start (list tick-size 0.0 0.0)))
        (setf tick-skip  (append tick-skip (list 0.0 (/ (- (second end) (second start)) (- ticks 1)) 0.0))))
      (when (eq axis 'z) 
        (setf tick-start (mapcar #'- start (list 0.0 tick-size 0.0)))
        (setf tick-end start)
        ;(setf tick-end   (mapcar #'+ start (list 0.0 tick-size 0.0)))
        (setf tick-skip  (append tick-skip (list 0.0 0.0 (/ (- (third end) (third start)) (- ticks 1))))))
      (gl:begin :lines)      
      (dotimes (tick (+ ticks))
        (multiple-value-call #'gl:vertex    (explode-3 tick-start))
        (multiple-value-call #'gl:vertex    (explode-3 tick-end))
        (setf tick-start (mapcar #'+ tick-start tick-skip))
        (setf tick-end   (mapcar #'+ tick-end   tick-skip))))
  (gl:end))


(defmethod draw-self ((self line-graph))
  (gl:disable :lighting)
  (call-next-method)       ; draw background
  (setf (inset self) 5.0)  ; inset graph a little
  
  ; axi
  (draw-axis 
    (list (left  self) (middle self) (middle self))
    (list (right self) (middle self) (middle self))
    5                               ; TODO - parameter - also should not have to + 1 it ?
    'x)
  (draw-axis 
    (list (left  self) (bottom self) (middle self))
    (list (left  self) (top    self) (middle self))
    10                                                 ; TODO - parameter
    'y)
  ;(draw-axis 
  ;  (list (left  self) (middle self) (front self))
  ;  (list (left  self) (middle  self) (middle self))
  ;  10
  ;  'z)  
  
  
  ; data-plot
  ;(gl:line-width 4.0)
  (gl:begin :line-strip)
  (let* ((graph-width  (- (right self) (left self))) ; left&right etc should rather be replaced with start/end etc.
         (graph-height (- (top self) (bottom self)))
         (scale-x (length (data self)))
         (scale-y 2.0) ; TODO
         ;(scale-z NIL) ; TODO
         (point-next (list (left self) (middle self) (middle self)))
         (point-skip (/ graph-width (- scale-x 1)))) ; (list (/ graph-width scale-x) 0.0 0.0)))
    (loop for point in (data self) do
      (setf (second point-next) (* point (/ graph-height scale-y)))
      (multiple-value-call #'gl:vertex (explode-3 point-next))
      (incf (first point-next) point-skip)
    )
  )
  (gl:end)
  
  
  (setf (inset self) 0.0)
  (gl:enable :lighting))
