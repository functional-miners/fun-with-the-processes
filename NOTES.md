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
2. Pierwszy proces.
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
          defp loop(N) when rem(N, 1000) === 0 do
            IO.puts("I'm still working!")
            loop(0)
          end
          defp loop(N), do: loop(N + 1)

          def spawn() do
            pid = spawn(fn -> loop(0) end)
            IO.puts("Process started with PID: #{pid}")
          end
        end
        ```

TODO: Mailbox, wysyłanie i odbieranie wiadomości.

TODO: Blokowanie się gdy nie ma wiadomości.

TODO: Na tą chwilę to jedyny sposób na wymianę danych i stanu pomiędzy procesami nam znany.

TODO: Immutability FTW! Esencja actor model - niezależne jednostki, wymieniające
wiadomości, nie współdzielące miedzy sobą stanu. Tzw. obiekt reprezentujący
obliczenia, niezależny byt w systemie.

TODO: Zadanie - zaimplementuj proces bakterii, który żyje i odbiera odpowiednie
wiadomości oraz wysyła określoną wiadomość, jeśli osiągnie pewien poziom życia.
