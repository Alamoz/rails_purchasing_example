class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]

  # GET /sales
  # GET /sales.json
  def index
    @sales = Sale.all
  end

  # GET /sales/1
  # GET /sales/1.json
  def show
    @purchases = Purchase.where(sale_id: @sale.id)
    @running_total = 0
  end

  # GET /sales/new
  def new
    @sale = Sale.new
    @sale.purchases.build
    @products = Product.all
  end

  # GET /sales/1/edit
  def edit
    @products = Product.all
  end

  # POST /sales
  # POST /sales.json
  def create
    @sale = Sale.new(sale_params)

    respond_to do |format|
      if @sale.save && calculate_taxes(@sale)
        format.html { redirect_to @sale, notice: 'Sale was successfully created.' }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales/1
  # PATCH/PUT /sales/1.json
  def update
    #params[:sale][:existing_purchase_attributes] ||= {}
    respond_to do |format|
      if @sale.update(sale_params) && calculate_taxes(@sale)
        format.html { redirect_to @sale, notice: 'Sale was successfully updated.' }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { render :edit }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1
  # DELETE /sales/1.json
  def destroy
    @sale.destroy
    respond_to do |format|
      format.html { redirect_to sales_url, notice: 'Sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_params
      #params.require(:sale).permit(:tax_exempt_amount, :taxable_amount, :import_duty_amount, :taxable_total, :import_duty_total, :grand_total)
      params.require(:sale).permit(:tax_exempt_amount, :taxable_amount, :import_duty_amount, :taxable_total, :import_duty_total, :grand_total, purchases_attributes: [:id, :product_id, :quantity, :_destroy])
    end


    def round_to(value, round_to)
      modulo = value.modulo(1).round(3)
      increments = ((modulo / round_to).round(1)).ceil
      cents = increments * 5
      dollars = value - (value.modulo(1))
      if cents == 100
        dollars += 1
        cents = 0
      end
      logger.info "#{value} modulo is #{modulo}, increments = #{increments}, dollars = #{dollars} cents = #{cents}"
      logger.info "#{cents}/100 = #{(cents.to_f/100).to_f}"
      new_value = (dollars + (cents.to_f/100)).to_f
      return new_value
    end


    def calculate_taxes(sale)
      Sale.transaction do
        sale.tax_exempt_amount = 0
        sale.taxable_amount = 0
        sale.import_duty_amount = 0
        sale.taxable_total = 0
        sale.import_duty_total =0
        sale.grand_total = 0
        purchases = Purchase.where(sale_id: sale.id)
        logger.info "#{purchases.size} purchases in this sale."
        purchases.each do |purchase|
            product = Product.where(id: purchase.product_id).first
            logger.info "Product = #{product.item} #{purchase.quantity} @ #{product.price}"

            purchase.sub_total = 0
            purchase.total = 0
            purchase.tax_total = 0
            purchase.import_duty_total = 0

            purchase.sub_total = product.price * purchase.quantity
            if product.tax_exempt == false
              # Round sales tax up to nearest 0.05...
              sales_tax = round_to((purchase.sub_total * $tax_rate), 0.05)
              logger.info "sales_tax = #{sales_tax}"
              purchase.tax_total = sales_tax
            end
            purchase.import_duty_total = (purchase.sub_total * $import_duty) if product.import_duty == true
            purchase.total += purchase.sub_total
            purchase.total += purchase.tax_total if product.tax_exempt == false
            purchase.total += purchase.import_duty_total if product.import_duty == true
            purchase.save!

            sale.tax_exempt_amount += purchase.sub_total if product.tax_exempt == true
            sale.taxable_amount += purchase.sub_total if product.tax_exempt == false
            sale.taxable_total += purchase.tax_total if product.tax_exempt == false
            sale.import_duty_amount += purchase.sub_total if product.import_duty == true
            sale.import_duty_total += purchase.import_duty_total if product.import_duty == true
            sale.grand_total += (purchase.sub_total + purchase.tax_total + purchase.import_duty_total)
            sale.save!
        end  # purchases.each do |purchase|
      end  # Sale.transaction
      return true
    end
end
