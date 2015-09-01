require "spec_helper"

describe 'Dirparse' do

  FILES = %w(
             U6342_Account_20150112.txt
             U79014_Position_20150113.txt
             U6342_Position_20150112.txt
             U79014_Security_20150112.txt
             U6342_Activity_20150112.txt
             U6342_Account_20150113.txt
             U79014_Account_20150113.txt
             U6342_Security_20150113.txt
             U6342_Activity_20150113.txt
             U79014_Account_20150112.txt
             U79014_Position_20150112.txt
             U6342_Position_20150113.txt
             U6342_Security_20150112.txt
             U79014_Activity_20150112.txt
             U79014_Security_20150113.txt
            )
  FILES_BAD = %w(
                  somefile.txt
                  temp-file.txt
                  tU6342_Security_30150112.txt
                  tmp_U6342_Activity_30150112.txt
                  U6342_Account_30150119.tmp
                  U6342_Position_temp_30150113.txt
                  U6342_Security30150113.txt
                  U79014_Position_30150113.
                  U79014_Security_30150113.dat
                  U79014_Activity_30150113
                )
  RESULT =
"U79014
  2015-01-12
    account
    activity
    position
    security
  2015-01-13
    account
    position
    security
U6342
  2015-01-12
    account
    activity
    position
    security
  2015-01-13
    account
    activity
    position
    security"

  context 'in current dir' do

    before :each do
      FILES.each { |name| File.new(name, "w") }
    end

    after :each do
     FILES.each { |name| File.delete name }
    end

    it 'valid' do
      list = Dirparse.new.to_s
      expect(list).to eq RESULT
    end

    it 'valid with bad files' do
      FILES_BAD.each { |name| File.new(name, "w") }
      list = Dirparse.new.to_s
      expect(list).to eq RESULT
      FILES_BAD.each { |name| File.delete name }
    end

  end

  context 'in temp dir' do

    before :each do
      @curdir = Dir.getwd
    end

    after :each do
      Dir.chdir @curdir
    end

    it "valid" do
      Dir.mktmpdir do |dir|
        Dir.chdir dir
        FILES.each { |name| File.new(name, "w") }
        list = Dirparse.new(dir).to_s
        expect(list).to eq RESULT
      end
    end

    it "valid with bad files" do
      Dir.mktmpdir do |dir|
        Dir.chdir dir
        (FILES + FILES_BAD).each { |name| File.new(name, "w") }
        list = Dirparse.new(dir).to_s
        expect(list).to eq RESULT
      end
    end

  end

  it "show nothing when folder not exist" do
    list = Dirparse.new("tempNOfolder").to_s
    expect(list).to eq ""
  end

  it "show nothing when files not exist" do
    list = Dirparse.new.to_s
    expect(list).to eq ""
  end

end