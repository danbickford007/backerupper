class BackupsController < ApplicationController
  before_action :set_backup, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => [:create]
  protect_from_forgery :except => [:create]

  def index
    @backups = Backup.all
  end

  def show
  end

  def new
    @backup = Backup.new
  end

  def edit
  end

  def create
    p "!!!!!!!!!!!!!"
    p params[:file].original_filename.inspect
    @backup = Backup.new(:name => params[:file].original_filename)
    File.open("lib/uploads/#{params[:file].original_filename}", "wb") {|f| f.write(params[:file].tempfile.read) }
    respond_to do |format|
      if @backup.save
        format.html { redirect_to @backup, notice: 'Backup was successfully created.' }
        format.json { render action: 'show', status: :created, location: @backup }
        format.xml
      else
        format.html { render action: 'new' }
        format.json { render json: @backup.errors, status: :unprocessable_entity }
        format.xml
      end
    end
  end

  def update
    respond_to do |format|
      if @backup.update(backup_params)
        format.html { redirect_to @backup, notice: 'Backup was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @backup.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @backup.destroy
    respond_to do |format|
      format.html { redirect_to backups_url }
      format.json { head :no_content }
    end
  end

  private
    def set_backup
      @backup = Backup.find(params[:id])
    end

    def backup_params
      params.require(:backup).permit(:name, :description, :user_id)
    end
end
