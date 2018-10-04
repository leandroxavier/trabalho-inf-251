
module ff ( input data, input c, input r, output q);
reg q;
always @(posedge c or negedge r) 
begin
 if(r==1'b0)
  q <= 1'b0; 
 else 
  q <= data; 
end 
endmodule //End 

module statem(clk, reset, a, saida);
input clk, reset;
input [1:0] a;
output [2:0] saida;
reg [2:0] state;
parameter zero=3'd0, um=3'd1, dois=3'd2, tres=3'd3, quatro=3'd4, cinco=3'd5, seis=3'd6, sete = 3'd7;

assign saida = (state == zero)? 3'd0:
       (state == um)? 3'd1:
       (state == dois)? 3'd2:
	   (state == tres)? 3'd3:
	   (state == quatro)? 3'd4:
       (state == cinco)? 3'd5:
       (state == seis)? 3'd6: 3'd3;

always @(posedge clk or negedge reset)
     begin
          if (reset==0)
               state = zero;
          else
               case (state)
                    zero: 
                        if(a == 2'd0) state = um;
                        else if(a == 2'd1) state = tres;
                        else if(a == 2'd2) state = um;
                        else state = cinco;
                                        
                    um: 
                        if(a == 2'd0) state = dois;
                        else if(a == 2'd1) state = tres;
                        else if(a == 2'd2) state = tres;
                        else state = cinco;
			            
                    dois: 
                        if(a == 2'd0) state = zero;
                        else if(a == 2'd1) state = quatro;
                        else if(a == 2'd2) state = sete;
                        else state = cinco;
			            
                    tres:
                        if(a == 2'd0) state = zero;
                        else if(a == 2'd1) state = dois;
                        else if(a == 2'd2) state = dois;
                        else state = cinco;
                        
                    quatro: 
                        if(a == 2'd0) state = zero;
                        else if(a == 2'd1) state = tres;
                        else if(a == 2'd2) state = um;
                        else state = cinco;

                    cinco:
                        if(a == 2'd0) state = zero;
                        else if(a == 2'd1) state = tres;
                        else if(a == 2'd2) state = um;
                        else state = seis;

                    seis:
                        if(a == 2'd0) state = zero;
                        else if(a == 2'd1) state = tres;
                        else if(a == 2'd2) state = um;
                        else state = tres;

                    sete:
                        if(a == 2'd0) state = zero;
                        else if(a == 2'd1) state = tres;
                        else if(a == 2'd2) state = um;
                        else state = cinco;
               endcase

     end
endmodule


// FSM com portas logicas
module statePorta(input clk, input res, input [1:0]a, output [2:0] s);
wire [2:0] e;
wire [2:0] p;
parameter tres=3'd3, sete = 3'd7;

assign s = (e == sete)? tres: e;

assign p[0] = ~e[0]&a[1] |~e[2]&~e[1]&~e[0] | ~e[2]&~e[1]&a[0] | ~e[2]&~e[1]&a[1] | e[1]&a[1]&a[0] | e[2]&~a[1]&a[0] | e[2]&a[1]&~a[0]; 
assign p[1] = ~e[1]&~a[1]&a[0] | e[0]&~a[1]&a[0] | ~e[2]&~e[1]&e[0]&~a[0] | ~e[2]&e[1]&a[1]&~a[0] | e[2]&~e[1]&e[0]&a[0] | e[2]&e[1]&~e[0]&a[0];
assign p[2] = ~e[1]&a[1]&a[0] | e[0]&a[1]&a[0] | ~e[2]&e[1]&~e[0]&a[0] | ~e[2]&e[1]&~e[0]&a[1];
ff  e0(p[0],clk,res,e[0]);
ff  e1(p[1],clk,res,e[1]);
ff  e2(p[2],clk,res,e[2]);

endmodule 

//Máquina de estados 
module stateMem(input clk,input res, input [1:0]a, output [2:0] saida);
reg [5:0] StateMachine [0:31]; // 16 linhas e 6 bits de largura
initial
begin  
StateMachine[0] = 6'h1;  StateMachine[1] = 6'h3; 
StateMachine[2] = 6'h1;  StateMachine[3] = 6'h5;
StateMachine[4] = 6'hA;  StateMachine[5] = 6'hB;
StateMachine[6] = 6'hB;  StateMachine[7] = 6'hD;
StateMachine[8] = 6'h10;  StateMachine[9] = 6'h14;
StateMachine[10] = 6'h17;  StateMachine[11] = 6'h15;
StateMachine[12] = 6'h18;  StateMachine[13] = 6'h1A;
StateMachine[14] = 6'h1A;  StateMachine[15] = 6'h1D;
StateMachine[16] = 6'h20;  StateMachine[17] = 6'h23;
StateMachine[18] = 6'h21;  StateMachine[19] = 6'h25;
StateMachine[20] = 6'h28;  StateMachine[21] = 6'h2B;
StateMachine[22] = 6'h29;  StateMachine[23] = 6'h2E;
StateMachine[24] = 6'h30;  StateMachine[25] = 6'h33;
StateMachine[26] = 6'h31;  StateMachine[27] = 6'h33;
StateMachine[28] = 6'h18;  StateMachine[29] = 6'h1B;
StateMachine[30] = 6'h19;  StateMachine[31] = 6'h1D;

end

wire [4:0] address;  // 16 linhas = 4 bits de endereco
wire [5:0] dout; // 6 bits de largura 3+3 = proximo estado + saida
assign address[1:0] = a;
assign dout = StateMachine[address];
assign saida = dout[5:3];
ff st0(dout[0],clk,res,address[2]);
ff st1(dout[1],clk,res,address[3]);
ff st2(dout[2],clk,res,address[4]);
endmodule

module main;
reg c,res;
reg [1:0]a;
wire [2:0] saida0;
wire [2:0] saida1;
wire [2:0] saida2;

statem FSM0(c,res,a,saida0);
statePorta FSM1(c,res,a, saida1);
stateMem FSM2(c,res,a,saida2);

initial
    c = 1'b0;
  always
    c= #(1) ~c;

// visualizar formas de onda usar gtkwave out.vcd
initial  begin
     $dumpfile ("out.vcd"); 
     $dumpvars; 
   end 

  initial 
    begin
     $monitor($time," c %b res %b a %b saida0  ",c,res,a,saida0);
      #1 res=0; a=2'd0;
      #1 res=1; a= 2'd1;
      #10 a= 2'd2;
      #10 a= 2'd2;
      #10 a= 2'd1;
      #10 a= 2'd1;
      #10 a= 2'd3;
     #10;
    
      $finish;
       #10;
      
    end
endmodule
