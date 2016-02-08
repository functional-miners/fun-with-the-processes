# Notatki

1. Prezentacja dwóch narzędzi.
  - `:observer` - Wizualizacja (!) "prawie" wszystkiego co się dzieje na maszynie wirtualnej.
    - Warto zaznaczyć, że to dobre narzędzie na początek, ale nie zawsze będzie
      pod ręką (wymaga wxWidgets, rzadko dostępne na serwerze).
    - Nie pokazuje też wszystkiego, ale do tego wrócimy za chwilę.
    - Pokaż ile procesów jest po starcie maszyny wirtualnej.
  - `erlubi` - Wizualizacja wszystkich procesów na maszynie wirtualnej.
    - Trójwymiarowa wizualizacja drzewa procesów, tym razem pokazująca wszystkie procesy.
    - Zwrócić ponownie uwagę na to ile tych procesów jest po starcie.
      - Ich lekkość to zaleta Erlanga, ale to nie jest najważniejsza cecha - tą
        najważniejszą jest izolacja i możliwość obserwacji co się z nimi dzieje
        na każdym etapie ich życia.
      - Wróć do poprzedniego narzędzia i pokaż przykładowy proces, jego stan,
        aktualnie przetwarzane informacje, pokaż kolejkę wiadomości.

2. Pierwszy proces (SPAWNING, PID, THEORY, MAILBOX - SENDING, RECEIVING).
  - Jak stworzyć proces? Jeśli ktoś miał do czynienia wcześniej z C, kojarzy
    wywołanie systemowe `fork`. W *Erlangu* jest podobnie - korzystamy z dwóch
    BIFów (wbudowanych w bibliotekę, mocno zoptymalizowanych funkcji):
    - `spawn`
    - `spawn_link`
  - Podczas prezentacji `:observer` widzieliśmy, że każdy proces posiada coś na
    kształt adresu, który nazywa się `PID`.
    - Ten identyfikator składa się z trzech części <A.B.C>:
      - A, numer węzła (0 - lokalny, w reszcie przypadków to arbitralnie
        przyjęta wartość numeryczna)
      - B, pierwsze 15 bitów z numeru procesu (indeks w tablicy procesów)
      - C, bity od 16 do 18 z numeru procesu (ten sam numer co w sekcji B)
    - PID możemy stworzyć za pomocą wywołania `pid(0, 60, 0)`.
  - Jak stworzyć proces?
    - `spawn(fn -> IO.puts("Hello World!") end)`
      - Takie wywołanie zwraca identyfikator procesu.
      - To ważne, aby go zapamiętać lub wiedzieć jak odtworzyć.
    - `Process.alive?(pid(X, Y, Z))` - false, dlaczego?
      - Procesy wykonują operacje sekwencyjnie a następnie, jeśli nie mają
        żadnych operacji do wykonania, kończą swoje działanie w normalny sposób.
      - Oznacza to, że procesy działają względem siebie równolegle, natomiast w
        ramach procesu mamy dobrze znany sekwencyjny model wykonania.
    - Jak więc doprowadzić do tego aby proces pracował w nieskończoność?
      - Rekurencją. ;)
      - ```
        defmodule Test do
          def loop(n) when is_number(n) do
            result = rem(n, 1_000_000)
            if result === 0 do
              IO.puts("I'm still working!")
            end
            loop(result + 1)
          end

          def start() do
            pid = spawn(fn -> loop(1) end)
            IO.puts("Process started with PID: #{inspect pid}")
          end
        end
        ```
      - Zwróćcie uwagę, że w normalnym sekwencyjnym wykonaniu wywołanie metody
        `loop/1` spowodowałoby, że program utknie w pętli nieskończonej.
      - Jak ubić taki proces?
        - `Process.exit(pid(X, Y, Z), :kill)`
    - Taki proces który sam sobie coś robi i liczy jest mało użyteczny, bo nie
      możemy do niego nic dostarczyć, ani nic wyciągnąć (poza parsowaniem
      wiadomości z STDOUT).
      - Możemy jednak wysyłać wiadomości pomiędzy procesami.
      - ```
        defmodule Test do
          def loop() do
            receive do
              # For now empty!
            end
          end

          def start() do
            pid = spawn(fn -> loop() end)
            IO.puts("Process started with PID: #{inspect pid}")
            pid
          end

          def send_number(pid, n) do
            send(pid, {:number, n})
          end
        end
        ```
      - Po wykorzystaniu BIFa `send/2` w kolejce wiadomości procesu pojawi się
        wysłany *payload*.
        - `Process.info(pid(X, Y, Z), :messages)`
        - Mimo tego, że wiadomość została wysłana a nasz proces posiada klauzulę
          `receive`, nie została ona odebrana. Dzieje się tak dlatego, że
          klauzula oczekuje konkretnego formatu wiadomości (w tym przypadku nie
          oczekuje na żaden), ale dalej proces jest żywy - nie umarł?
          - Dzieje się tak dlatego, że klauzula `receive` blokuje wykonanie
            sekwencyjnego kodu do momentu dostarczenia pasującej wiadomości.
      - Jak odebrać pasującą wiadomość?
      - ```
        defmodule Test do
          def loop() do
            receive do
              {:number, number} -> IO.puts("I've received a number: #{number}")
            end
            loop()
          end

          def start() do
            pid = spawn(fn -> loop() end)
            IO.puts("Process started with PID: #{inspect pid}")
            pid
          end

          def send_number(pid, n) do
            send(pid, {:number, n})
          end
        end
        ```
      - Na tą chwilę to jedyny sposób na wymianę danych i stanu pomiędzy
        procesami nam znany. I nie będzie ich dużo więcej. Immutability FTW! To
        esencja *actor model* - aktorem nazywamy niezależną jednostkę,
        wymieniającą wiadomości z innymi, nie współdzielące miedzy sobą żadnego
        stanu. Tzw. obiekt reprezentujący obliczenia, niezależny byt w systemie.
      - Pozostają dwa pytania:
        - Jak zidentyfikować nadawcę wiadomości? Najlepiej za pomocą PID, który
          można pobrać za pomocą BIFa `self/0`.
        - Jak zidentyfikować konkretną wiadomość? Najlepiej za pomocą
          identyfikatora, który możemy wygenerować za pomocą `make_ref/0`.
    - Zadanie - zaimplementuj proces bakterii, który żyje i odbiera
      odpowiedniewiadomości oraz wysyła określoną wiadomość, jeśli osiągnie
      pewien poziom życia. Szczegóły są opisane w treści zadania.

3. Wnętrze procesu i sygnały z zewnątrz (PROCESS DICTIONARY, EXIT SIGNALS, TRAPPING EXITS).
4. Zarządzanie procesami (NAMED PROCESSES, MONITORS, LINKS).
5. Zadania (TASKS).
6. Agenci (AGENTS).
