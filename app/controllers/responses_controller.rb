#
# ResponsesController
#
class ResponsesController < ApplicationController
  def index
    @presentation = Presentation.find(params[:presentation_id])
    @responses = Response.all
    # Save response data for integer responses
    @data = {}
    @presentation.surveys.each do |survey|
      survey.questions.each do |question|
        puts "QUESTION: #{question.id}"
        if question.response_type == 'number'
          question_data = { '1': 0, '2': 0, '3': 0, '4': 0, '5': 0 }
          @responses.where(question_id: question.id).each do |response|
            puts "RESPONSE: #{response.value}"
            res_value = response.value.to_sym
            question_data[res_value] += 1
          end
          # binding.pry
          @data[question.id] = question_data
        end
        puts "#{@data}"
      end
    end
    @maximum = @data.length
  end
  #
  # New route
  #
  def new
    @presentation = Presentation.find(params[:presentation_id])
    @surveys = @presentation.position_surveys
    @feedback = { errors: [] }
  end

  #
  # Create route
  #
  def create
    @feedback = { responses: params[:question], errors: [] }
    @feedback[:responses].each do |question_id, answer|
      response = Response.new(question_id: question_id, user_id: current_user.id, value: answer)
      unless response.save
        @feedback[:errors] << { question_id: question_id, error_obj: response.errors }
      end
    end

    if !@feedback[:errors].empty?
      @presentation = Presentation.find(params[:presentation_id])
      @surveys = @presentation.position_surveys
      render :new
    else
      flash[:success] = success_message(Response.new, :save)
      redirect_to presentations_path
    end
  end

  #
  # Show route
  #
  def show
  end

# private
#   def average_score
#     # binding.pry
#     @feedback[:responses].values.each do |response|
#       if response.to_i.is_a?(Integer)
#         p "#{response.value} NUMBER++++++++++++++++++++++++++++"
#       else
#         p "NOT A NUMBER NOT A NUMBERNOT A NUMBERNOT A NUMBERNOT A NUMBERNOT A NUMBERNOT A NUMBERNOT A NUMBERNOT A NUMBERNOT A NUMBERNOT A NUMBER"
#       end
#     end
#   end
end

# array = []
# @feedback[:responses].values.map do |response|
#      array.push(response.to_i)
# end
# array.reduce(:+)/array.length
# h.merge(h) { |k, v| Integer(v) rescue v }
