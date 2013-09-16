module ListHelper
  def test_statistic(date, folder)
    doc = Nokogiri::HTML(open("#{Rails.root}/public/tests/#{folder}/#{date}"))
    length1 = doc.xpath('//script[@type="text/javascript"]').length
    if length1 == 0
      labels = "Empty. "
    else
      begin
      labels = doc.xpath('//script[@type="text/javascript"]')[length1 -1].content[/(\d*) scenario(.*)</][0..-2]
      rescue
        labels = "Not completed"
        end
    end
    begin
      doc.xpath('//script[@type="text/javascript"]')[length1 -1].content[/Finished\sin/]
    rescue
      finish_status = 'Not completed'
    end
    {labels: labels, finish_status: finish_status}
  end


end
