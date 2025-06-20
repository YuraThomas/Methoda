# Лекция 1. АЛУ.

**Некое вступление**

В данной небольшой статье мы рассмотри АЛУ и приведем тривиальные примеры (а потом уже читатель сам под нужную ему архитектуру сделает). На самом деле АЛУ и другие компоненты процессора это весьма очевидная штуковина.

**Что такое АЛУ?**

АЛУ – арифметико-логическое устройство, а если чуток более развернуто, то это штуковина, на которую приходит управляющий сигнал и некий входной сигнал, а она по управляющему сигналу (шине) выбирает операцию и исполняет ее над входными данными (еще, правда, есть такие штуковины как флаги, но про них будет в примерах на Verilog).

То есть, по данному описанию вырисовывается примерная схема АЛУ:

<img src="./media/image1.png" style="width:2.04167in;height:1.57219in" />

(Данный АЛУ умеет выполнять 4 функции над N-битным числом (элементами шины) и выдавать 1 из 4 функций по управляющему воздействию)

Как мы видим, это просто мультиплексор с некой комбинационной логикой на входах.

**Небольшой пример.**

<img src="./media/image2.png" style="width:2.16667in;height:1.64759in" />

Найти значение на выходе (в десятичной форме), если upr = 2, а D = 13

Так-как числа A и B это биты числа D в двоичной форме, то переведем D в этот вид (двоичный)

*D* = 13= 1101<sub>2</sub>

Тогда мы находим A и B:

*A* = 01<sub>2</sub> = 1

*B* = 11<sub>2</sub> = 3

*upr* = 2= 10<sub>2</sub>, то у нас над числами A и B будет выполняться умножение

ТЕ, на выходе будет:

*out* = (*A* \* *B*) = 3= 0011<sub>2</sub>

Теперь, познакомившись более-менее с концепцией данного устройства, давайте реализовывать его на Verilog.

**АЛУ номер 1. Переключатор между 4 операциями.**

Данный пример будет вообще в отрыве от различных архитектур и систем, просто сделаем нечто, у которого можно выбрать операцию над входами. Числа пускай будут 32-битными (входы A, B и выход Out_ALU).

**Таблица операций на АЛУ**

<table>
<colgroup>
<col style="width: 49%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr>
<th style="text-align: center;">Upr_ALU</th>
<th style="text-align: center;">Out_ALU</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: center;">0</td>
<td style="text-align: center;">0</td>
</tr>
<tr>
<td style="text-align: center;">1</td>
<td style="text-align: center;">1</td>
</tr>
<tr>
<td style="text-align: center;">2</td>
<td style="text-align: center;">A | B</td>
</tr>
<tr>
<td style="text-align: center;">3</td>
<td style="text-align: center;">A &amp; B</td>
</tr>
</tbody>
</table>

**Описание на Verilog (но RTL схема выходит некрасивая).**

<img src="./media/image3.png" style="width:3.31944in;height:1.17341in" />

**Описание на Verilog с красивой RTL схемой (загнал операции ИЛИ, И в модули).**

``` Verilog
module ALU_1 (
	input [1:0] Upr_ALU,
	input [31:0] A,
	input [31:0] B,
	output [31:0] Out_ALU
);

wire [31:0] or_mux;
wire [31:0] and_mux;

assign Out_ALU = (Upr_ALU == 2'd0) ? 32'b0:
					  (Upr_ALU == 2'd1) ? 32'b1:
					  (Upr_ALU == 2'd2) ? or_mux: and_mux;
					  
or_32_b or_ALU (
	.A(A),
	.B(B),
	.out_or(or_mux)

);

and_32_b and_ALU (
	.A(A),
	.B(B),
	.out_and(and_mux)
);
						
endmodule
```

``` Verilog
module and_32_b (
	input [31:0] A,
	input [31:0] B,
	output [31:0] out_and
);
assign out_and = A & B;

endmodule
```

``` Verilog
module or_32_b (
	input [31:0] A,
	input [31:0] B,
	output [31:0] out_or

);

assign out_or = A | B;
endmodule
```

**Тестирование первого АЛУ**

Тесты ниже не доказывают абсолютную работоспособность схемы, они лишь могут показать некие очевидные ошибки, если они есть, а для полной проверки схемы надо писать полный тестбенч (а тема данной статьи все-таки не совсем про Verilog и реализацию в нем тестбенчей). Ниже я привел быстрый тест схемы “ на глазок”.

**Тест операции 0**

<img src="./media/image7.png" style="width:6.48819in;height:0.53542in" />

Операция работает (выводит всегда 0).

**Тест операции 1**

<img src="./media/image8.png" style="width:6.48819in;height:0.55347in" />

Операция работает (выводит всегда 1).

**Тест операции 2**

<img src="./media/image9.png" style="width:6.49375in;height:0.59514in" />

Операция работает (делает A ИЛИ B)

**Тест операции 3**

<img src="./media/image10.png" style="width:6.48194in;height:0.38681in" />

Операция работает (делает A И B)

Да, в тесте 2 последних операций есть числа раскрытые не полностью (места не хватило), но автор их проверил, и на них АЛУ тоже работает верно

**Тест всех операций разом**

<img src="./media/image11.png" style="width:6.48194in;height:0.42847in" />

Как читатель может видеть, вроде бы все работает верно.

**RTL схема**

<img src="./media/image12.png" style="width:5.30303in;height:1.69765in" />

**АЛУ номер 2. Переключатор между 8 операциями + бит сравнения C.**

Если рассматривать АЛУ в отрыве от какой-либо (даже самой простой) архитектуры, то может быть непонятен смысл бита сравнения. Однако, если читатель поверит мне на слово, то концептуально простейший процессор/программируемое устройство должно уметь аппаратно реализовывать циклы и условные конструкции, бит C отвечает за верность выполнения условия (если C = 1 и должна выполняться проверка некоего условия (это зашито в командах, которыми мы прошиваем устройство), то выполняется нетрадиционный переход с одной строки памяти команд на другую (то есть, в обычном режиме у нас идет чтение 1 строчки кода, затем 2 строчки кода, затем 3 строчки кода и тд, но при выполнении неких условий (условная команда и C = 1) считыватель с памяти команд может перепрыгнуть на 7 строчек наверх по программе, или на 12 строчек вниз, что по сути своей и есть аппаратно реализованные условные конструкции и циклы).

Отходя от большого и красивого обоснования наличия данного бита (ограничимся пока что им) накидаем относительно разумный список команд:

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr>
<th style="text-align: center;">Upr_ALU</th>
<th style="text-align: center;">C</th>
<th style="text-align: center;">Операции на АЛУ</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: center;">0</td>
<td style="text-align: center;">Все равно, но пускай 0</td>
<td style="text-align: center;">0</td>
</tr>
<tr>
<td style="text-align: center;">1</td>
<td style="text-align: center;">Все равно, но пускай 0</td>
<td style="text-align: center;">A+B</td>
</tr>
<tr>
<td style="text-align: center;">2</td>
<td style="text-align: center;">Все равно, но пускай 0</td>
<td style="text-align: center;">A-B</td>
</tr>
<tr>
<td style="text-align: center;">3</td>
<td style="text-align: center;">Все равно, но пускай 0</td>
<td style="text-align: center;">A &amp; B</td>
</tr>
<tr>
<td style="text-align: center;">4</td>
<td style="text-align: center;">Все равно, но пускай 0</td>
<td style="text-align: center;">A | B</td>
</tr>
<tr>
<td style="text-align: center;">5</td>
<td style="text-align: center;">1, если верно, иначе 0</td>
<td style="text-align: center;">A &gt; B</td>
</tr>
<tr>
<td style="text-align: center;">6</td>
<td style="text-align: center;">1, если верно, иначе 0</td>
<td style="text-align: center;">A == B</td>
</tr>
<tr>
<td style="text-align: center;">7</td>
<td style="text-align: center;">Все равно, но пускай 0</td>
<td style="text-align: center;">A &lt;&lt; 1 – сдвиг A на 1 налево</td>
</tr>
</tbody>
</table>

В арифметических операциях нам все равно на C, в условных операциях нам все равно на Out_ALU (а если нам на что-то все равно, то значение на выходе будет 0).

**Описание на Verilog.**

``` Verilog
module ALU_2 (
	input [2:0] Upr_ALU,
	input [31:0] A,
	input [31:0] B,
	output C,
	output [31:0] Out_ALU
);

wire [31:0] or_mux;
wire [31:0] and_mux;
wire [31:0] A_shift_1;
wire A_eq_B;
wire A_more_B;
assign A_shift_1 = {A[30:0], 1'b0};

assign Out_ALU = (Upr_ALU == 3'd0) ? 32'b0:
					  (Upr_ALU == 3'd1) ? A+B:
					  (Upr_ALU == 3'd2) ? A-B:
					  (Upr_ALU == 3'd3) ? and_mux:
					  (Upr_ALU == 3'd4) ? or_mux:
					  (Upr_ALU == 3'd5) ? 32'b0:
					  (Upr_ALU == 3'd6) ? 32'b0: A_shift_1;

assign A_more_B = (A > B) ? 1'b1 : 1'b0;
assign A_eq_B = (A == B) ? 1'b1 : 1'b0;
assign C = (Upr_ALU == 3'd5) ? A_more_B:
			  (Upr_ALU == 3'd6) ? A_eq_B: 1'b0;
									  
or_32_b or_ALU (
	.A(A),
	.B(B),
	.out_or(or_mux)

);

and_32_b and_ALU (
	.A(A),
	.B(B),
	.out_and(and_mux)
);					
endmodule
```

**RTL схема АЛУ.**

<img src="./media/image14.png" style="width:6.87996in;height:1.56818in" />

Как читатель видит, устройство весьма нехило в размере выросло.

**Тестирование второго АЛУ**

Ну что-ж, давайте начнем сие увлекательное действие, состоящее из тестов выхода АЛУ и C для каждой операции. Также, так-как возможно переполнение, но данный флаг (бит переполнения при операции) нами при данном АЛУ не предусмотрен, то будем давать тесты, при которых переполнения не будет.

**Тест операции 0 (выдает 0)**

<img src="./media/image15.png" style="width:6.49444in;height:0.67778in" />

**Тест операции 1 (выдает A + B)**

<img src="./media/image16.png" style="width:6.48889in;height:0.68889in" />

**Тест операции 2 (выдает A – B)**

<img src="./media/image17.png" style="width:6.48889in;height:0.72778in" />

**Тест операции 3 (Логическое И)**

<img src="./media/image18.png" style="width:6.48889in;height:0.48333in" />

**Тест операции 4 (логическое ИЛИ)**

<img src="./media/image19.png" style="width:6.48889in;height:0.47778in" />

**Тест операции 5 ( A \> B, работает только для беззнаковых десятичных, желательно свой компаратор писать)**

<img src="./media/image20.png" style="width:6.48333in;height:0.47222in" />

**Тест операции 6 (A = B)**

<img src="./media/image21.png" style="width:6.48333in;height:0.66111in" />

**Тест операции 7 (сдвиг на 1 разряд числа A налево (для положительных чисел это примерно умножение на 2)**

<img src="./media/image22.png" style="width:6.49444in;height:0.67222in" />

Как читатель видит, АЛУ реализовано примерно так, как нам надо (только компаратор можно свой поставить, чтобы он знаковые числа обрабатывал (или встроенный модифицировать))

**АЛУ номер 3. Весьма близко к реальному RISC-V.**

<img src="./media/image23.png" style="width:3.54968in;height:0.84896in" />

Для выхода АЛУ (у нас вместо result_0 выход Out_ALU

<img src="./media/image24.png" style="width:4.80553in;height:2.125in" />

Для некоего характерного бита (флага), у нас, как и в прошлом АЛУ это будет бит C (результат логической операции)

<img src="./media/image25.png" style="width:3.79687in;height:1.40165in" />

В общем-то, 2 примера АЛУ выше должны были подвести нас к данной штуковине и, в общем-то, показать ее очевидность. Как и в прошлом АЛУ, ставим 0 на выходы, которые мы не используем.

Из новых моментов по сравнению с предыдущим АЛУ скорее большее внимание биту C и оформление кода (теперь, например, вместо кода операции сложения 5’d0 будем использовать ADD с помощью конструкции parameter, которая будет сама вместо ADD подставлять 5’d0). Автор не будет управляющий вход АЛУ разделять на 3 части, просто сделав его 5-битным.

**RTL схема АЛУ.**

<img src="./media/image26.png" style="width:6.36979in;height:1.51636in" />

**Описание АЛУ на Verilog (главный модуль).**

``` Verilog
module ALU_3 (
	input [4:0] Upr_ALU,
	input [31:0] A,
	input [31:0] B,
	output C,
	output [31:0] Out_ALU
);
parameter ADD = 5'b00000;
parameter SUB = 5'b01000;
parameter SLL = 5'b00001;
parameter SLTS = 5'b00010;
parameter SLTU = 5'b00011;
parameter XOR = 5'b00100;
parameter SRL = 5'b00101;
parameter SRA = 5'b01101;
parameter OR = 5'b00110;
parameter AND = 5'b00111;
parameter EQ = 5'b11000;
parameter NE = 5'b11001;
parameter LTS = 5'b11100;
parameter GES = 5'b11101;
parameter LTU = 5'b11110;
parameter GEU = 5'b11111;

wire [31:0] out_or;
wire [31:0] out_and;
wire [31:0] out_add;
wire [31:0] out_sub;
wire [31:0] out_xor;
wire [31:0] out_sll;
wire [31:0] out_slts;
wire [31:0] out_sltu;
wire [31:0] out_srl;
wire [31:0] out_sra;
wire out_A_menshe_B_zn;
wire out_A_ne_menshe_B_zn;
wire out_A_menshe_B;
wire out_A_ne_menshe_B;
wire out_equal;
wire out_notequal;

assign out_A_ne_menshe_B_zn = ~out_A_menshe_B_zn;
assign out_A_ne_menshe_B = ~out_A_menshe_B;
assign out_equal = (A==B) ? 1'b1 : 1'b0;
assign out_A_menshe_B = (A<B) ? 1'b1 : 1'b0;
assign out_notequal = ~out_equal;

assign out_add = A+B;
assign out_sub = A-B;
assign out_sll = A << B;
assign out_slts = {{31{1'b0}},out_A_menshe_B_zn};
assign out_sltu = {{31{1'b0}},out_A_menshe_B};
assign out_srl = A >> B;
assign out_sra = A >>>B;


assign Out_ALU = (Upr_ALU == ADD) ? out_add:
					  (Upr_ALU == SUB) ? out_sub:
					  (Upr_ALU == SLL) ? out_sll:
					  (Upr_ALU == SLTS) ? out_slts:
					  (Upr_ALU == SLTU) ? out_sltu:
					  (Upr_ALU == XOR) ? out_xor:
					  (Upr_ALU == SRL) ? out_srl: 
					  (Upr_ALU == SRA) ? out_sra:
					  (Upr_ALU == OR) ? out_or:
					  (Upr_ALU == AND) ? out_and:32'b0;

assign C = (Upr_ALU == EQ) ? out_equal:
			  (Upr_ALU == NE) ? out_notequal:
			  (Upr_ALU == LTS) ? out_A_menshe_B_zn:
			  (Upr_ALU == GES) ? out_A_ne_menshe_B_zn:
			  (Upr_ALU == LTU) ? out_A_menshe_B:
			  (Upr_ALU == GEU) ? out_A_ne_menshe_B:1'b0;
					  
									  
or_32_b or_ALU (
	.A(A),
	.B(B),
	.out_or(out_or)

);

and_32_b and_ALU (
	.A(A),
	.B(B),
	.out_and(out_and)
);

sl_mod2 mod2_ALU (
	.A(A),
	.B(B),
	.out(out_xor)
);

comp_menshe zn_comp (
	.A(A),
	.B(B),
	.out(out_A_menshe_B_zn)
);			
endmodule
```

**Описание АЛУ на Verilog (модули).**

``` Verilog
module and_32_b (
	input [31:0] A,
	input [31:0] B,
	output [31:0] out_and
);
assign out_and = A & B;

endmodule
```

``` Verilog
module or_32_b (
	input [31:0] A,
	input [31:0] B,
	output [31:0] out_or

);

assign out_or = A | B;
endmodule
```

``` Verilog
module sl_mod2 (
	input [31:0] A,
	input [31:0] B,
	output [31:0] out
);

assign out = A ^ B;

endmodule
```

**Тест АЛУ.**

В силу того, что операций весьма много, будем тестировать сразу несколько штук за тест (такой метод позволит найти, увы, только очевиднейшие ошибки).

**Операции ADD, SUB, SLTS (сложение, вычитание, знаковое сравнивание (выход на АЛУ)).**

<img src="./media/image31.png" style="width:6.95759in;height:0.80357in" />

**Операции XOR, OR, AND (сложение по модулю 2 , ИЛИ, И (везде побитовое, выход на АЛУ)).**

<img src="./media/image32.png" style="width:6.8842in;height:0.50595in" />

**Операции SLL, SRL, SRA (сдвиг налево, сдвиг направо, арифметический сдвиг направо на B позиций).**

<img src="./media/image33.png" style="width:6.9003in;height:0.5in" />

**Операция SLTS (беззнаковое сравнение A \< B).**

<img src="./media/image34.png" style="width:6.94048in;height:0.80827in" />

Беззнаковое оно, так-как не работает на отрицательных числах (ниже будет пример).

<img src="./media/image35.png" style="width:6.95818in;height:0.79167in" />

**Тест флага C для АЛУ.**

**Операции EQ, NE (A == B, A!= B, в, если выражение верно, то выводить 1)**

<img src="./media/image36.png" style="width:6.86823in;height:0.81667in" />

**Операции LTS, GES (знаковое сравнение “меньше”, “больше или равно”).**

<img src="./media/image37.png" style="width:6.86107in;height:0.72778in" />

**Операции LTU, GEU.**

<img src="./media/image38.png" style="width:6.83431in;height:0.61458in" />

**Про реализацию знакового компаратора (необязательное дополнение).**

Пускай у нас есть сравниватель (операция “меньше”) для беззнаковых десятичных чисел, необходимо реализовать данную операцию для знаковых десятичных чисел (потому как встроенная операция для беззнаковых).

Реализуем данную операцию путем вычитания из A числа B, результат записав в S (S = A-B). Рассмотрим теперь ситуации, когда S \< 0 (то есть, A \< B).

**Когда A < 0 (знаковый бит = 1), B > 0 (знаковый бит = 0).**

Учтем данное условие выражением A[31] & ~B[31]

**Когда A > 0 (знаковый бит = 0), B > 0 (знаковый бит = 0), S < 0 (знаковый бит = 1)**

Учтем данное условие выражением ~A[31] & ~B[31] & S[31]

**Когда A < 0 (знаковый бит = 1), B < 0 (знаковый бит = 1), S > 0 (знаковый бит = 0)**

Учтем данное условие выражением A[31] & B[31] & ~S[31]

**В итоге, получим выражение для знакового сравнения:**

comp_zn =  A[31] & ~B[31] | ~A[31] & ~B[31] & S[31] | A[31] & B[31] & ~S[31]

**Код на Verilog, описывающий компаратор знакового сравнения “меньше”.**
``` Verilog

module comp_menshe (
	input [31:0] A,
	input [31:0] B,
	output out
);

wire [31:0] S;
assign S = A-B;
assign out = (A[31] & ~B[31]) | (~A[31] & ~B[31] & S[31]) | (A[31] & B[31] & S[31]);

endmodule

```

**RTL схема знакового компаратора “A меньше B”**

<img src="./media/image40.png" style="width:6.35651in;height:1.75758in" />

**Тест знакового компаратора.**

<img src="./media/image41.png" style="width:6.42424in;height:0.66723in" />

Таким образом, у нас есть встроенный компаратор в Verilog, который реализует беззнаковое “меньше” и сейчас мы описали компаратор на Verilog, который выполняет такую же операцию “меньше”, но уже с знаковыми числами. Операцию “равно” будем использовать встроенную в Verilog, а операцию “больше” реализуем как “меньше”, но с другими входными данными (A \> B это же B \< A).

