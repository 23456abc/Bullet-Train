class Account::SitesController < Account::ApplicationController

  # include BulletTrain::Sortable::Controller  
  
  include SortableActions
  account_load_and_authorize_resource :site, through: :team, through_association: :sites


  # def show
  #   @site = Site.find(params[:id])
  # end

  # def reorder
  #   site = Site.find(params[:id])
  #   params[:new_order].each_with_index do |page_id, index|
  #     site.pages.find(page_id).update(sort_order: index + 1)
  #   end

  #   head :ok
  # end

  # GET /account/teams/:team_id/sites
  # GET /account/teams/:team_id/sites.json
  def index
    # @sites = Site.all
    delegate_json_to_api
  end

  # GET /account/sites/:id
  # GET /account/sites/:id.json
  def show
    # @site = Site.find(params[:id])
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/sites/new
  def new
  end

  # GET /account/sites/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/sites
  # POST /account/teams/:team_id/sites.json
  def create
    respond_to do |format|
      if @site.save
        format.html { redirect_to [:account, @site], notice: I18n.t("sites.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @site] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/sites/:id
  # PATCH/PUT /account/sites/:id.json
  def update
    respond_to do |format|
      if @site.update(site_params)
        format.html { redirect_to [:account, @site], notice: I18n.t("sites.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @site] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/sites/:id
  # DELETE /account/sites/:id.json
  def destroy
    @site.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :sites], notice: I18n.t("sites.notifications.destroyed") }
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
