`timescale 1ns/1ps

module tb_float_add_sub;

    // Сигналы для DUT
    reg  [31:0] num_1;
    reg  [31:0] num_2;
    wire        OL;
    wire        OR;
    wire [31:0] sum_float;
    
    // Подключение DUT
    floating_point_summator dut (
        .num_1(num_1),
        .num_2(num_2),
        .OL(OL),
        .OR(OR),
        .sum_float(sum_float)
    );
    
    // Функция преобразования IEEE 754 в real
    function real ieee754_to_real(input [31:0] ieee);
        reg        sign;
        reg [7:0]  exp;
        reg [22:0] mant;
        real       mantissa;
        real       result;
    begin
        sign = ieee[31];
        exp  = ieee[30:23];
        mant = ieee[22:0];
        
        if (exp == 8'hFF) begin
            if (mant == 23'h0)
                result = (sign) ? -1.0/0.0 : 1.0/0.0;
            else
                result = 0.0/0.0;
        end
        else if (exp == 8'h00) begin
            mantissa = $itor(mant) / 8388608.0;
            result = (sign) ? -mantissa * 2.0**-126 : mantissa * 2.0**-126;
        end
        else begin
            mantissa = 1.0 + $itor(mant) / 8388608.0;
            result = (sign) ? -mantissa * 2.0**(exp - 127) : mantissa * 2.0**(exp - 127);
        end
        return result;
    end
    endfunction
    
    // Функция для форматирования бинарного представления
    function [31:0] hex_to_binary(input [31:0] hex);
        return hex;
    endfunction
    
    // Функция для вывода бинарной строки
    function string binary_string(input [31:0] value);
        string s;
        integer i;
    begin
        s = "";
        for (i = 31; i >= 0; i = i - 1) begin
            if (value[i])
                s = {s, "1"};
            else
                s = {s, "0"};
            if (i == 31 || i == 23)
                s = {s, " "};
        end
        return s;
    end
    endfunction
    
    // Функция для разбора числа на компоненты
    function string parse_float(input [31:0] value);
        reg sign;
        reg [7:0] exp;
        reg [22:0] mant;
        string s;
    begin
        sign = value[31];
        exp = value[30:23];
        mant = value[22:0];
        s = $sformatf("S=%b E=%h(%0d) M=%h", sign, exp, exp, mant);
        return s;
    end
    endfunction
    
    initial begin
        real num1_real, num2_real, expected_real, actual_real;
        integer test_num;
        bit test_passed;
        real tolerance = 1e-6;
        reg [31:0] expected_hex;
        
        $display("==================================================");
        $display("Testing addition of positive and negative numbers");
        $display("==================================================");
        $display("");
        $display("Format: S EEEEEEEE MMMMMMMMMMMMMMMMMMMMMMM");
        $display("");
        
        // Тест 1: 5.0 + (-3.0) = 2.0
        test_num = 1;
        num_1 = 32'h40A00000; // 5.0
        num_2 = 32'hC0400000; // -3.0
        expected_hex = 32'h40000000; // 2.0
        #10;
        num1_real = ieee754_to_real(num_1);
        num2_real = ieee754_to_real(num_2);
        expected_real = num1_real + num2_real;
        actual_real = ieee754_to_real(sum_float);
        test_passed = compare_float(expected_real, actual_real, tolerance);
        $display("Test %2d: %f + (%f) = %f", test_num, num1_real, num2_real, expected_real);
        $display("  num1     = %s (0x%08h)", binary_string(num_1), num_1);
        $display("  num2     = %s (0x%08h)", binary_string(num_2), num_2);
        $display("  Expected = %s (0x%08h) %s", binary_string(expected_hex), expected_hex, parse_float(expected_hex));
        $display("  Got      = %s (0x%08h) %s", binary_string(sum_float), sum_float, parse_float(sum_float));
        $display("  Result: %s", test_passed ? "PASSED" : "FAILED");
        $display("");
        
        // Тест 2: 10.5 + (-4.25) = 6.25
        test_num = 2;
        num_1 = 32'h41280000; // 10.5
        num_2 = 32'hC0880000; // -4.25
        expected_hex = 32'h40C80000; // 6.25
        #10;
        num1_real = ieee754_to_real(num_1);
        num2_real = ieee754_to_real(num_2);
        expected_real = num1_real + num2_real;
        actual_real = ieee754_to_real(sum_float);
        test_passed = compare_float(expected_real, actual_real, tolerance);
        $display("Test %2d: %f + (%f) = %f", test_num, num1_real, num2_real, expected_real);
        $display("  num1     = %s (0x%08h)", binary_string(num_1), num_1);
        $display("  num2     = %s (0x%08h)", binary_string(num_2), num_2);
        $display("  Expected = %s (0x%08h) %s", binary_string(expected_hex), expected_hex, parse_float(expected_hex));
        $display("  Got      = %s (0x%08h) %s", binary_string(sum_float), sum_float, parse_float(sum_float));
        $display("  Result: %s", test_passed ? "PASSED" : "FAILED");
        $display("");
        
        // Тест 3: 0.5 + (-0.25) = 0.25
        test_num = 3;
        num_1 = 32'h3F000000; // 0.5
        num_2 = 32'hBE800000; // -0.25
        expected_hex = 32'h3E800000; // 0.25
        #10;
        num1_real = ieee754_to_real(num_1);
        num2_real = ieee754_to_real(num_2);
        expected_real = num1_real + num2_real;
        actual_real = ieee754_to_real(sum_float);
        test_passed = compare_float(expected_real, actual_real, tolerance);
        $display("Test %2d: %f + (%f) = %f", test_num, num1_real, num2_real, expected_real);
        $display("  num1     = %s (0x%08h)", binary_string(num_1), num_1);
        $display("  num2     = %s (0x%08h)", binary_string(num_2), num_2);
        $display("  Expected = %s (0x%08h) %s", binary_string(expected_hex), expected_hex, parse_float(expected_hex));
        $display("  Got      = %s (0x%08h) %s", binary_string(sum_float), sum_float, parse_float(sum_float));
        $display("  Result: %s", test_passed ? "PASSED" : "FAILED");
        $display("");
        
        // Тест 4: 100.0 + (-99.9) = 0.1
        test_num = 4;
        num_1 = 32'h42C80000; // 100.0
        num_2 = 32'hC2C7CCCD; // -99.9
        expected_hex = 32'h3DCCCCCD; // 0.1
        #10;
        num1_real = ieee754_to_real(num_1);
        num2_real = ieee754_to_real(num_2);
        expected_real = num1_real + num2_real;
        actual_real = ieee754_to_real(sum_float);
        test_passed = compare_float(expected_real, actual_real, tolerance);
        $display("Test %2d: %f + (%f) = %f", test_num, num1_real, num2_real, expected_real);
        $display("  num1     = %s (0x%08h)", binary_string(num_1), num_1);
        $display("  num2     = %s (0x%08h)", binary_string(num_2), num_2);
        $display("  Expected = %s (0x%08h) %s", binary_string(expected_hex), expected_hex, parse_float(expected_hex));
        $display("  Got      = %s (0x%08h) %s", binary_string(sum_float), sum_float, parse_float(sum_float));
        $display("  Result: %s", test_passed ? "PASSED" : "FAILED");
        $display("");
        
        // Тест 5: 1.0 + (-1.0) = 0.0
        test_num = 5;
        num_1 = 32'h3F800000; // 1.0
        num_2 = 32'hBF800000; // -1.0
        expected_hex = 32'h00000000; // 0.0
        #10;
        num1_real = ieee754_to_real(num_1);
        num2_real = ieee754_to_real(num_2);
        expected_real = num1_real + num2_real;
        actual_real = ieee754_to_real(sum_float);
        test_passed = compare_float(expected_real, actual_real, tolerance);
        $display("Test %2d: %f + (%f) = %f", test_num, num1_real, num2_real, expected_real);
        $display("  num1     = %s (0x%08h)", binary_string(num_1), num_1);
        $display("  num2     = %s (0x%08h)", binary_string(num_2), num_2);
        $display("  Expected = %s (0x%08h) %s", binary_string(expected_hex), expected_hex, parse_float(expected_hex));
        $display("  Got      = %s (0x%08h) %s", binary_string(sum_float), sum_float, parse_float(sum_float));
        $display("  Result: %s", test_passed ? "PASSED" : "FAILED");
        $display("");
        
        // Тест 6: 1234.567 + (-100.123) = 1134.444
        test_num = 6;
        num_1 = 32'h449A5225; // 1234.567
        num_2 = 32'hC2C83D71; // -100.123
        expected_hex = 32'h448DC718; // 1134.444 (приближенно)
        #10;
        num1_real = ieee754_to_real(num_1);
        num2_real = ieee754_to_real(num_2);
        expected_real = num1_real + num2_real;
        actual_real = ieee754_to_real(sum_float);
        test_passed = compare_float(expected_real, actual_real, tolerance);
        $display("Test %2d: %f + (%f) = %f", test_num, num1_real, num2_real, expected_real);
        $display("  num1     = %s (0x%08h)", binary_string(num_1), num_1);
        $display("  num2     = %s (0x%08h)", binary_string(num_2), num_2);
        $display("  Expected = %s (0x%08h) %s", binary_string(expected_hex), expected_hex, parse_float(expected_hex));
        $display("  Got      = %s (0x%08h) %s", binary_string(sum_float), sum_float, parse_float(sum_float));
        $display("  Result: %s", test_passed ? "PASSED" : "FAILED");
        $display("");
        
        // Тест 7: 0.0001 + (-0.00005) = 0.00005
        test_num = 7;
        num_1 = 32'h39D1F717; // 0.0001
        num_2 = 32'hB851EB85; // -0.00005
        expected_hex = 32'h3851EB85; // 0.00005
        #10;
        num1_real = ieee754_to_real(num_1);
        num2_real = ieee754_to_real(num_2);
        expected_real = num1_real + num2_real;
        actual_real = ieee754_to_real(sum_float);
        test_passed = compare_float(expected_real, actual_real, tolerance);
        $display("Test %2d: %f + (%f) = %f", test_num, num1_real, num2_real, expected_real);
        $display("  num1     = %s (0x%08h)", binary_string(num_1), num_1);
        $display("  num2     = %s (0x%08h)", binary_string(num_2), num_2);
        $display("  Expected = %s (0x%08h) %s", binary_string(expected_hex), expected_hex, parse_float(expected_hex));
        $display("  Got      = %s (0x%08h) %s", binary_string(sum_float), sum_float, parse_float(sum_float));
        $display("  Result: %s", test_passed ? "PASSED" : "FAILED");
        $display("");
        
        // Тест 8: 3.14 + (-3.14) = 0.0
        test_num = 8;
        num_1 = 32'h4048F5C3; // 3.14
        num_2 = 32'hC048F5C3; // -3.14
        expected_hex = 32'h00000000; // 0.0
        #10;
        num1_real = ieee754_to_real(num_1);
        num2_real = ieee754_to_real(num_2);
        expected_real = num1_real + num2_real;
        actual_real = ieee754_to_real(sum_float);
        test_passed = compare_float(expected_real, actual_real, tolerance);
        $display("Test %2d: %f + (%f) = %f", test_num, num1_real, num2_real, expected_real);
        $display("  num1     = %s (0x%08h)", binary_string(num_1), num_1);
        $display("  num2     = %s (0x%08h)", binary_string(num_2), num_2);
        $display("  Expected = %s (0x%08h) %s", binary_string(expected_hex), expected_hex, parse_float(expected_hex));
        $display("  Got      = %s (0x%08h) %s", binary_string(sum_float), sum_float, parse_float(sum_float));
        $display("  Result: %s", test_passed ? "PASSED" : "FAILED");
        $display("");
        
        // Тест 9: 1000000.0 + (-999999.0) = 1.0
        test_num = 9;
        num_1 = 32'h49742400; // 1000000.0
        num_2 = 32'hC97423FF; // -999999.0
        expected_hex = 32'h3F800000; // 1.0
        #10;
        num1_real = ieee754_to_real(num_1);
        num2_real = ieee754_to_real(num_2);
        expected_real = num1_real + num2_real;
        actual_real = ieee754_to_real(sum_float);
        test_passed = compare_float(expected_real, actual_real, tolerance);
        $display("Test %2d: %f + (%f) = %f", test_num, num1_real, num2_real, expected_real);
        $display("  num1     = %s (0x%08h)", binary_string(num_1), num_1);
        $display("  num2     = %s (0x%08h)", binary_string(num_2), num_2);
        $display("  Expected = %s (0x%08h) %s", binary_string(expected_hex), expected_hex, parse_float(expected_hex));
        $display("  Got      = %s (0x%08h) %s", binary_string(sum_float), sum_float, parse_float(sum_float));
        $display("  Result: %s", test_passed ? "PASSED" : "FAILED");
        $display("");
        
        // Тест 10: 2.5 + (-7.5) = -5.0
        test_num = 10;
        num_1 = 32'h40200000; // 2.5
        num_2 = 32'hC0F00000; // -7.5
        expected_hex = 32'hC0A00000; // -5.0
        #10;
        num1_real = ieee754_to_real(num_1);
        num2_real = ieee754_to_real(num_2);
        expected_real = num1_real + num2_real;
        actual_real = ieee754_to_real(sum_float);
        test_passed = compare_float(expected_real, actual_real, tolerance);
        $display("Test %2d: %f + (%f) = %f", test_num, num1_real, num2_real, expected_real);
        $display("  num1     = %s (0x%08h)", binary_string(num_1), num_1);
        $display("  num2     = %s (0x%08h)", binary_string(num_2), num_2);
        $display("  Expected = %s (0x%08h) %s", binary_string(expected_hex), expected_hex, parse_float(expected_hex));
        $display("  Got      = %s (0x%08h) %s", binary_string(sum_float), sum_float, parse_float(sum_float));
        $display("  Result: %s", test_passed ? "PASSED" : "FAILED");
        $display("");
        
        $display("==================================================");
        $display("All tests completed!");
        $display("==================================================");
        $finish;
    end
    
    // Функция сравнения с погрешностью
    function bit compare_float(input real expected, input real actual, input real tol);
        real diff;
    begin
        diff = expected - actual;
        if (diff < 0) diff = -diff;
        if (diff <= tol) 
            return 1'b1;
        else
            return 1'b0;
    end
    endfunction

endmodule
