class Trade::Admin::ProducesController < Trade::Admin::BaseController
  before_action :set_produce, only: [:show, :edit, :update, :destroy]

  def index
    @produces = Produce.all
  end

  def show
  end

  def new
    @produce = Produce.new
  end

  def edit
  end

  def create
    @produce = Produce.new(produce_params)

    respond_to do |format|
      if @produce.save
        format.html { redirect_to @produce }
        format.json { render :show, status: :created, location: @produce }
      else
        format.html { render :new }
        format.json { render json: @produce.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /produces/1
  # PATCH/PUT /produces/1.json
  def update
    respond_to do |format|
      if @produce.update(produce_params)
        format.html { redirect_to @produce }
        format.json { render :show, status: :ok, location: @produce }
      else
        format.html { render :edit }
        format.json { render json: @produce.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /produces/1
  # DELETE /produces/1.json
  def destroy
    @produce.destroy
    respond_to do |format|
      format.html { redirect_to produces_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_produce
      @produce = Produce.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def produce_params
      params[:produce]
    end
end
