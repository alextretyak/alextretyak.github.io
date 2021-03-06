Н‘‘Признаки устаревшего языка (ссылка на статью)’[http://compiler.su/priznaki-ustarevshego-yazyka.php]’

Комментарии:
---
*‘2021-01-16’ ~‘alextretyak’

На первый взгляд эта тема действительно очень актуальна и пример с устаревшим самолётом звучит крайне убедительно (можно ещё добавить к ‘последние достижения науки и техники’ в скобочках: интернет на борту и большой LCD тач экран на спинке каждого кресла самолёта).

Но.
Если погрузиться в детали, то не всё так однозначно/просто.

Разберу конкретные признаки, приведённые в статье:
> оператор «goto»;
В целом согласен, т.к. достаточно break/continue с меткой, а также конструкции defer (как в Go и Swift). Все остальные варианты использования goto [[[[создают/]]]]порождают спагетти-код.

> такая обработка исключений, которая ещё хуже «goto», когда исключение неизвестно где возникает и неизвестно куда передаёт управление;
Очень больная/большая тема.
По вопросу исключений я и сам менял свою позицию, но решить этот вопрос одними рассуждениями — невозможно. Требуется проанализировать много-много реальных примеров, практического кода, самого разного, на разных языках программирования, с разными способами обработки ошибок, чтобы хоть как-то приблизиться к окончательному решению по данному вопросу. Лично я пока остановился на «устаревшей» модели, принятой в Python и C++, так как ничего реально лучшего (не ‘на словах’/‘в теории’ (см. моё предложение[http://web.archive.org/web/20191218102909/https://bitbucket.org/pqmarkup/pqmarkup/commits/0b7f9590718e928063a5b0d07ff35195c387ecb3]), а на практике) я [[[[предложить/]]]]посоветовать не могу.

> постфиксные операции «++» и «--», которые для большинства — загадочны;
Ещё один спорный момент. [В Swift 3 вообще убрали «++» и «--».]
Но если я правильно понимаю автора, то против префиксных «++» и «--» он ничего не имеет? Тогда готов согласиться, хотя и считаю запись `i++` красивее `++i`.[[[[Как вариант, можно разрешить `i++`, но запретить `arr[i++]`.]]]]

> приведения типов, влекущие «тайное» изменения значения;
Не совсем понятно, о каком приведении типов идёт речь. Лично я считаю разумным отказ от неявного приведения типов в большинстве случаев, но оставить возможность явного приведения типов (например, строку в число и наоборот).

> нулевой указатель
Также непонятно, о чём речь. Автор против nullable-типов? Или имеется в виду решение этой проблемы в стиле Kotlin ([https://kotlinlang.ru/docs/reference/null-safety.html]), с обязательной проверкой на null?

> возможность присвоить неинициализированное значение
А что плохого, если язык поддерживает явное указание создания неинициализированной переменной, как например D:
>[https://dlang.org/spec/declaration.html#void_init]:‘#(D)‘
int x = void;
’’
Это может быть полезно для создания очень больших массивов, в которых реально использоваться будет лишь небольшая часть элементов.

> визуальный мусор типа «begin» и «end», особенно ЗАГЛАВНЫМИ буквами;
Согласен.
[Сюда же [в визуальный мусор] [[[[Ещё ]]]]можно добавить обязательные точки с запятой в конце строк[[[[, на тему которых я также планирую сделать доклад]]]].]

> контроля возможного переполнения при арифметических операциях;
Уже обсуждалось здесь[http://compiler.su/filosofiya-yazyka.php#46].
Как итог: пока процессоры не будут поддерживать генерацию исключения при переполнении аппаратно и без оверхеда, не стоит ожидать такого контроля {включенного по-умолчанию, а не опционального} в языках программирования, ориентированных на высокую производительность.

>‘приоритетов операций а-ля Lisp или Forth;
контроля границ массивов а-ля Си;
возможности вернуть из функций объекты как скалярные, так и не скалярные, как фиксированного, так и переменного размера;
функций — объектов первого класса;
оператора «for each»;
вывода типов;’
Согласен.

>‘обращения по абсолютным адресам
синтаксис, прогибающий под себя программистов, а-ля Forth;
программирования в стиле доказательств;
зрительных ориентиров в тексте, позволяющих отличить операции от операндов;’
Не [совсем] понял, о чём это.
---
*‘2021-01-16’ ~‘Автор сайта’

> то против префиксных «++» и «--» он ничего не имеет?
Я протестую не против синтаксиса — префиксного или постфиксного, а ‘против семантики постфиксных «++» и «--»’[http://compiler.su/postfiksnye-inkrement-i-dekrement.php].

> о каком приведении типов идёт речь
Например, присвоение переменной типа int значения типа long, float или double часто делается с искажением значения. В таких случаях надо или явно «убивать» лишние биты значения, либо должно быть реагирование на ошибку, если что-то теряем в лишних битах:
#(C)‘
char a = выбрать 8 младших битов (9876543210);  // явное обрезание лишних битов
char b =  9876543210;                           // неявная потеря битов. Если потеря и вправду
                                                // случается, возбуждаем исключение
’

> Автор против nullable-типов?
Да. Адрес, указывающий на незаконный участок памяти, сам незаконен. Но если обнаружилась такая незаконная ситуация, то должна быть немедленная реакция на ошибку, это описано в статье «‘Обработка ошибок’[http://compiler.su/obrabotka-oshibok.php]».[[[

> А что плохого, если язык поддерживает явное указание создания неинициализированной переменной… Это может быть полезно для создания очень больших массивов, в которых реально использоваться будет лишь небольшая часть элементов.
Скалярные объекты однозначно должны создаваться инициализацией. С контейнерами сложнее и пока однозначного решения не надумано.
]]несколько спорное утверждение {а что если скалярный объект определяется внутри типа, который затем помещается в контейнер/массив}, но дискутировать на эту тему не хочется]

> пока процессоры не будут поддерживать генерацию исключения при переполнении аппаратно и без оверхеда, не стоит ожидать такого контроля в языках программирования, ориентированных на высокую производительность.
Биты переполнения и так устанавливаются, хотим мы этого или нет. А вот условный переход по условию «переполнение» замедляет код не в разы, а лишь на проценты — даже не на десятки процентов. Дмитрий Караваев на этом сайте ‘озвучивал цифры’[http://compiler.su/ob-isklyuchyonnyh-komandah-ili-za-chto-spisali-instruktsiyu-into.php#_6] на сей счёт.

>‘Не [совсем] понял, о чём это
> обращения по абсолютным адресам
’
#(C)‘
int* ptr = (int*) 1234; // запросто получаем абсолютный адрес
*ptr = anything;        // и пишем по нему
’
Неужели это нормально?

> синтаксис, прогибающий под себя программистов, а-ля Forth
В Форте все слова должны быть разделены пробелами, нельзя написать, например
#‘
A+B-C
’
Обязательно
#‘
A + B — C
’
А постфиксная запись? На неё мозги надо особо настраивать.

> зрительных ориентиров в тексте, позволяющих отличить операции от операндов
Форт вполне допускает такую запись:
#‘
  blabla_1 blabla_2 blabla_3 
’
Но что тут функция, а что операнд? Сколько было операндов в стеке до слова «blabla_2» и сколько после? Вы этого не узнаете, пока не загляните в описание каждого слова.
---
*‘2021-01-19’ ~‘alextretyak’

> Я протестую не против синтаксиса — префиксного или постфиксного, а против семантики постфиксных «++» и «--».
Здорово, что протестуете :)(:, но что конкретно вы предлагаете?
1. чтобы `i++` работало точно также как и `++i`;
2. запретить `i++`, оставив только `++i`;
3. [или что мне больше всего нравится:] разрешить `++i`, `i++` и `arr[++i]`, но запретить `arr[i++]`.

> Например, присвоение переменной типа int значения типа long, float или double часто делается с искажением значения. В таких случаях надо или явно «убивать» лишние биты значения, либо должно быть реагирование на ошибку
С этим согласен.

>‘> Автор против nullable-типов?
Да. Адрес, указывающий на незаконный участок памяти, сам незаконен.’
И какие альтернативы?
Давайте разбирать конкретные примеры.
Вот в 11l есть тип `Словарь`\`Dict` (в C++ это `std::map`). У этого типа есть метод `find()`, который по заданному ключу возвращает либо N/null\Н/нуль (если такого ключа в словаре нет), либо соответствующее значение. (Т.е. метод `find()` возвращает nullable-тип `ValueType?`.) Но чтобы использовать значение, которое вернул `find()`, необходимо либо явно проверить его на N/null\Н/нуль, либо использовать оператор `?` (например так: `dict.find(key) ? default_value`). Как вы предлагаете изменить это? Какая сигнатура и тип возвращаемого значения должны быть у метода `find()`?

Вот примеры кода на 11l, где используется метод `find()`:
1. 111771+.11l[https://www.dropbox.com/sh/2i0t6hg33z14qt0/AAAvVZ6AyI9ahLju-A-i63Sva/3/3%D0%90?dl=0&preview=111771%2B.11l&subfolder_nav_tracking=1] (это решение ‘задачи «Множества»’[https://informatics.msk.ru/mod/statements/view.php?chapterid=111771])
2. [[[https://github.com/11l-lang/_11l_to_cpp/blob/master/tests/parser/Rosetta%20Code.txt#L1851]]][https://rosettacode.org/wiki/Knapsack_problem/Bounded#11l][[[Не зря я столько времени потратил на Rosetta Code! :)(:]]]
3. [[[https://github.com/11l-lang/_11l_to_cpp/blob/master/tests/parser/Rosetta%20Code.txt#L2015]]][https://rosettacode.org/wiki/Longest_common_substring#11l]
4. `V dot_pos = token.value(source). {.find(‘.’) ? .len}` (данная строка соответствует 3-м строкам Python-кода отсюда[https://github.com/11l-lang/_11l_to_cpp/blob/8734a745d6086c55269576674fb248c74d727222/keyletters_to_keywords.py#L22-L24][[[ссылка получена через ‘...’ -> ‘Copy permalink’]]])

> Но если обнаружилась такая незаконная ситуация, то должна быть немедленная реакция на ошибку, это описано в статье «‘Обработка ошибок’[http://compiler.su/obrabotka-oshibok.php]».
Не могли бы вы указать, где именно это описано в статье «Обработка ошибок».

> Биты переполнения и так устанавливаются, хотим мы этого или нет.
Да, но проверка этих битов далеко не бесплатна. На современных суперскалярных процессорах [[[бранчи/]]]условные переходы стоят дорого и, вероятно, со временем будут становиться ещё дороже.

Здесь[http://compiler.su/filosofiya-yazyka.php#46] есть ссылка на обсуждение[https://news.ycombinator.com/item?id=11595398], в котором говорится о [[[двукратной просадке]]]двукратном падении производительности:
~‘... a 2x slowdown, which isn't acceptable if Rust wants to compete with C++.’

> А вот условный переход по условию «переполнение» замедляет код не в разы, а лишь на проценты — даже не на десятки процентов. Дмитрий Караваев на этом сайте ‘озвучивал цифры’[http://compiler.su/ob-isklyuchyonnyh-komandah-ili-za-chto-spisali-instruktsiyu-into.php#_6] на сей счёт.
Откуда эти результаты? Можно исходный код тестирующей программы, с помощью которой получены эти данные? [Хотя, и самих конкретных данных в цифрах я не вижу в самой статье (хотя они есть в комментариях и противоречат высказыванию «замедляет код лишь на проценты»).][[[
К тому же, инструкции для контроля границ и проверки переполнения (BOUND и INTO), о которых говорит Дмитрий, исключены[https://en.wikipedia.org/wiki/X86-64#Architectural_features] из системы команд x86-64.]]]

В случае озвученного мной выше замедления в 2 раза, источник[http://web.archive.org/web/20141224183129/http://danluu.com/integer-overflow/ <- http://danluu.com/integer-overflow/] приводит такой код:
#‘
Без проверки на переполнение:
...
add     %esi, %edi
...
С проверкой на переполнение:
...
add     %esi, %edi
jo      <handle_overflow>
...
’

Из того же источника:
Для компрессии bzip2 [[[просадка в]]]падение производительности [при включении контроля целочисленного переполнения] составляет 28%.
А код[[[ вида]]]:
#(C)‘
for (int i = 0; i < n; ++i) {
  sum += a[i];
}
’
выполняется в 6 раз медленнее при включении [[[signed-integer-overflow]]]контроля переполнения!
