class Account::BlocksController < Account::ApplicationController
  include SortableActions
  account_load_and_authorize_resource :block, through: :project, through_association: :blocks

  # GET /account/projects/:project_id/blocks
  # GET /account/projects/:project_id/blocks.json
  def index
    delegate_json_to_api
  end

  # GET /account/blocks/:id
  # GET /account/blocks/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/projects/:project_id/blocks/new
  def new
  end

  # GET /account/blocks/:id/edit
  def edit
  end

  # def reorder
  #   debugger
  #   # Assuming you have a 'position' column in your Block model
  #   block = Block.find(params_id)
  #   params[:block_ids].each_with_index do |params_id, index|
  #     block.update(sort_order: index + 1)
  #   end

  #   head :ok
  # end


  

  # POST /account/projects/:project_id/blocks
  # POST /account/projects/:project_id/blocks.json
  def create
    respond_to do |format|
      if @block.save
        format.html { redirect_to [:account, @block], notice: I18n.t("blocks.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @block] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/blocks/:id
  # PATCH/PUT /account/blocks/:id.json
  def update
    respond_to do |format|
      if @block.update(block_params)
        format.html { redirect_to [:account, @block], notice: I18n.t("blocks.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @block] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/blocks/:id
  # DELETE /account/blocks/:id.json
  def destroy
    @block.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @project, :blocks], notice: I18n.t("blocks.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
