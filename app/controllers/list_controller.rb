class ListController < ApplicationController
  layout false

  def index
  end

  def show
    report = params[:id] + '.erb'
    render "%s/%s/%s" % [Rails.root, Autotest::CONFIG.test_folder, report], layout: false
  end

  def nightly
    report = params[:id] + '.erb'
    render "%s/%s/%s/%s" % [Rails.root, Autotest::CONFIG.test_folder, params[:folder], report], layout: false
  end

end
