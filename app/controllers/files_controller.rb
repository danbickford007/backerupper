class FilesController < ApplicationController
  require_relative '../../lib/extractor'
  include Extractor

  def index
    @files = open_tar
  end

  def new
    @content = read_file params[:file]
  end
end
