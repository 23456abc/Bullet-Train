class Account::Projects::TagsController < Account::ApplicationController
  account_load_and_authorize_resource :tag, through: :team, through_association: :projects_tags

  # GET /account/teams/:team_id/projects/tags
  # GET /account/teams/:team_id/projects/tags.json
  def index
    delegate_json_to_api
  end

  # GET /account/projects/tags/:id
  # GET /account/projects/tags/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/projects/tags/new
  def new
  end

  # GET /account/projects/tags/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/projects/tags
  # POST /account/teams/:team_id/projects/tags.json
  def create
    respond_to do |format|
      if @tag.save
        format.html { redirect_to [:account, @tag], notice: I18n.t("projects/tags.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @tag] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/projects/tags/:id
  # PATCH/PUT /account/projects/tags/:id.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to [:account, @tag], notice: I18n.t("projects/tags.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @tag] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/projects/tags/:id
  # DELETE /account/projects/tags/:id.json
  def destroy
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :projects_tags], notice: I18n.t("projects/tags.notifications.destroyed") }
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
