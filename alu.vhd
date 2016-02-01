library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.all;

entity alu is 
  port (
    operation: in std_logic_vector(3 downto 0); -- 4 bit opcode from IDU
    shift_rotate_operation: in std_logic_vector(2 downto 0); -- from IDU
    operand_a,operand_b : in std_logic_vector(7 downto 0); -- first and second operands
    result:out std_logic_vector(7 downto 0); -- result
    zero,carry : out std_logic; -- zero and carry
    input_port:in std_logic_vector(7 downto 0); -- data from a peripheral device (out of the microcontroller)
    port_address: in std_logic_vector(7 downto 0); -- port_ID from IDU
    output_port: out std_logic_vector(7 downto 0); -- data for a peripheral device (out of the microcontroller)
    port_ID: out std_logic_vector(7 downto 0) -- port_ID for a peripheral device (out of the microcontroller)
  );
end alu;

architecture dataflow of alu is 
signal temp: std_logic_vector(8 downto 0);
begin
  process(operand_a,operand_b) begin
    case operation is
      when "0001"=> temp <= std_logic_vector(resize((signed(operand_a) and signed(operand_b)),temp'length));
      when "0010"=> temp <= std_logic_vector(resize((signed(operand_a) or  signed(operand_b)),temp'length));
      when "0011"=> temp <= std_logic_vector(resize((signed(operand_a) xor signed(operand_b)),temp'length));
      when "0100"=> temp <= std_logic_vector(resize((signed(operand_a)  +  signed(operand_b)),temp'length));
      when "0110"=> temp <= std_logic_vector(resize((signed(operand_a)  -  signed(operand_b)),temp'length));
      
      when "1000"=> temp <= to_stdlogicvector(to_bitvector('0' & operand_a) sll to_integer(unsigned(shift_rotate_operation)));
      when "1001"=> temp <= to_stdlogicvector(to_bitvector('0' & operand_a) sla to_integer(unsigned(shift_rotate_operation)));
      when "1010"=> temp <= to_stdlogicvector(to_bitvector('0' & operand_a) srl to_integer(unsigned(shift_rotate_operation)));
      when "1011"=> temp <= to_stdlogicvector(to_bitvector('0' & operand_a) sra to_integer(unsigned(shift_rotate_operation)));
      when "1100"=> temp <= to_stdlogicvector(to_bitvector('0' & operand_a) rol to_integer(unsigned(shift_rotate_operation)));
      when "1101"=> temp <= to_stdlogicvector(to_bitvector('0' & operand_a) ror to_integer(unsigned(shift_rotate_operation)));
      when others => temp <= "ZZZZZZZZZ";
   end case;
 end process;
 
 
 output_port<="ZZZZZZZZ";
 
 zero <= '1' when temp(7 downto 0)="00000000" else '0';
 carry <= '1' when temp(8)='1' else '0';
 result <= temp(7 downto 0);

end dataflow;

