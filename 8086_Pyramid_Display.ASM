Progr           segment
                assume  cs:Progr, ds:dane, ss:stosik

start:          mov     ax,dane
                mov     ds,ax
                mov     ax,stosik
                mov     ss,ax
                mov     sp,offset szczyt



                mov ax,0b800h
                mov es,ax       ;ustawienie początku dodatkowego segmentu na 0b800h
                mov di,0        ;ustawienie wartosci przemieszczenia (offset)
                mov cx,24       ;24 wiersze ekranu
                mov al," "      ;znak do al
cls1:           push cx         ;odlozenie 2 bajtów na stos
                mov cx,80
cls2:           mov es:[di],al  ;wsadzenie znaku do sumy adresu logicznego (ES) oraz adresu efektywnego (DI), czyli adresu fizycznego
                add di,2        ;offset +2 dla kolejnego miejsca na ekranie
                loop cls2
                pop cx
                loop cls1       ;skok jesli cx != 0, cx--


                mov di,240    ; kursor na srodku 2 wiersza
                mov cx,23     ; ilosc wierszy
                mov dx,0      ; ilosc znakow w wierszu -1
                mov bx,160    ; przesuniecie 'monitora' w prawo

                mov al,"A"    ; znak
petla:          push cx       ; odlozenie ilosci wierszy na stos
                mov cx,dx     ; ilosc znakow do cx
                inc cx        ; il. znakow ++ dla petli
                add di,2      ; przesuniecie o 2 prawo ekranu
petladx:        mov es:[di],al; wypisywanie znaku na ekran
                add di,2      ; przesuniecie ekranu | dodawanie, wynik zapisany w di
                loop petladx  ; dopoki nie wypisze dx znakow
                add dx,2      ; zwiekszenie ilosci znakow o 2 dla nowego wiersza
                push dx       ; dx na stos [pamietajka]
                add di,bx     ; przesuwanie ekranu do nowej lini
                mov cx,dx     ; ilosc znakow do cx
                inc cx        ; il. znak ++ dla petli
loop1:          add dx,2      ; mnozenie przez dodawanie, bo MUL mnoży z wykorzystaniem oraz zapisuje w AX, a nie chcemy
                loop loop1    ; ilosc znakow x2 bo ekran
                sub di,dx     ; odjecie przesuniecia spowodowanego przez wpisywanie znaku na ekran w petli wyzej
                pop dx        ; odczytanie ilosci znakow
                add di,dx     ; dodanie ilosci znakow do pozycji kursora
                inc al        ; nastepna litera
                pop cx        ; odczytanie ile jeszcze wierszy
                loop petla    ; nowy wiersz


                mov     ah,4ch
                mov         al,0
                int         21h
Progr           ends

dane            segment
		d1 dw 16

dane            ends

stosik          segment
                dw    100h dup(0)
szczyt          Label word
stosik          ends

end start