class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: %i[ show edit update destroy ]
  before_action :set_ransack

 
  def index
    @expenses =  @q.result(distinct: true).page(params[:page]).per(6)
  end

  def category
    puts "------#{params[:category]}"
   
    @expenses = @q.result.where(category_id: params[:category]).page(params[:page]).per(6)
    
     respond_to do |format|
      format.html { render :index }
      format.html   { render partial: 'expenses' }
     end
    
  end

  
  def show
  end

  
  def new
    @expense = Expense.new
  end

  
  def edit
  end

  
  def create
    @expense = current_user.expenses.build(expense_params)
    if @expense.save
      redirect_to @expense, notice: 'Expense was successfully created.'
    else
      render :new
    end
  end

  
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to expense_url(@expense), notice: "Expense was successfully updated." }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

 
  def destroy
    @expense.destroy!

    respond_to do |format|
      format.html { redirect_to expenses_url, notice: "Expense was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_ransack
     
      @q =  current_user.expenses.ransack(params[:q])

    end  

    def set_expense
      
      @expense = Expense.find(params[:id])
      
    end

    
   def expense_params
      params.require(:expense).permit(:title, :amount, :description, :date, :category_id, :receipt)
   end

end
