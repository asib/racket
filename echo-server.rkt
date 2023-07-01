#lang racket
(require racket/tcp)

(define listener (tcp-listen 5001 4 #t))

(let loop ()
  (define-values (in-socket out-socket) (tcp-accept listener))
  (match-define-values (_ _ addr port) (tcp-addresses in-socket #t))
  (printf "\nClient connected: ~a:~a" addr port)
  (thread
   (lambda ()
     (let loop ()
       (let ([line (read in-socket)])
         (if (not (eof-object? line))
             (begin
               (printf "\nEcho <~a:~a>: ~a" addr port line)
               (write line out-socket)
               (flush-output out-socket)
               (loop))
           
             (begin
               (display "\nClient disconnected")
               (close-input-port in-socket)
               (close-output-port out-socket))
             )
         )
       )
     )
   )

  (loop))