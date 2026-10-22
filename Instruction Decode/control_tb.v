`timescale 1ns / 1ps


module control_tb(
    );
    reg     clk_tb, 
            rst_tb;
    reg [5:0] opcode_tb;        
    wire [1:0] wb_tb;
    wire [2:0] mem_tb;
    wire [3:0] ex_tb;        
    
    control DUT(
        .clk(clk_tb),
        .rst(rst_tb),
        .opcode(opcode_tb),
        .wb(wb_tb),
        .mem(mem_tb),
        .ex(ex_tb)                
        );
        
        initial
            begin
                clk_tb =0;
                forever #1 clk_tb = ~clk_tb;
            end
        
        parameter RTYPE = 6'b000000;
        parameter LW = 6'b100011;
        parameter SW = 6'b101011;
        parameter BEQ = 6'b000100;
        parameter NOP = 6'b100000;
        
        initial
            begin
                rst_tb = 1;
                opcode_tb = RTYPE;
                #2
                
                rst_tb = 0;
                #2
                opcode_tb = LW;
                #2
                opcode_tb = SW;
                #2
                
                opcode_tb = BEQ;
                #2
                
                opcode_tb = NOP;
                #2
                
                opcode_tb = 6'b111100;
                #2
                $display("Test Complete");
                
                $finish;
            end
            
        initial
            begin
                $monitor("Time=%0t opcode=%b wb=%b, mem=%b, ex=%b, rst=%b",
                        $time, opcode_tb, wb_tb, mem_tb, ex_tb, rst_tb);
            end    
    
endmodule
