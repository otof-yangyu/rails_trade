class Trade::Admin::ServeChargesController < Trade::Admin::BaseController
  before_action :set_serve
  before_action :set_charge, only: [:edit, :update, :destroy]

  def index
    q_params = {}
    q_params.merge! params.permit(@serve.extra)
    q_params.merge! 'min-lte': params[:value], 'max-gte': params[:value]
    
    @charges = @serve.charges.default_where(q_params).order(min: :asc).page(params[:page]).per(params[:per])
  end

  def new
    @charge = @serve.charges.build
  end

  def create
    @charge = @serve.charges.build(charge_params)

    respond_to do |format|
      if @charge.save
        format.html { redirect_to admin_serve_charges_url(@serve) }
        format.js { redirect_to admin_serve_charges_url }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def edit

  end

  def update
    respond_to do |format|
      if @charge.update(charge_params)
        format.html { redirect_to admin_serve_charges_url(@serve) }
        format.js { redirect_to admin_serve_charges_url(@serve) }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    if @charge.destroy
      redirect_to admin_serve_charges_url(@serve)
    end
  end

  private
  def charge_params
    attrs = [:min, :max, :parameter, :base_price, :type] + @serve.extra
    params.fetch(:charge, {}).permit(attrs)
  end

  def set_serve
    @serve = Serve.find params[:serve_id]
  end

  def set_charge
    @charge = ServeCharge.find params[:id]
  end

end
