class Account::FoldersController < Account::ApplicationController
  include SortableActions
  account_load_and_authorize_resource :folder, through: :office, through_association: :folders

  # GET /account/offices/:office_id/folders
  # GET /account/offices/:office_id/folders.json
  def index
    delegate_json_to_api
  end

  # GET /account/folders/:id
  # GET /account/folders/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/offices/:office_id/folders/new
  def new
  end

  # GET /account/folders/:id/edit
  def edit
  end

  # POST /account/offices/:office_id/folders
  # POST /account/offices/:office_id/folders.json
  def create
    respond_to do |format|
      if @folder.save
        format.html { redirect_to [:account, @folder], notice: I18n.t("folders.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @folder] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/folders/:id
  # PATCH/PUT /account/folders/:id.json
  def update
    respond_to do |format|
      if @folder.update(folder_params)
        format.html { redirect_to [:account, @folder], notice: I18n.t("folders.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @folder] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/folders/:id
  # DELETE /account/folders/:id.json
  def destroy
    @folder.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @office, :folders], notice: I18n.t("folders.notifications.destroyed") }
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
