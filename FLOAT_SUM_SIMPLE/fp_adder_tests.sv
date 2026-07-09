`timescale 1ns / 1ps

module fp_adder_tests;

    // Сигналы для подключения к вашему сумматору
    logic [31:0] num_1;
    logic [31:0] num_2;
    wire  [31:0] sum_float;

    // Экземпляр тестируемого сумматора плавающей точки
    floating_point_summator uut (
        .num_1(num_1),
        .num_2(num_2),
        .sum_float(sum_float)
    );

    int passed_tests = 0;
    int failed_tests = 0;

    // Задача для автоматической проверки одного теста
    task check_test(string test_id, string test_name, bit [31:0] n1, bit [31:0] n2);
        shortreal real_n1, real_n2, real_expected, real_got;
        bit [31:0] expected_bits;
        bit is_nan_expected, is_nan_got;
        
        // Переводим входные hex-векторы в shortreal для ПК
        real_n1 = $bitstoshortreal(n1);
        real_n2 = $bitstoshortreal(n2);
        
        // Считаем эталон на процессоре ПК
        real_expected = real_n1 + real_n2;
        expected_bits = $shortrealtobits(real_expected);
        
        // Подаем воздействия на сумматор
        num_1 = n1;
        num_2 = n2;
        #10; // Время на распространение комбинаторного сигнала
        
        real_got = $bitstoshortreal(sum_float);
        
        // Проверка на NaN (так как биты у разных NaN могут отличаться, но математически они равны)
        is_nan_expected = (expected_bits[30:23] == 8'hFF) && (expected_bits[22:0] != 23'd0);
        is_nan_got      = (sum_float[30:23] == 8'hFF) && (sum_float[22:0] != 23'd0);

        $display("Test %s: %s", test_id, test_name);
        $display("  num_1 = %h (%e)", n1, real_n1);
        $display("  num_2 = %h (%e)", n2, real_n2);
        $display("  Expected: %h (%e)", expected_bits, real_expected);
        $display("  Got:      %h (%e)", sum_float, real_got);
        
        if ((is_nan_expected && is_nan_got) || (sum_float == expected_bits)) begin
            $display("  -> PASSED\n");
            passed_tests++;
        end else begin
            $display("  -> FAILED !!!\n");
            failed_tests++;
        end
    endtask

    initial begin
        $display("=========================================================");
        $display(" RUNNING FLOATING POINT ADDER - 100 VERIFICATION TESTS   ");
        $display("=========================================================\n");

        // --- ГРУППА 1: Базовые целые числа и простые дроби (1-15) ---
        check_test("1", "1 + 1", 32'h3f800000, 32'h3f800000);
        check_test("2", "2 + 3", 32'h40000000, 32'h40400000);
        check_test("3", "1.5 + 2.5", 32'h3fc00000, 32'h40200000);
        check_test("4", "10 + (-5)", 32'h41200000, 32'hc0a00000);
        check_test("5", "-3 + 7", 32'hc0400000, 32'h40e00000);
        check_test("6", "-1 + -1", 32'hbf800000, 32'hbf800000);
        check_test("7", "0 + 0", 32'h00000000, 32'h00000000);
        check_test("8", "0 + 1", 32'h00000000, 32'h3f800000);
        check_test("9", "-0 + 0", 32'h80000000, 32'h00000000);
        check_test("10", "0.5 + 0.5", 32'h3f000000, 32'h3f000000);
        check_test("11", "2 + 2", 32'h40000000, 32'h40000000);
        check_test("12", "4 + 4", 32'h40800000, 32'h40800000);
        check_test("13", "8 + 8", 32'h41000000, 32'h41000000);
        check_test("14", "16 + 16", 32'h41800000, 32'h41800000);
        check_test("15", "0.25 + 0.25", 32'h3e800000, 32'h3e800000);

        // --- ГРУППА 2: Степени двойки и вычитания (16-30) ---
        check_test("16", "0.125 + 0.125", 32'h3e000000, 32'h3e000000);
        check_test("17", "1024 + 1024", 32'h44800000, 32'h44800000);
        check_test("18", "1/1024 + 1/1024", 32'h3a800000, 32'h3a800000);
        check_test("19", "2048 + 2048", 32'h45000000, 32'h45000000);
        check_test("20", "5 + (-3)", 32'h40a00000, 32'hc0400000);
        check_test("21", "-5 + 3", 32'hc0a00000, 32'h40400000);
        check_test("22", "100 + (-100)", 32'h42c80000, 32'hc2c80000);
        check_test("23", "-0.5 + 0.5", 32'hbf000000, 32'h3f000000);
        check_test("24", "1/3 + (-1/3)", 32'h3eaaaaab, 32'hbeaaaaab);
        check_test("25", "123.456 + (-123.456)", 32'h42f6e979, 32'hc2f6e979);
        check_test("26", "1e-10 + (-1e-10)", 32'h2df8e000, 32'hadf8e000);
        check_test("27", "1e10 + (-1e10)", 32'h501502f9, 32'hd01502f9);
        check_test("28", "0.1 + (-0.1)", 32'h3dcccccd, 32'hbdcccccd);
        check_test("29", "-123 + 123", 32'hc2f60000, 32'h42f60000);
        check_test("30", "1 + 1e-8 (Потери точности сетки)", 32'h3f800000, 32'h34d1e000);

        // --- ГРУППА 3: Выравнивание мелкой точности порядков (31-45) ---
        check_test("31", "1 + 1e-7", 32'h3f800000, 32'h35d1e000);
        check_test("32", "1 + 1e-6", 32'h3f800000, 32'h36d1e000);
        check_test("33", "1 + 1e-5", 32'h3f800000, 32'h37d1e000);
        check_test("34", "1 + 1e-4", 32'h3f800000, 32'h38d1e000);
        check_test("35", "1.999999 + 0.000001", 32'h3fffffff, 32'h36d1e000);
        check_test("36", "1.000001 + 0.999999", 32'h3f800001, 32'h3f7fffff);
        check_test("37", "1.5 + 0.5", 32'h3fc00000, 32'h3f000000);
        check_test("38", "2.5 + 2.5", 32'h40200000, 32'h40200000);
        check_test("39", "0.3 + 0.3", 32'h3e99999a, 32'h3e99999a);
        check_test("40", "1e20 + 1e20", 32'h5e6e8b40, 32'h5e6e8b40);
        check_test("41", "1e30 + 1e30", 32'h6710e270, 32'h6710e270);
        check_test("42", "1e-20 + 1e-20", 32'h33b2e5f0, 32'h33b2e5f0);
        check_test("43", "1e-30 + 1e-30", 32'h2e3b2e5f, 32'h2e3b2e5f);
        check_test("44", "12345.678 + 87654.322", 32'h4640e6b6, 32'h47ab2652);
        check_test("45", "0.000123 + 0.000877", 32'h380126e9, 32'h39659bfa);

        // --- ГРУППА 4: Границы исчезновения порядков (Underflow) (46-60) ---
        check_test("46", "Маленькое + Большое", 32'h01a00000, 32'h7e200000);
        check_test("47", "Большое + Маленькое", 32'h7e200000, 32'h01a00000);
        check_test("48", "Max Нормальное + Min Нормальное", 32'h7f7fffff, 32'h00800000);
        check_test("49", "Min Нормальное + Min Нормальное", 32'h00800000, 32'h00800000);
        check_test("50", "Min Нормальное + (-Min Нормальное)", 32'h00800000, 32'h80800000);
        check_test("51", "1.0 + Min Нормальное", 32'h3f800000, 32'h00800000);
        check_test("52", "-1.0 + Min Нормальное", 32'hbf800000, 32'h00800000);
        check_test("53", "2.0 + (-2.0)", 32'h40000000, 32'hc0000000);
        check_test("54", "0.75 + 0.25", 32'h3f400000, 32'h3e800000);
        check_test("55", "0.12345 + 0.54321", 32'h3dfcd35a, 32'h3f0b12f7);
        check_test("56", "-0.12345 + (-0.54321)", 32'hbdfcd35a, 32'hbf0b12f7);
        check_test("57", "65536 + 65536", 32'h47800000, 32'h47800000);
        check_test("58", "3.141592 + 2.718281", 32'h40490fdb, 32'h402df854);
        check_test("59", "3.141592 - 2.718281", 32'h40490fdb, 32'hc02df854);
        check_test("60", "1000000 + 1", 32'h49742400, 32'h3f800000);

        // --- ГРУППА 5: Проверка субнормальных (денормализованных) чисел (61-80) ---
        check_test("61", "Min Subnorm + Min Subnorm", 32'h00000001, 32'h00000001); // Тот самый баг с 2^-149
        check_test("62", "Min Subnorm + 2*Min Subnorm", 32'h00000001, 32'h00000002);
        check_test("63", "Max Subnorm + Min Subnorm (Переход в нормальное!)", 32'h007fffff, 32'h00000001);
        check_test("64", "Max Subnorm + Max Subnorm", 32'h007fffff, 32'h007fffff);
        check_test("65", "Min Normal + Min Subnorm", 32'h00800000, 32'h00000001);
        check_test("66", "Min Normal - Min Subnorm", 32'h00800000, 32'h80000001);
        check_test("67", "Субнормальное взаимное уничтожение", 32'h000000aa, 32'h800000aa);
        check_test("68", "Субнормальное уничтожение побольше", 32'h003f0000, 32'h803f0000);
        check_test("69", "Сложение разных субнормальных", 32'h0000f000, 32'h00000f00);
        check_test("70", "Вычитание разных субнормальных", 32'h0000f000, 32'h80000f00);
        check_test("71", "Субнормальные с разным знаком", 32'h80000005, 32'h00000003);
        check_test("72", "Субнормальные с разным знаком 2", 32'h00000005, 32'h80000003);
        check_test("73", "Граница денормализации + 0", 32'h00000001, 32'h00000000);
        check_test("74", "0 + Граница денормализации", 32'h00000000, 32'h00000001);
        check_test("75", "Денормализованный сдвиг с вычитанием", 32'h00700000, 32'h80000001);
        check_test("76", "Денормализованный полный сдвиг в ноль", 32'h00700000, 32'h00000000);
        check_test("77", "Нормальное и субнормальное сложение", 32'h3f800000, 32'h00000001);
        check_test("78", "Нормальное и субнормальное вычитание", 32'h3f800000, 32'h80000001);
        check_test("79", "Нормальное близко к денормализованному", 32'h01000000, 32'h00000001);
        check_test("80", "Нормальное близко к денормализованному 2", 32'h01000000, 32'h80000001);

        // --- ГРУППА 6: Исключения стандарта IEEE-754 (Бесконечности, NaNs, Знаки) (81-100) ---
        check_test("81", "Бесконечность + 1", 32'h7f800000, 32'h3f800000);
        check_test("82", "Минус Бесконечность + 1", 32'hff800000, 32'h3f800000);
        check_test("83", "Inf + Inf", 32'h7f800000, 32'h7f800000);
        check_test("84", "(-Inf) + (-Inf)", 32'hff800000, 32'hff800000);
        check_test("85", "Inf - Inf (Неопределенность -> NaN)", 32'h7f800000, 32'hff800000);
        check_test("86", "(-Inf) + Inf (Неопределенность -> NaN)", 32'hff800000, 32'h7f800000);
        check_test("87", "NaN + 1", 32'h7fc00000, 32'h3f800000);
        check_test("88", "1 + NaN", 32'h3f800000, 32'h7fc00000);
        check_test("89", "NaN + NaN", 32'h7fc00000, 32'h7fc00000);
        check_test("90", "Max Normal + Max Normal (Уход в Бесконечность)", 32'h7f7fffff, 32'h7f7fffff);
        check_test("91", "(-Max Normal) + (-Max Normal) (Уход в -Бесконечность)", 32'hff7fffff, 32'hff7fffff);
        check_test("92", "Переполнение по самой границе", 32'h7f7f0000, 32'h7f7f0000);
        check_test("93", "Переполнение по самой границе 2", 32'h7f7ff000, 32'h7f7ff000);

check_test("94", "Бесконечность + Субнормальное", 32'h7f800000, 32'h00000001);check_test("95", "Минус Бесконечность + Субнормальное", 32'hff800000, 32'h00000001);check_test("96", "NaN + Субнормальное", 32'h7fc00000, 32'h00000001);check_test("97", "Знак нуля: (+0) + (+0)", 32'h00000000, 32'h00000000);check_test("98", "Знак нуля: (-0) + (-0)", 32'h80000000, 32'h80000000);check_test("99", "Знак нуля: (+0) + (-0)", 32'h00000000, 32'h80000000);check_test("100", "Знак нуля: (-0) + (+0)", 32'h80000000, 32'h00000000);$display("=========================================================");$display(" SIMULATION COMPLETE                                     ");$display("   PASSED: %0d / 100", passed_tests);$display("   FAILED: %0d / 100", failed_tests);$display("=========================================================");$stop;
end
endmodule
