    ORG     $0007FF10

    move.l  D1, -(SP)                ; backup D1 to stack
    cmpi.b  #0, (0x00FFFFFE).l       ; are we even connected?!
    beq     end_of_timeout_func      ; nope we aren't so skip reset connection flag
    clr.l   D1                       ; make sure that D1 is 0
    move.w  (0x00FFFB08).l, D1       ; move current frame to D1
    divu    #60, D1                  ; D1 // 60 (modulo of 60+divided by 60)
    clr.w   D1                       ; remove divided by 60
    swap    D1                       ; get modulo of 60
    cmpi.w  #0, D1                   ; check current frame
    beq.b   disconnect_AP            ; if current frame % 60
    jmp     end_of_timeout_func      ; continue to randomizer loop
disconnect_AP:
    move.b  #0, (0x00FFFFFE).l       ; reset AP connected state
end_of_timeout_func:
    move.l  (SP)+, D1                ; restore D1 from stack
	rts