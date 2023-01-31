;===========================================================================================================================================
; Name           : The-Control-Program-Automatic-Railway-Gate.asm
; Authors        : 
;    - Mr. Mohamed Ali Haoufa
;    - Mr. Mohamed Nacer Namane
; Created on     : Jun 15, 2020
; Description    : The Control Program of the Automatic Railway Gate Project that was used to realize the the Automated Proteus Simulation.
;============================================================================================================================================

; CIRCUIT DETAILS : 

;PORTB (OUTPUTS) 
; B0 = Sensor1 Control, B1 = Sensor2 Control, B2 = Sensor3 Control

 list p=16f84a
                   include <P16F84A.INC>
		   
              org    0x00
              bsf    STATUS,RP0
              movlw  b'00000111'
              movwf  OPTION_REG 
              movlw  0xff
              clrf   TRISB
              bcf    STATUS,RP0
              clrf   PORTB
	      bsf    PORTB,0
	      bsf    PORTB,1
	      bsf    PORTB,2
	  
boucle
	      ; The Control commands to show the automated Proteus simulation when the train comes from the right side :
              call   tempo
	      bcf    PORTB,0	; The Sensor1 detected the arrival of the train ( 0 means detected ) 
	      call   delay	; call the delay
	      bcf    PORTB,1	; The Sensor2 detected the arrival of the train 
	      bsf    PORTB,0	; The train passed the sensor1 ( 1 means not detected ) 
	      call   delay	
	      bcf    PORTB,2	; The Sensor3 detected the arrival of the train  
	      bsf    PORTB,1	; The train passed the sensor2 
	      call   delay	
	      bsf    PORTB,2	; The train passed the sensor3 
	      
	      ; The Control commands to show the automated Proteus simulation when the train comes from the opposite (left) side : 
	      call   tempo	
	      bcf    PORTB,2	; The Sensor3 detected the arrival of the train 
	      call   delay	
	      bcf    PORTB,1	; The Sensor2 detected the arrival of the train 
	      bsf    PORTB,2	; The train passed the sensor3 
	      call   delay		      
	      bcf    PORTB,0	; The Sensor1 detected the arrival of the train 
	      bsf    PORTB,1	; The train passed the sensor2 
	      call   delay	
	      bsf    PORTB,0	; The train passed the sensor1 
	      goto   boucle	; Repeat the Control process
	      
tempo        
              movlw   .3
              movwf   0x0E
              movlw   0xff 
              movwf   0x0C 
              movlw   0xff
      loop1   movlw   0xff 
              movwf   0x0D 
      loop2   decfsz  0x0D,1 
              goto    loop2 
              decfsz  0x0C,1 
              goto    loop1 
              decfsz  0x0E,1 
              goto    loop1 
              return 
delay            
              movlw   .3
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