    ORG     $0007FF46
    movem.l a6-a0/d7-d0, -(SP)       ; save all registers to stack
    move.l  #0x000E0000, A0          ; move constants address to A0
    move.l  #0x00200000, A1          ; pointer to SRAM
    ; reading 32-bit magic word in SRAM
    clr.l   D0
    move.b  (A1), D0
    lsl.l   #8, D0
    move.b  0x1(A1), D0
    lsl.l   #8, D0
    move.b  0x2(A1), D0
    lsl.l   #8, D0
    move.b  0x3(A1), D0
    cmpi.l  #0x534F5231, D0          ; check if save is initialized
    beq.w   end_of_func              ; SRAM is initialized so return

    move.l  #0x0020002D, A1          ; pointer to SRAM at the offset of seed name
    ; for loop to reset the seed name
    clr.l   D0                       ;
    move.l  0x44(A0), D1             ; length of seed name
reset_seed_name:
    cmpi.b  #0x40, D0                ;
    beq     resetted_seed_name       ;
    andi.l  #0x000000FF, D2          ;
    move.l  A1, A2                   ;
    add.l   D0, A2                   ;
    cmp.b   D1, D0                   ;
    bge     fill_with_zeros          ;
    move.b  0x48(A0, D0.l), D2       ;
    move.b  D2, (A2)                 ;
    addi.l  #1, D0                   ;
    jmp     reset_seed_name          ;
fill_with_zeros:
    move.b  #0, (A2)                 ;
    addi.l  #1, D0                   ;
    jmp     reset_seed_name          ;
resetted_seed_name:
    move.l  #0x00200000, A1          ; pointer to SRAM
    ; end of for loop

    ; write seed name length to SRAM
    move.b  D1, 0x2C(A1)
    lsr.b   #8, D1
    move.b  D1, 0x2B(A1)
    ; write deaths to SRAM
    move.b  #0, 0x2A(A1)
    ; write death link out to SRAM
    move.b  #0, 0x29(A1)
    ; write death link in to SRAM
    move.b  #0, 0x28(A1)
    ; write stage objects cleared (stage 6/7) to SRAM
    move.b  #0, 0x27(A1)
    move.b  #0, 0x26(A1)
    move.b  #0, 0x25(A1)
    move.b  #0, 0x24(A1)
    ; write stage objects cleared (stage 5/6) to SRAM
    move.b  #0, 0x23(A1)
    move.b  #0, 0x22(A1)
    move.b  #0, 0x21(A1)
    move.b  #0, 0x20(A1)
    ; write stage objects cleared (stage 3/4) to SRAM
    move.b  #0, 0x1F(A1)
    move.b  #0, 0x1E(A1)
    move.b  #0, 0x1D(A1)
    move.b  #0, 0x1C(A1)
    ; write stage objects cleared (stage 1/2) to SRAM
    move.b  #0, 0x1B(A1)
    move.b  #0, 0x1A(A1)
    move.b  #0, 0x19(A1)
    move.b  #0, 0x18(A1)
    ; write filler to SRAM
    move.b  #0xFF, 0x17(A1)
    move.b  #0xFF, 0x16(A1)
    move.b  #0xFF, 0x15(A1)
    ; write final boss cleared to SRAM
    move.b  #0, 0x14(A1)
    ; write stages uncleared (5 to 8) to SRAM
    move.b  #0, 0x13(A1)
    move.b  #0, 0x12(A1)
    move.b  #0, 0x11(A1)
    move.b  #0, 0x10(A1)
    ; write stages uncleared (1 to 4) to SRAM
    move.b  #0, 0x0F(A1)
    move.b  #0, 0x0E(A1)
    move.b  #0, 0x0D(A1)
    move.b  #0, 0x0C(A1)
    ; write last received item to SRAM
    move.b  #0xFF, 0x0B(A1)
    move.b  #0xFF, 0x0A(A1)
    move.b  #0xFF, 0x09(A1)
    move.b  #0xFF, 0x08(A1)
    ; write slot number to SRAM
    clr.l   D0
    move.b  0x43(A0), D0
    move.b  D0, 0x07(A1)
    move.b  0x42(A0), D0
    move.b  D0, 0x06(A1)
    move.b  #0, 0x05(A1)
    move.b  #0, 0x04(A1)
    ; write magic number to SRAM
    move.b  #0x31, 0x03(A1)
    move.b  #0x52, 0x02(A1)
    move.b  #0x4F, 0x01(A1)
    move.b  #0x53, (A1)
end_of_func:
    movem.l (SP)+, d0-d7/a0-a6       ; load all registers from stack
    rts