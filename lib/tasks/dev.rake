namespace :dev do
  DEFAULT_PASSWORD = 123456

  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
  if Rails.env.development?
    show_spinner("Apagando BD...") { %x(rails db:drop) }
    show_spinner("Criando BD...") { %x(rails db:create) }
    show_spinner("Migrando BD...") { %x(rails db:migrate) }
    show_spinner("Cadastrando o ADM padrão...") { %x(rails dev:add_default_admin) }
    show_spinner("Cadastrando ADMs extras...") { %x(rails dev:add_extras_admins) }
    show_spinner("Cadastrando o Usuário padrão...") { %x(rails dev:add_default_user) }
    show_spinner("Cadastrando assuntos padrões...") { %x(rails dev:add_subjects) }
    show_spinner("Cadastrando questões e respostas...") { %x(rails dev:add_answers_and_questions) }

    show_spinner("Cadastrando avaliações padrões...") { %x(rails dev:add_tests) }

  else
   puts "Você não está em ambiente de desenvolvimento!"
  end
end

desc "Adiciona o administrador padrão"
task add_default_admin: :environment do
  Admin.create!(
  email: 'admin@admin.com',
  password: DEFAULT_PASSWORD,
  password_confirmation: DEFAULT_PASSWORD
  )
end

desc "Adiciona administradores extras"
task add_extras_admins: :environment do
  10.times do |i|
    Admin.create!(
      email: Faker::Internet.email,
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end
end

desc "Adiciona o usuário padrão"
task add_default_user: :environment do
  User.create!(
    email: 'user@user.com',
    password: DEFAULT_PASSWORD,
    password_confirmation: DEFAULT_PASSWORD
  )
end

desc "Adiciona assuntos padrão"
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    File.open(file_path, 'r').each do |line|
     Subject.create!(description: line.strip)
  end
end

desc "Adiciona questões e respostas"
  task add_answers_and_questions: :environment do
   Subject.all.each do |subject|
    rand(5..10).times do |i|
      params = create_question_params(subject)
      answers_array = params[:question][:answers_attributes]

      add_answers(answers_array)
      elect_true_answer(answers_array)

      Question.create!(
        params[:question]
      )
    end
  end
end

desc "Reseta o contador dos assuntos"
  task reset_subject_counter: :environment do
    show_spinner("Resetando contador dos assuntos") do
      Subject.find_each do |subject|
        Subject.reset_counters(subject.id, :questions)
    end
  end
end

desc "Adiciona Avaliações Padrão"
  task add_tests: :environment do
  Test.create!([
    { 
      name: 'Teste 1',
      subject: Subject.all.sample,
      question_ids: [Question.first.id, Question.all[2].id, Question.all[3].id]
    }
  ])
end


private

  def create_answer_params(correct = false)
    { description: Faker::Lorem.sentence, correct: correct}
  end

  def create_question_params(subject = Subject.all.sample)
    { question: {
      description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
      subject: subject,
      weight: 1,
      answers_attributes: []
      }
    }
  end

  def add_answers(answers_array = [])
    rand(2..5).times do |j|
      answers_array.push(
        create_answer_params
      )
    end
  end

  def elect_true_answer(answers_array = [])
          
    selected_index = rand(answers_array.size)
    answers_array[selected_index] = create_answer_params(true)

  end

 def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end