; Read input
loop_in: LDA     mLength,i   ; do {
         CALL    new         ;   X = new Node(); #mVal #mNext #mPrev
							 ;
         LDA     0, i		 ;	 A = 0
         STA     mPrev,x     ;   X.prev = 0
         STA     mNext,x     ;   X.next = 0
							 ;
         CHARI   mVal,x      ;   X.val = getChar()
         LDBYTEA mVal,x      ;   A = X.val
         CPA     '\n', i	 ;	 if(A == '\n')
         BREQ    out         ;	   break;
							 ;
         ADDA    12, d		 ;	 A -= 13
         STBYTEA mVal,x      ;	 X.val = A
         LDA     head,d      ;
         STA     mNext,x     ;   X.next = head;
         STX     head,d      ;   head = X;
         LDA     head,d      ;   A = head;
         LDX     mNext,x     ;   X = X.next;
         CPX     0,i         ;   if(X != null) {
         BREQ    else		 ;
         STA     mPrev,x     ;       X.prev = A;
         BR      next        ;   } else {
else:    STA     tail,d      ;       tail = A;
                             ;   }
next:    BR      loop_in     ; } while (X.val != null)
							 ;
                             ;
out:     LDX     head,d		 ;
backward:CPX     0,i		 ;
         BREQ    fin         ; for (X=head; X!=null; X=X.next) {
         CHARO   mVal,x      ;   print(X.val)
         LDX     mNext,x	 ;
         BR      backward    ; }
fin:     STOP				 ;
head:    .BLOCK  2           ; #2h list head (null (aka 0) if empty)
tail:    .BLOCK  2           ; #2h list tail (null (aka 0) if empty)
;
;******* Linked-list node structure
mVal:    .EQUATE 0           ; #1c node value
mNext:   .EQUATE 1           ; #2h next node (null (aka 0) for tail)
mPrev:   .EQUATE 3           ; #2h prev node (null (aka 0) for head)
mLength: .EQUATE 5           ; node size in bytes
;
;
;******* operator new
;        Precondition: A contains number of bytes
;        Postcondition: X contains pointer to bytes
new:     LDX     hpPtr,d     ;returned pointer
         ADDA    hpPtr,d     ;allocate from heap
         STA     hpPtr,d     ;update hpPtr
         RET0
hpPtr:   .ADDRSS heap        ;address of next free byte
heap:    .BLOCK  1           ;first byte in the heap
