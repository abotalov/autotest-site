module PagesHelper
  def manual_tests_sorted
    tests = Dir.new("#{Rails.root}/public/tests")
    h = {}
    tests.select{|i| i.match /erb$/}.each do |file|
      h[(File.ctime("#{Rails.root}/public/tests/#{file}")+(60*60*3)).to_s.scan(/^.+\s.+\s/)[0]] = file
    end
    Hash[h.sort].to_a.reverse
  end
end
