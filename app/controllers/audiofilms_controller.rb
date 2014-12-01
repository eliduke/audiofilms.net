class AudiofilmsController < ApplicationController
  before_action :set_audiofilm, only: [:edit, :update, :destroy]
  before_action :findbyslug, only: [:show]
  http_basic_authenticate_with name: "#{ENV['USERNAME']}", password: "#{ENV['PASSWORD']}", except: [:home, :index, :recent, :show]

  def home
    @audiofilms = Audiofilm.all.order("created_at DESC").limit(12)
  end

  def index
    @title = "Master List"
    @audiofilms = Audiofilm.all.order(:slug)
  end

  def recent
    @title = "Recent Additions"
    @audiofilms = Audiofilm.all.order("created_at DESC").limit(15)
  end

  def show
    @title = @audiofilm.title
  end

  def admin
    @audiofilms = Audiofilm.all.order(:slug)
  end

  def new
    @audiofilm = Audiofilm.new
  end

  def edit
  end

  def create
    @audiofilm = Audiofilm.new(audiofilm_params)

    respond_to do |format|
      if @audiofilm.save
        format.html { redirect_to admin_path, notice: 'Audiofilm was successfully created.' }
        format.json { render :show, status: :created, location: @audiofilm }
      else
        format.html { render :new }
        format.json { render json: @audiofilm.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @audiofilm.update(audiofilm_params)
        format.html { redirect_to admin_path, notice: 'Audiofilm was successfully updated.' }
        format.json { render :show, status: :ok, location: @audiofilm }
      else
        format.html { render :edit }
        format.json { render json: @audiofilm.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @audiofilm.destroy
    respond_to do |format|
      format.html { redirect_to admin_path, notice: 'Audiofilm was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_audiofilm
      @audiofilm = Audiofilm.find(params[:id])
    end

    def findbyslug
      @audiofilm = Audiofilm.find_by_slug(params[:id])
    end

    def audiofilm_params
      params.require(:audiofilm).permit(:title, :description, :release, :slug)
    end
end
