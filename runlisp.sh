sbcl --noinform --disable-debugger --eval '(set-dispatch-macro-character #\# #\! (lambda (stream bang number) (declare (ignore bang number)) (read-line stream) t))' --load $1 --eval '(quit)'
