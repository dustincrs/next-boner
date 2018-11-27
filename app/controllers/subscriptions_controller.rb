class SubscriptionsController < ApplicationController
    def index
        @subscriptions = Subscription.all
    end

    def show
    end

    def new
        @subscription = Subscription.new
    end

    def edit
    end

    def create
        @chatroom_user = @chatroom.chatroom_users.where(user_id: current_user.id)
        redirect_to @chatroom
        @subscription = Subscription.new(subscription_params)
    
        respond_to do |format|
          if @subscription.save
            format.html { redirect_to @subscription, notice: 'Subscription was successfully created.' }
            format.json { render :show, status: :created, location: @subscription }
          else
            format.html { render :new }
            format.json { render json: @subscription.errors, status: :unprocessable_entity }
          end
        end
    end

    def update
        respond_to do |format|
          if @subscription.update(subscription_params)
            format.html { redirect_to @subscription, notice: 'Subscription was successfully updated.' }
            format.json { render :show, status: :ok, location: @subscription }
          else
            format.html { render :edit }
            format.json { render json: @subscription.errors, status: :unprocessable_entity }
          end
        end
    end

    def destroy
        @subscription.destroy
        respond_to do |format|
          format.html { redirect_to subscriptions_url, notice: 'Subscription was successfully destroyed.' }
          format.json { head :no_content }
        end
    end


    private
    # Use callbacks to share common setup or constraints between actions.
    def set_chatroom
      @chatroom = Chatroom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subscription_params
      params.fetch(:subscription, {})
    end

end
