class Trade::Admin::PromoteChargesController < Trade::Admin::BaseController
  before_action :set_promote
  before_action :set_charge, only: [:edit, :update, :destroy]

  def index
    @charges = @promote.charges.default_where(type: params[:type], 'min-gte': params[:min], 'max-lte': params[:max])
    @charges = @charges.order(min: :asc).page(params[:page]).per(20)
  end

  def new
    @charge = @promote.charges.new
  end

  def create
    @charge = @promote.charges.new(charge_params)
    respond_to do |format|
      if @charge.save
        format.html { redirect_to admin_promote_charges_url(@promote) }
        format.js { redirect_to admin_promote_charges_url }
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
        format.html { redirect_to admin_promote_charges_url(@promote) }
        format.js { redirect_to admin_promote_charges_url(@promote) }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    if @charge.destroy
      redirect_to admin_promote_charges_url(@promote)
    end
  end

  private
  def charge_params
    attrs = [:min, :max, :parameter, :type] + @promote.extra
    params.fetch(:charge, {}).permit(attrs)
  end

  def set_promote
    @promote = Promote.find params[:promote_id]
  end

  def set_charge
    @charge = PromoteCharge.find params[:id]
  end

end
