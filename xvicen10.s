; Autor reseni: Boris Vicena xvicen10
; Pocet cyklu k serazeni puvodniho retezce: 2500
; Pocet cyklu razeni sestupne serazeneho retezce: 2793
; Pocet cyklu razeni vzestupne serazeneho retezce: 388
; Pocet cyklu razeni retezce s vasim loginem: 639
; Implementovany radici algoritmus: Bubble Sort
; ------------------------------------------------

; DATA SEGMENT
                .data
; login:          .asciiz "vitejte-v-inp-2023"    ; puvodni uvitaci retezec
; login:          .asciiz "vvttpnjiiee3220---"  ; sestupne serazeny retezec
; login:          .asciiz "---0223eeiijnpttvv"  ; vzestupne serazeny retezec
login:          .asciiz "xvicen10"            ; SEM DOPLNTE VLASTNI LOGIN
                                                ; A POUZE S TIMTO ODEVZDEJTE

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize - "funkce" print_string)

; CODE SEGMENT
                .text
main:
        daddi   r3, r0, 1               ; Inicializacia swapped na 1

load_char:
        lb      r11, login(r10)         ; Nacita znak z retazca do r11
        j       strlen                  ; Skoci na vypocet dlzky retazca
strlen:
        beqz    r11, outer_loop         ; Ak je nacitany znak nula, skoci na outer_loop 
        daddi   r10, r10, 1             ; Presun na dalsi znak v retazsi
        j       load_char               ; Skoci spat na nacitanie dalsieho znaku

outer_loop:
        beqz    r3, bsort_quit          ; Ak je swapped nula, skoci na bsort_quit
        daddi   r3, r0, 0               ; Reset swapped na nulu
        beqz    r10, bsort_quit         ; Ak sa presiel cely retazec, skoci na bsort_quit
        daddi   r5, r0, 0               ; Inicializacia i = 0
        daddi   r7, r0, 1               ; Inicializacia j = 1
        daddi   r11, r10, -1            ; Inicializacia max_swaps = r10 - 1 (dlzka retazcka - 1), pocet moznych swapov
        j       inner_loop              ; Skoci na inner_loop
inner_loop:
        lb      r6, login(r5)           ; Nacita znak do r6 z login[i]
        lb      r8, login(r7)           ; Nacita znak do r8 z login[j]
        beqz    r11, no_swap            ; Ak je max_swaps nula, skoci na no_swap
        sltu    r1, r6, r8              ; Porovna dva znaky
        beq     r6, r8, lower_strlen    ; Ak su znaky rovnake, skoci na lower_strlen
        bnez    r1, lower_strlen        ; Ak je r6 mensi ako r6, skoci na lower_strlen
        sb      r6, login(r7)           ; r6 sa ulozi na poziciu r7 v retazci
        sb      r8, login(r5)           ; r8 sa ulozi na poziciu r5 v retazci
        daddi   r11, r11, -1            ; Znizi sa pocet moznych swappov, max_swaps--
        daddi   r3, r3, 1               ; Nastavi swapped na 1
        daddi   r5, r5, 1               ; i++
        daddi   r7, r7, 1               ; j++
        j       inner_loop              ; Skoci naspat na inner_loop

lower_strlen:
        daddi   r11, r11, -1            ; Znizi sa pocet moznych swappov, max_swaps--
        daddi   r5, r5, 1               ; i++
        daddi   r7, r7, 1               ; j++
        j       inner_loop              ; Skoci na inner_loop

no_swap:
        daddi   r10, r10, -1            ; Znizi sa dlzka retazca, strlen--
        j       outer_loop              ; Skoc spat na outer_loop
        
bsort_quit:
        daddi   r4, r0, login           ; vozrovy vypis: adresa login: do r4
        jal     print_string            ; vypis pomoci print_string - viz nize
        syscall 0                       ; halt


print_string:                           ; adresa retezce se ocekava v r4
        sw      r4, params_sys5(r0)
        daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
        syscall 5                       ; systemova procedura - vypis retezce na terminal
        jr      r31                     ; return - r31 je urcen na return address
