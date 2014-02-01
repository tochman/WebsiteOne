class SimonAsks::QuestionsController < SimonAsks::ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = SimonAsks::Question.all
  end

  def show
  end

  def new
    @question = SimonAsks::Question.new
  end

  def edit
  end

  def create
    @question = SimonAsks::Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: t('.created') }
        format.json { render action: 'show', status: :created, location: @question }
      end
    end
  end

  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: t('.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end

  private

  def set_question
    @question = SimonAsks::Question.find(params[:id])
  end

  def question_params
    params[:question]
  end
end
