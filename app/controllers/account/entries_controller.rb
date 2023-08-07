class Account::EntriesController < Account::ApplicationController
  account_load_and_authorize_resource :entry, through: :team, through_association: :entries

  # GET /account/teams/:team_id/entries
  # GET /account/teams/:team_id/entries.json
  def index
    delegate_json_to_api
  end

  # GET /account/entries/:id
  # GET /account/entries/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/entries/new
  def new
    if @entry.entryable_type_valid?
      @entry.build_entryable
    elsif params[:commit]
      @entry.valid?
    end
  end

  # GET /account/entries/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/entries
  # POST /account/teams/:team_id/entries.json
  def create
    respond_to do |format|
      if @entry.save
        format.html { redirect_to [:account, @entry], notice: I18n.t("entries.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @entry] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/entries/:id
  # PATCH/PUT /account/entries/:id.json
  def update
    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to [:account, @entry], notice: I18n.t("entries.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @entry] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/entries/:id
  # DELETE /account/entries/:id.json
  def destroy
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :entries], notice: I18n.t("entries.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def permitted_arrays
    {
      entryable_attributes: [
        :id,

        # Message attributes:
        :subject,

        # Comment attributes:
        :content,
      ],
    }
  end

  def build_entryable(params = {})
    raise 'invalid entryable type' unless entryable_type_valid?
    self.entryable = entryable_type.constantize.new(params)
  end

  def entry_params
    params.require(:entry).permit(:entryable_type, entryable_attributes: [:id, :subject, :content])
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
    strong_params
  end
end
