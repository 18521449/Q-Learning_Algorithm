	module multiple_fp(out, input_a, input_b, clk, rst_n, valid_in, valid_out);

  input     clk;
  input     rst_n;
  input 		valid_in;
  input     [31:0] input_a; 
  input     [31:0] input_b;  

  output    [31:0] out;
  output    valid_out;
 
  reg       s_output_z_ack;
  reg       [31:0] s_output_z;
  reg       s_input_a_ack;
  reg       s_input_b_ack;

  reg       [3:0] state = 4'd0; 
  parameter get         = 4'd0,            
            unpack        = 4'd1,
            special_cases = 4'd2,
            normalise_a   = 4'd3,
            
            multiply_0    = 4'd4,
            multiply_1    = 4'd5,
            normalise_1   = 4'd6,
            round         = 4'd7,
            pack          = 4'd8,
            put_z         = 4'd9;

  reg       [31:0] a, b, z;
  reg       [23:0] a_m, b_m, z_m;
  reg       [8:0] a_e, b_e, z_e;
  reg       a_s, b_s, z_s;
  reg       guard, round_bit, sticky;
  reg       [47:0] product;
  reg 		    [23:0] product1;
 always @(posedge clk)
 begin	 
	if (valid_in) begin
    case(state)

      get:
      begin
			   s_output_z_ack <= 0;
         a <= input_a;  
    			  b <=input_b;
         state <= unpack;     
      end      

      unpack:
      begin   
        a_m <= a[22 : 0];
        b_m <= b[22 : 0];
        a_e <= a[30 : 23] - 127;
        b_e <= b[30 : 23] - 127;
        a_s <= a[31];
        b_s <= b[31];
		    state <= special_cases;		   
      end

      special_cases:
      begin
        if ((a_e == 128 && a_m != 0) || (b_e == 128 && b_m != 0)) begin
          z[31] <= 1;
          z[30:23] <= 255;
          z[22] <= 1;
          z[21:0] <= 0;
			    state <= put_z;
        end else if (a_e == 128) begin
          z[31] <= a_s ^ b_s;
          z[30:23] <= 255;
          z[22:0] <= 0;

          if (($signed(b_e) == -127) && (b_m == 0)) begin
            z[31] <= 1;
            z[30:23] <= 255;
            z[22] <= 1;
            z[21:0] <= 0;
          end         
			 state <= put_z;
        
        end else if (b_e == 128) begin
          z[31] <= a_s ^ b_s;
          z[30:23] <= 255;
          z[22:0] <= 0;

          if (($signed(a_e) == -127) && (a_m == 0)) begin
            z[31] <= 1;
            z[30:23] <= 255;
            z[22] <= 1;
            z[21:0] <= 0;
          end			
        state <= put_z;
        
		  //if a is zero return zero
        end else if (($signed(a_e) == -127) && (a_m == 0)) begin
          z[31] <= a_s ^ b_s;
          z[30:23] <= 0;
          z[22:0] <= 0;
          state <= put_z;
        //if b is zero return zero
        end else if (($signed(b_e) == -127) && (b_m == 0)) begin
          z[31] <= a_s ^ b_s;
          z[30:23] <= 0;
          z[22:0] <= 0;
          state <= put_z;
       end else begin
          //Denormalised Number
          if ($signed(a_e) == -127) begin
            a_e <= -126;
          end else begin
            a_m[23] <= 1;
          end
          //Denormalised Number
          if ($signed(b_e) == -127) begin
            b_e <= -126;
          end else begin
            b_m[23] <= 1;
          end         
			 state <= normalise_a;
        end
      end

      normalise_a:		
		  begin
		    if (a_m[23] && b_m[23]) begin         
			     state <= multiply_0;			 
        end else begin
          a_m <= a_m << 1;
          a_e <= a_e - 1;   		 
          b_m <= b_m << 1;
          b_e <= b_e - 1;
        end
      end
      
      multiply_0:
      begin
      //cpu_wb_cla_multiplier #(.MULTIPLIER_WID(a_m) multi (a_m, b_m, product1);
		    z_s <= a_s ^ b_s;
        z_e <= a_e + b_e +1 ;
      //cpu_wb_cla_multiplier multi((a_m), (b_m), (product));
		    product <= a_m * b_m ;
		  //product <= product1;
        state <= multiply_1;
      end

      multiply_1:
      begin
        z_m <= product[47:24];
        guard <= product[23];
        round_bit <= product[22];
        sticky <= (product[21:0] != 0);
        state <= normalise_1;
		  end

      normalise_1:
      begin
        if (z_m[23] == 0) begin
          z_e <= z_e - 1;
          z_m <= z_m << 1;
          z_m[0] <= guard;
          guard <= round_bit;
          round_bit <= 0;
        end else begin
			    state <= round;
        end
      end

      round:
      begin
        if (guard && (round_bit | sticky | z_m[0])) begin
          z_m <= z_m + 1;          
        end
        state <= pack;
      end

      pack:
      begin
        z[22 : 0] <= z_m[22:0];
        z[30 : 23] <= z_e[7:0] + 127;
        z[31] <= z_s;
        if ($signed(z_e) == -126 && z_m[23] == 0) begin
          z[30 : 23] <= 0;
        end
        if ($signed(z_e) > 127) begin
          z[22 : 0] <= 0;
          z[30 : 23] <= 255;
          z[31] <= z_s;
        end        
		    state <= put_z;
      end

      put_z:
      begin
		    s_output_z_ack <= 1;
        s_output_z <= z;
        state <= get;
      end
      
    endcase

    if (rst_n == 0) begin
      state <= get;
      s_output_z_ack <= 0;
    end
  end
end
 
  assign valid_out = s_output_z_ack;
  assign out = s_output_z;
endmodule


