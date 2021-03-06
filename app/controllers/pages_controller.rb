class PagesController < ApplicationController

  def index
    if params[:theDate]
      @folder = params[:theDate]
    else
      @folder = "#{Time.now.year}-#{Time.now.month}-#{Time.now.day}"
    end
    respond_to do |format|
     format.html
     format.js
    end
  end


  def update_manual
    #system("cp #{Autotest::CONFIG.auto_test}/*.erb #{Rails.root}/#{Autotest::CONFIG.test_folder}")
    render partial: 'manual_tests'
  end

  def delete_manual
    File.delete("#{Rails.root}/public/tests/#{params[:filename]}")
    render partial: 'manual_tests'
  end

  def run_test
    host = params[:environment][:test][:env]
    test = params[:environment][:test][:test]
    report = "#{host}_#{test}_report.erb"

    path_to_auto_test = "%s/%s" % [File.expand_path(Autotest::CONFIG.auto_test), report]
    File.delete(path_to_auto_test) if FileTest.exists?(path_to_auto_test)

    path_to_test = "%s/%s/%s" % [Rails.root, Autotest::CONFIG.test_folder, report]
    File.delete(path_to_test) if FileTest.exists?(path_to_test)
    File.new(path_to_test, 'a')

    if Environment.all.map(&:name).include? host
      system("rake auto_test:separate_test P=#{test} HOST=#{host} &")
    end

    redirect_to log_path(test_host: host, test: test)
  end

  def test_log
    host = params[:test_host]
    test = params[:test]
    report = "#{host}_#{test}_report.erb"

    path_to_auto_test = "%s/%s" % [File.expand_path(Autotest::CONFIG.auto_test), report]
    path_to_test = "%s/%s/%s" % [Rails.root, Autotest::CONFIG.test_folder, report]
    FileUtils.cp path_to_auto_test, path_to_test if FileTest.exists?(path_to_auto_test)

    response.headers['refresh'] = '10'
    render text: File.read(path_to_test), layout: false
  end

  def update_code
    tag = params[:test][:tag]
    system("cd #{Autotest::CONFIG.auto_test} && hg up #{tag} > #{Rails.root}/public/update_code.log")

    render "#{Rails.root}/public/update_code.log"
  end

  def update_test
    system('rake update:tests &')
    redirect_to root_path
  end

  def update_tag
    system('rake update:tags &')
    redirect_to root_path
  end

  def stop_test
    system('killall -9 cucumber')
    system('killall -9 firefox')

    redirect_to root_path
  end

  def not_found
    render file: "#{Rails.root}/public/404.html", status: 404, layout: false
  end

end
