class FilesController < ApplicationController
  before_filter :authenticate_user!
  require_relative '../../lib/extractor'
  protect_from_forgery :except => [:upload]
  include Extractor

  def index
    @files = open_tar(params[:name])
  end

  def new
    @content = read_file params[:file]
  end

  def upload
    render :nothing => true
  end

  def download
    send_file params[:file]    
  end
end
