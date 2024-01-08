; program assembly yang menghitung suhu
; menggunakan aplikasi emu8086

name "temperature-calculator"

org 100h

.data
    msg1 db "Masukkan suhu dalam Celsius: $"
    msg2 db "Suhu dalam Fahrenheit: $"
    msg3 db "Suhu dalam Kelvin: $"
    msg4 db "Suhu dalam Reamur: $"
    input db 10 dup(0) ; buffer untuk menyimpan input
    f dw 0 ; variabel untuk menyimpan Fahrenheit
    k dw 0 ; variabel untuk menyimpan Kelvin
    r dw 0 ; variabel untuk menyimpan Reamur

.code
    ; menampilkan pesan pertama
    mov dx, offset msg1
    mov ah, 9
    int 21h

    ; membaca input dari keyboard
    mov dx, offset input
    mov ah, 0ah
    int 21h

    ; mengkonversi input menjadi angka
    mov si, offset input + 2 ; melewati panjang dan enter
    mov cx, 0 ; cx = 0
    mov bx, 10 ; bx = 10
loop1:
    mov al, [si] ; al = karakter
    cmp al, 0dh ; jika al = enter, berhenti
    je stop1
    sub al, 30h ; al = al - 30h
    mul bx ; ax = ax * bx
    add cx, ax ; cx = cx + ax
    inc si ; si = si + 1
    jmp loop1 ; ulangi loop1
stop1:
    ; cx sekarang berisi nilai suhu dalam Celsius

    ; menghitung suhu dalam Fahrenheit
    mov ax, cx ; ax = cx
    mov bx, 9 ; bx = 9
    mul bx ; ax = ax * bx
    mov bx, 5 ; bx = 5
    div bx ; ax = ax / bx
    add ax, 32 ; ax = ax + 32
    mov f, ax ; f = ax

    ; menghitung suhu dalam Kelvin
    mov ax, cx ; ax = cx
    add ax, 273 ; ax = ax + 273
    mov k, ax ; k = ax

    ; menghitung suhu dalam Reamur
    mov ax, cx ; ax = cx
    mov bx, 4 ; bx = 4
    mul bx ; ax = ax * bx
    mov bx, 5 ; bx = 5
    div bx ; ax = ax / bx
    mov r, ax ; r = ax

    ; menampilkan baris baru
    mov ah, 2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h

    ; menampilkan pesan kedua
    mov dx, offset msg2
    mov ah, 9
    int 21h

    ; menampilkan suhu dalam Fahrenheit
    mov ax, f ; ax = f
    call print_num ; panggil subrutin print_num

    ; menampilkan baris baru
    mov ah, 2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h

    ; menampilkan pesan ketiga
    mov dx, offset msg3
    mov ah, 9
    int 21h

    ; menampilkan suhu dalam Kelvin
    mov ax, k ; ax = k
    call print_num ; panggil subrutin print_num

    ; menampilkan baris baru
    mov ah, 2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h

    ; menampilkan pesan keempat
    mov dx, offset msg4
    mov ah, 9
    int 21h

    ; menampilkan suhu dalam Reamur
    mov ax, r ; ax = r
    call print_num ; panggil subrutin print_num

    ; keluar dari program
    mov ah, 4ch
    int 21h

; subrutin untuk mencetak angka ke layar
print_num:
    mov bx, 10 ; bx = 10
    mov cx, 0 ; cx = 0
loop2:
    mov dx, 0 ; dx = 0
    div bx ; ax = ax / bx, dx = ax % bx
    push dx ; simpan sisa bagi di stack
    inc cx ; cx = cx + 1
    cmp ax, 0 ; jika ax = 0, berhenti
    je stop2
    jmp loop2 ; ulangi loop2
stop2:
    mov ah, 2 ; ah = 2
loop3:
    pop dx ; ambil sisa bagi dari stack
    add dl, 30h ; dl = dl + 30h
    int 21h ; cetak karakter
    dec cx ; cx = cx - 1
    cmp cx, 0 ; jika cx = 0, berhenti
    je stop3
    jmp loop3 ; ulangi loop3
stop3:
    ret ; kembali ke pemanggil

end
