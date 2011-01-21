require 'fox16'
require 'matrix'
require 'mathn'
require 'pp'
include Fox

class Hopfield < FXMainWindow
  attr_reader :wyjsciowy_wzorzec
  
  def initialize(app, liczba_neuronow)
    super(app, "Sieć Hopfielda - implementacja w Ruby'm", :width => 620, :height => 700)
    layout = FXPacker.new(self, 2, :opts => LAYOUT_FILL, :padding => 10)
    #tablice dla wzorca pierwszego oraz dla wzorca drugiego
    @tablica_1 = FXTable.new(layout, :width => 80, :height => 250, :opts => LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
    @tablica_1.visibleRows = 7
    @tablica_1.visibleColumns = 5
    #wypełnienie nagłówków tablicy kolumn oraz wierszy
    @tablica_1.setTableSize(7, 5)

    (0..4).each do |column|
      @tablica_1.setColumnText(column, "#{column+1}")
    end

    (0..6).each do |row|
      @tablica_1.setRowText(row, "#{row+1}")
    end


    #wypełnienie tablicy bitami litery A
    @tablica_1.setItemText(0,0,"+1")
    @tablica_1.setItemText(0,1,"+1")
    @tablica_1.setItemText(0,2,"+1")
    @tablica_1.setItemText(0,3,"+1")
    @tablica_1.setItemText(0,4,"+1")
    @tablica_1.setItemText(1,0,"+1")
    @tablica_1.setItemText(1,1,"-1")
    @tablica_1.setItemText(1,2,"-1")
    @tablica_1.setItemText(1,3,"-1")
    @tablica_1.setItemText(1,4,"+1")
    @tablica_1.setItemText(2,0,"+1")
    @tablica_1.setItemText(2,1,"-1")
    @tablica_1.setItemText(2,2,"-1")
    @tablica_1.setItemText(2,3,"-1")
    @tablica_1.setItemText(2,4,"+1")
    @tablica_1.setItemText(3,0,"+1")
    @tablica_1.setItemText(3,1,"+1")
    @tablica_1.setItemText(3,2,"+1")
    @tablica_1.setItemText(3,3,"+1")
    @tablica_1.setItemText(3,4,"+1")
    @tablica_1.setItemText(4,0,"+1")
    @tablica_1.setItemText(4,1,"-1")
    @tablica_1.setItemText(4,2,"-1")
    @tablica_1.setItemText(4,3,"-1")
    @tablica_1.setItemText(4,4,"+1")
    @tablica_1.setItemText(5,0,"+1")
    @tablica_1.setItemText(5,1,"-1")
    @tablica_1.setItemText(5,2,"-1")
    @tablica_1.setItemText(5,3,"-1")
    @tablica_1.setItemText(5,4,"+1")
    @tablica_1.setItemText(6,0,"+1")
    @tablica_1.setItemText(6,1,"-1")
    @tablica_1.setItemText(6,2,"-1")
    @tablica_1.setItemText(6,3,"-1")
    @tablica_1.setItemText(6,4,"+1")
    
    #tablice dla wzorca pierwszego oraz dla wzorca drugiego
    @tablica_2 = FXTable.new(layout, :width => 80, :height => 250, :opts => JUSTIFY_LEFT|FRAME_LINE)
    @tablica_2.visibleRows = 7
    @tablica_2.visibleColumns = 5
    #wypełnienie nagłówków tablicy kolumn oraz wierszy
    @tablica_2.setTableSize(7, 5)

    (0..4).each do |column|
      @tablica_2.setColumnText(column, "#{column+1}")
    end
    (0..6).each do |row|
      @tablica_2.setRowText(row, "#{row+1}")
    end
    
    #wypełnienie tablicy 2 bitami litery C
    @tablica_2.setItemText(0,0,"+1")
    @tablica_2.setItemText(0,1,"+1")
    @tablica_2.setItemText(0,2,"+1")
    @tablica_2.setItemText(0,3,"+1")
    @tablica_2.setItemText(0,4,"+1")
    @tablica_2.setItemText(1,0,"+1")
    @tablica_2.setItemText(1,1,"-1")
    @tablica_2.setItemText(1,2,"-1")
    @tablica_2.setItemText(1,3,"-1")
    @tablica_2.setItemText(1,4,"-1")
    @tablica_2.setItemText(2,0,"+1")
    @tablica_2.setItemText(2,1,"-1")
    @tablica_2.setItemText(2,2,"-1")
    @tablica_2.setItemText(2,3,"-1")
    @tablica_2.setItemText(2,4,"-1")
    @tablica_2.setItemText(3,0,"+1")
    @tablica_2.setItemText(3,1,"-1")
    @tablica_2.setItemText(3,2,"-1")
    @tablica_2.setItemText(3,3,"-1")
    @tablica_2.setItemText(3,4,"-1")
    @tablica_2.setItemText(4,0,"+1")
    @tablica_2.setItemText(4,1,"-1")
    @tablica_2.setItemText(4,2,"-1")
    @tablica_2.setItemText(4,3,"-1")
    @tablica_2.setItemText(4,4,"-1")
    @tablica_2.setItemText(5,0,"+1")
    @tablica_2.setItemText(5,1,"-1")
    @tablica_2.setItemText(5,2,"-1")
    @tablica_2.setItemText(5,3,"-1")
    @tablica_2.setItemText(5,4,"-1")
    @tablica_2.setItemText(6,0,"+1")
    @tablica_2.setItemText(6,1,"+1")
    @tablica_2.setItemText(6,2,"+1")
    @tablica_2.setItemText(6,3,"+1")
    @tablica_2.setItemText(6,4,"+1")

    przycisk_nauki = FXButton.new(layout, "Nauka", :opts => FRAME_LINE)
    przycisk_nauki.connect(SEL_COMMAND) do
      @liczba_neuronow = liczba_neuronow
      #tworzy pustą macierz wag
      @macierz_wag = Matrix[ *[].fill([].fill(0, 0, @liczba_neuronow), 0, @liczba_neuronow) ]
      #zamiana elementów tablic na elementy wzorcow
      wzorzec_1 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      k = 0
      for i_2 in (0..6) do
        for j in (0..4) do
          wzorzec_1[k] = Integer(@tablica_1.getItemText(i_2,j))
          k = k + 1
        end
      end
      
      wzorzec_2 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      l = 0
      for i_3 in (0..6) do
        for j in (0..4) do
          wzorzec_2[l] = Integer(@tablica_2.getItemText(i_3,j))
          l = l + 1
        end
      end

      [wzorzec_1, wzorzec_2].each do |wzorzec|
        nauka(wzorzec)
      end
      pp @macierz_wag

  end

    #tablica wyniku działania oraz tablica macierzy wzorca do sprawdzenia
    @tablica_4 = FXTable.new(layout, :width => 350, :height => 250, :opts => JUSTIFY_LEFT|FRAME_LINE)
    @tablica_4.visibleRows = 7
    @tablica_4.visibleColumns = 5
    @tablica_4.setTableSize(7, 5)

    (0..4).each do |column|
        @tablica_4.setColumnText(column, "#{column+1}")
    end
    (0..6).each do |row|
        @tablica_4.setRowText(row, "#{row+1}")
    end

    #wypełnienie tablicy 4 wartościami binarnymi
      (0..6).each do |i_5|
      (0..4).each do |j|
        @tablica_4.setItemText(i_5,j,"-1")
      end
    end

    przycisk_sprawdzenia = FXButton.new(layout, "Sprawdź wzorzec", :opts => FRAME_LINE)
    przycisk_sprawdzenia.connect(SEL_COMMAND) do
      wzorzec_do_odtworzenia = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      m = 0
      for i_6 in (0..6) do
        for j in (0..4) do
          wzorzec_do_odtworzenia[m] = Integer(@tablica_4.getItemText(i_6,j))
          m = m + 1
        end
      end
      odtwarzanie wzorzec_do_odtworzenia, (0..34).to_a {rand}
    end

  end
  
  def nauka(wzorzec)
      delta_w = Matrix[wzorzec].t * Matrix[wzorzec]
      @macierz_wag += delta_w - Matrix.I(@liczba_neuronow)
  end

  def odtwarzanie(wejsciowy_wzorzec, sekwencja_iteracji)
    stare_wejscie = [].fill(rand, 0, @liczba_neuronow)
    nowe_wejscie = wejsciowy_wzorzec
        while true
            sekwencja_iteracji.each do |iter|
                net = wejsciowy_wzorzec[iter] + Vector[*wejsciowy_wzorzec].inner_product(@macierz_wag.column(iter))
                nowe_wejscie[iter] = funkcja_dyskretyzacji(net, nowe_wejscie[iter])
            end
            if stare_wejscie == nowe_wejscie
                @wynikowy_wzorzec = nowe_wejscie
                n = 0 
                (0..6).each do |i|
                  (0..4).each do |j|
                    @tablica_4.setItemText(i,j,"#{@wynikowy_wzorzec[n]}")
                    n = n + 1
                  end
                end
                break
            else
                stare_wejscie = nowe_wejscie
            end
        end
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end
   private
    def funkcja_dyskretyzacji(x, net)
        if x > 0
            +1
        elsif x == 0
            net
        else
            -1
        end
    end
end
if __FILE__ == $0
app = FXApp.new
Hopfield.new(app, 35)
app.create
app.run
end
