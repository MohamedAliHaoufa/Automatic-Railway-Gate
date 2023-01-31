;=========================================================================================================================================
; Name           : Automatic-Railway-Gate.asm
; Authors        : 
;    - Mr. Mohamed Ali Haoufa
;    - Mr. Mohamed Nacer Namane
; Created on     : Jun 15, 2020
; Description    : The main program of the Automatic Railway Gate in Assembly language using P16F84A Microcontroller and Infrared Sensors
;=========================================================================================================================================

      
; CIRCUIT DETAILS : 

; PORTA (INPUTS)
; A0 = Sensor1  A1 = Sensor2   A2 = Sensor3

;PORTB (OUTPUTS) 
; B0 = green light , B1 = orange light , B2 = red light , B4 = open the railway gate , B5 = close the railway gate , B6 = control the Buzzer
	  
									list p=16f84a
                   include <P16F84A.INC>
count EQU 0x0c
                       
              org    0x00
              bsf    STATUS,RP0  ; choosing bank 1 , RP0 is the Bank selection bit, put 0 for bank 0 and 1 for bank 1
              movlw  b'00000111'
              movwf  OPTION_REG  ; It's special register in bank 1 , first 3 bits for the Prescaler rate select, 111 = /256 Pre split rate of the TMR0 module
              movlw  0xff    	 ; put the 0xff value in w register 
              movwf  TRISA   	 ; configuring PortA as input 
              clrf   TRISB   	 ; configuring PortB as output
              bcf    STATUS,RP0  ; choosing bank 0
              clrf   count
              clrf   PORTB	 ; clear the PortB ( register located in bank 0 ) as output to avoid leaks 
              goto   boucle
  
           
boucle
              bsf    PORTB,0     ; turn on the Green light ( send 1 for 5V to RB0 )      
              call   delay 	 ; call the delay 
              btfsc  PORTA,0     ;  test if the Sensor1 detected or not , btfsc = Bit Test F Skip if Clear , if the register is 1 execute the next instrustion , if 0 the 2nd one instead 
	      goto   test
              goto   capd
test          btfsc  PORTA,2     ; test if the Sensor3 detected or not ( 0 means detected ) 
              goto   boucle 
              goto   cap
capd          bcf    PORTB,0     ; turn off the Green light ( send 0 for 0V or ground to RB0 )
	      bsf    PORTB,1     ; turn on the orange light 
              bsf    PORTB,6     ; turn on the buzzer ( setting output RB6 to 1 )
              bsf    PORTB,5     ; close the railway gate ( setting output RB5 to 1 )
              call   tempo 
              bcf    PORTB,5     ; stop the railway gate closing ( setting output RB5 to 0 )
bouc          btfsc  PORTA,1     ; test if the Sensor2 detected or not ( 0 means detected ) 
              goto   bouc
              bcf    PORTB,1     ; turn off the orange light 
              bsf    PORTB,2     ; turn on the red light 
boucl         btfss  PORTA,1     ; test if the Sensor2 closed or not ( 1 means closed ) 
              goto   boucl
	      call   delay
bouc2         btfsc  PORTA,2     ; test if the Sensor3 detected or not ( 0 means detected ) 
              goto   bouc2 
              bcf    PORTB,2     ; turn off the red light 
              bsf    PORTB,1     ; turn on the orange light 
bou           btfss  PORTA,2     ; test if the Sensor3 closed or not ( 1 means closed ) 
              goto   bou
              bsf    PORTB,4     ; open the railway gate
              bcf    PORTB,6     ; stop the buzzer 
              call   tempo       ; wait some time 
              clrf   PORTB       ; clear the PortB 
              goto   boucle
cap
	      bcf    PORTB,0     ; turn off the green light 
	      bsf    PORTB,1     ; turn on the orange light 
              bsf    PORTB,6     ; turn on the buzzer 
              bsf    PORTB,5     ; close the railway gate ( setting output RB5 to 1 )
              call   tempo 
              bcf    PORTB,5     ; stop the railway gate closing ( setting output RB5 to 0 )
boum          btfsc  PORTA,1     ; test if the Sensor2 detected or not ( 0 means detected ) 
              goto   boum
              bcf    PORTB,1     ; turn off the orange light
              bsf    PORTB,2     ; turn on the red light
boucg         btfss  PORTA,1     ; test if the Sensor2 closed or not ( 1 means closed )
              goto   boucg
              call   delay
bo2           btfsc  PORTA,0     ; test if the Sensor1 detected or not ( 0 means detected ) 
              goto   bo2
              bcf    PORTB,2     ; turn off the red light 
              bsf    PORTB,1     ; turn on the orange light
mam           btfss  PORTA,0     ; test if the Sensor1 closed or not ( 1 means closed )
              goto   mam
              bsf    PORTB,4     ; open the railway gate
              bcf    PORTB,6     ; stop the buzzer 
              call   tempo
              clrf   PORTB       ; clear the PortB 
              goto   boucle
tempo        
              movlw   .6
              movwf   0x0E
              movlw   0xff 
              movwf   0x0C 
              movlw   0xff
      loop1   movlw   0xff 
              movwf   0x0D 
      loop2   decfsz  0x0D,1      ; decrease the number one time by 1 and skip the next instruction if the number become 0 
              goto    loop2 
              decfsz  0x0C,1 
              goto    loop1 
              decfsz  0x0E,1 
              goto    loop1 
              return 
delay            
              movlw   .1
              movwf   0x10
              movlw   0xff 
              movwf   0x11
              movlw   0xff
      loop3   movlw   0xff 
              movwf   0x12
      loop4   decfsz  0x12,1 
              goto    loop4 
              decfsz  0x11,1 
              goto    loop3
              decfsz  0x10,1 
              goto    loop3
              return 
              end