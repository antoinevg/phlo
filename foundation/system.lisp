(in-package #:phlo)



; input-systems is what is putting their output into you
; child-systems is what is inside of you
; output-systems is what you are putting your output into


; we're all tubes...



(defclass system () 
  ((inputs
     :type          list                 
     :accessor      inputs
     :initarg       :inputs                                                                                
     :documentation "" 
     :initform      '())
   (children                             
     :type          list 
     :accessor      children
     :initarg       :children
     :documentation ""
     :initform      '())     
   (outputs                               
     :type          list 
     :accessor      outputs
     :initarg       :outputs                                                                                
     :documentation "" 
     :initform      '())))
     


(defgeneric add-child (self child) (:documentation ""))
(defmethod add-child ((self system) child)
  (setf (children self) (append (children self) (list child))))	   
	   
	   
; time und change is a tricky one... much thought to go here still
(defgeneric tick (self) (:documentation ""))
(defmethod tick ((self system))
  (loop for child in (children self) do 
    (tick child)))


    
; The boundary definition of all systems are 
; only those entities which form part of 
; chains of feedback back into the system.
; i.e. The system ends at the point where 
; it no longer has the ability to cause effects 
; in it’s own nodes. i.e. Two given nodes are
; part of the same system if there is a route
; between their inputs and outputs. Or something.


; a system is made up of parts which, themselves, are systems

; a system has an environment which is made up of other systems 
; which interact with the system in the system's past, present 
; or future



; systems can be looked at as:

;   lists of parts
;   relationships between parts
;   function of the system relative to it's environment
;   function of the parts of the system relative to the system
;   function of the system relative to itself i.e. 'replicate' ???
;   see... function can be thought of as 'negotiated service' which is
;          how most folk see it which is why 


; systems can also be described and played with using one's imagination
; exploring this aspect of systems is mostly what phlo is about!

; what does it mean to be connected?
; what does it mean to be separate?


; 10 000 layers of abstraction is poisonous
; why has it worked out this way ?
; is it because either:
;   . the meta system is not powerful enough
;   . the meta system is a brain-dead ripoff
;   . the meta system is not understood by programmers?
;   . there is a false duality between the programming language, os and runtime libraries?
;   . we believe that somehow machine language programming is an evil to be shut in a 5 foot steel safe
;   . being able to use other people's code requires abstraction
; do we avoid the problem with the phlo approach ?







