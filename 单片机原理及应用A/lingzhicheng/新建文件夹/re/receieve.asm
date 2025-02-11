		ORG 0000h
		LJMP MAIN
		ORG 0100H
MAIN:  	MOV	SP,#60H	
		MOV TMOD,#20H
		MOV TH1,#0F4H
		MOV TL1,#0F4H
	   	MOV PCON,#80H
		SETB TR1
		MOV SCON,#50H
		MOV R0,#30H
		MOV R7,#00H				
		MOV R6,#00H				  	

REC:	JNB RI,REC					//接受访问请求
		CLR RI
		MOV A,SBUF
		CJNE A,#06H,SEND		   //判断接受到的是否为06H，
		LJMP SEND2
	
SEND:	MOV A,#15H				 //发送拒绝回应
		MOV SBUF,A
WAIT1: 	JNB TI,WAIT1
		CLR TI
		LJMP REC	   

SEND2:	MOV A,#00H			 //发送接受回应
		MOV SBUF,A
WAIT2: 	JNB TI,WAIT2
		CLR TI

REC1:	JNB RI,REC1		   //接受字符长度
		CLR RI
		MOV A,SBUF
		MOV R7,A			 //R7是字符长度
		MOV R6,A			//R6是校验和
REC2: 	JNB RI,REC2		   //接受数据
		CLR RI
		MOV A,SBUF
		MOV @R0,A
		ADD A,R6
		MOV R6,A
		INC R0
		DJNZ R7,REC2

REC3:  	JNB RI,REC3			  //接受校验位
		CLR RI
		MOV A,SBUF
		MOV 40H,R6
		CJNE A,40H,WRO		  //校验位判断正确或错误

TR:		MOV A,#0FH
	   	MOV SBUF,A
WAIT3:	JNB TI,WAIT3
		CLR TI
		SJMP $

WRO:	MOV A,#0F0H
		MOV SBUF,A
WAIT4:	JNB RI,WAIT4
		CLR RI
		SJMP $

END




			
