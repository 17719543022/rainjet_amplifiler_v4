module ascii_2_hex(
    input                       clk,
    input      [ 7:0]           asiic_in,
    
    output reg [ 3:0]           hex_out
);

always @(posedge clk)
    case (asiic_in)
    "0": hex_out <= 4'h0;
    "1": hex_out <= 4'h1;
    "2": hex_out <= 4'h2;
    "3": hex_out <= 4'h3;
    "4": hex_out <= 4'h4;
    "5": hex_out <= 4'h5;
    "6": hex_out <= 4'h6;
    "7": hex_out <= 4'h7;
    "8": hex_out <= 4'h8;
    "9": hex_out <= 4'h9;
    "A": hex_out <= 4'ha;
    "B": hex_out <= 4'hb;
    "C": hex_out <= 4'hc;
    "D": hex_out <= 4'hd;
    "E": hex_out <= 4'he;
    "F": hex_out <= 4'hf;
    "a": hex_out <= 4'ha;
    "b": hex_out <= 4'hb;
    "c": hex_out <= 4'hc;
    "d": hex_out <= 4'hd;
    "e": hex_out <= 4'he;
    "f": hex_out <= 4'hf;
    default: hex_out <= 4'h0;
    endcase

endmodule
