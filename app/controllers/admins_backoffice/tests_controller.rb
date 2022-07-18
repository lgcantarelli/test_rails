class AdminsBackoffice::TestsController < AdminsBackofficeController
  before_action :set_test,      only: [:edit, :update, :destroy]
  before_action :params_test,   only: [:update]
  before_action :get_subjects,  only: [:new, :edit]
  before_action :get_questions, only: [:new, :edit]
  
  def index
    @tests = Test.all.includes(:subject).includes(:questions)
  end

  def edit
    questions_ids = @test.question_ids
    @questions = Question.find(questions_ids)
  end

  def new
    @test = Test.new
  end

  def update
    if params[:test]    
      if @test.update(params_test)
        redirect_to edit_admins_backoffice_test_path(@test), notice: "Prova atualizada com sucesso!"
      else
        render :edit
      end
    else
      redirect_to edit_admins_backoffice_test_path(@test), notice: "Prova não pode ficar sem questões!"
    end
  end

  def create
    @test = Test.new(params_test)

    if @test.save
      redirect_to edit_admins_backoffice_test_path(@test), notice: "Prova criada com sucesso! Selecione as questões"
    else
      render :edit
    end
  end


  def destroy
    @test.questions.clear
    if @test.destroy
      redirect_to admins_backoffice_tests_path, notice: "Avaliação excluido com sucesso"
    else
      render :index
    end
  end

  private
  
    def set_test
      @test = Test.find(params[:id])
    end

    def params_test
      if params[:test]
        params.require(:test).permit(:name, :subject_id, question_ids: [])
      else
        params.permit(:id)
      end
    end

    def get_subjects
      @subjects = Subject.all
    end

    def get_questions
      @questions = Question.all
    end

end

