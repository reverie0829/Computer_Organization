`timescale 1ns/10ps
module traffic_light (clk,rst,pass,R,G,Y);
input clk , rst , pass ;
output  R,G,Y;

reg R,G,Y;
reg [1:0] counter;
reg [2:0] state, nextstate;
reg [11:0] count = 0, nextcount = 1;
parameter Green1=3'b000, Green2=3'b010, Green3=3'b100, Yellow1=3'b101, Red1=3'b110;
parameter None1=3'b001, None2=3'b011;
parameter cycle1024='d1024, cycle512='d512, cycle128='d128;
parameter recount=2'b01, plus=2'b00, stay=2'b10;


always @(posedge clk or rst or pass)
begin
	if(rst == 1'b1) 
	begin
		state <= Green1;
		count <= 0;
	end
	else 
	begin 
		state <= nextstate;
		count <= nextcount;
	end
end		


//Next State Logic
always@(pass or state or count)
begin
	if (pass == 1'b1)
	begin
		if (state == Green1)begin nextstate <= Green1; counter <= stay; end
		else begin nextstate <= Green1; counter <= recount; end
	end
	else
	begin
		case(state)
		Green1: 
		begin
			if(count == cycle1024)begin nextstate <= None1; counter <= recount; end
			else begin nextstate <= Green1; counter <= plus; end
		end
		None1: 
		begin
			if(count == cycle128)begin nextstate <= Green2; counter <= recount; end
			else begin nextstate <= None1; counter <= plus; end
		end
		Green2: 
		begin
			if(count == cycle128)begin nextstate <= None2; counter <= recount; end
			else begin nextstate <= Green2; counter <= plus; end
		end
		None2: 
		begin
			if(count == cycle128)begin nextstate <= Green3; counter <= recount; end
			else begin nextstate <= None2; counter <= plus; end
		end
		Green3: 
		begin
			if(count == cycle128)begin nextstate <= Yellow1; counter <= recount; end
			else begin nextstate <= Green3; counter <= plus; end
		end
		Yellow1: 
		begin
			if(count == cycle512)begin nextstate <= Red1; counter <= recount; end			
			else begin nextstate <= Yellow1; counter <= plus; end
		end
		Red1: 
		begin
			if(count == cycle1024)begin nextstate <= Green1; counter <= recount; end			
			else begin nextstate <= Red1; counter <= plus; end
		end
		endcase
	end
end

//cycle control
always@(state or count or counter)
begin
	case(counter)
	plus :
	begin nextcount <= count+1;	end
	recount :
	begin nextcount <= 1; end
	stay :
	begin nextcount <= count; end
	endcase
end

//Output Logic
always @(state)
begin
  case(state)
      Green1:
	  	begin R<=1'b0; G<=1'b1; Y<=1'b0;  end
      None1:
	  	begin R<=1'b0; G<=1'b0; Y<=1'b0;  end
      Green2:
	  	begin R<=1'b0; G<=1'b1; Y<=1'b0;  end
      None2:
	  	begin R<=1'b0; G<=1'b0; Y<=1'b0;  end
      Green3:
	  	begin R<=1'b0; G<=1'b1; Y<=1'b0;  end
      Yellow1:
	  	begin R<=1'b0; G<=1'b0; Y<=1'b1;  end
      Red1:
	  	begin R<=1'b1; G<=1'b0; Y<=1'b0;  end
      endcase
end


initial begin
  $dumpfile("traffic_light.VCD");
  $dumpvars;
end
endmodule