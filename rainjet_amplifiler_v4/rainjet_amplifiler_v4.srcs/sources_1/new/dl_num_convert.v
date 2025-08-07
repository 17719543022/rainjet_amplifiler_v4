module dl_num_convert(
    input                   clk,
    input      [ 7:0]       dl_num,
    output reg [63:0]       dl_index
);

always @(posedge clk)
    case (dl_num)
    'd1 : dl_index <= 64'h000000E000000001;
    'd2 : dl_index <= 64'h0000000000000002;
    'd3 : dl_index <= 64'h0000000000000004;
    'd4 : dl_index <= 64'h0000000000000008;
    'd5 : dl_index <= 64'h0000000000000010;
    'd6 : dl_index <= 64'h000000E000000020;
    'd7 : dl_index <= 64'h000000E000000040;
    'd8 : dl_index <= 64'h000000E000000080;
    'd9 : dl_index <= 64'h0000000000000100;
    'd10: dl_index <= 64'h0000000000000200;
    'd11: dl_index <= 64'h0000000000000400;
    'd12: dl_index <= 64'h000000E000000800;
    'd13: dl_index <= 64'h000000E000001000;
    'd14: dl_index <= 64'h000000E000002000;
    'd15: dl_index <= 64'h000000E000004000;
    'd16: dl_index <= 64'h000000E000008000;
    'd17: dl_index <= 64'h000000E000010000;
    'd18: dl_index <= 64'h000000E000020000;
    'd19: dl_index <= 64'h000000E000040000;
    'd20: dl_index <= 64'h000000E000080000;
    'd21: dl_index <= 64'h000000E000100000;
    'd22: dl_index <= 64'h0000000000200000;
    'd23: dl_index <= 64'h0000000000400000;
    'd24: dl_index <= 64'h0000000000800000;
    'd25: dl_index <= 64'h0000000001000000;
    'd26: dl_index <= 64'h0000000002000000;
    'd27: dl_index <= 64'h0000000004000000;
    'd28: dl_index <= 64'h0000000008000000;
    'd29: dl_index <= 64'h0000000010000000;
    'd30: dl_index <= 64'h0000000020000000;
    'd31: dl_index <= 64'h000000E040000000;
    'd32: dl_index <= 64'h000000E080000000;
    'd33: dl_index <= 64'h0000000100000000;
    'd34: dl_index <= 64'h0000000200000000;
    'd35: dl_index <= 64'h000000E400000000;
    'd36: dl_index <= 64'h000000E800000000;
    default: dl_index <= 64'h0;
    endcase




endmodule
