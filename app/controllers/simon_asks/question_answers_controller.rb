class SimonAsks::QuestionAnswersController < SimonAsks::ApplicationController
  before_action :set_question_answer, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @question_answer = SimonAsks::QuestionAnswer.new
  end

  def edit    
  end

  def create
    @question_answer = SimonAsks::QuestionAnswer.new(question_answer_params) 

    respond_to do |format|
      if @question_answer.save
        format.html { redirect_to @question_answer, notice: t('was.created') }
        format.json { render action: 'show', status: :created, location: @question_answer }
      else
        format.html { render action: 'new' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @question_answer.update(question_answer_params)
        format.html { redirect_to @question_answer, notice: t('was.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @question_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @question_answer.destroy
    respond_to do |format|
      format.html { redirect_to question_answer_url }
      format.json { head :no_content }
    end
  end

  private

  def set_question_answer
    @question_answer = SimonAsks::QuestionAnswer.find(params[:id])
  end

  def question_answer_params
    params[:question_answer]
  end
end
