# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::EntriesController < Api::V1::ApplicationController
    account_load_and_authorize_resource :entry, through: :team, through_association: :entries

    # GET /api/v1/teams/:team_id/entries
    def index
    end

    # GET /api/v1/entries/:id
    def show
    end

    # POST /api/v1/teams/:team_id/entries
    def create
      if @entry.save
        render :show, status: :created, location: [:api, :v1, @entry]
      else
        render json: @entry.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/entries/:id
    def update
      if @entry.update(entry_params)
        render :show
      else
        render json: @entry.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/entries/:id
    def destroy
      @entry.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def entry_params
        strong_params = params.require(:entry).permit(
          *permitted_fields,
          :entryable_type,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::EntriesController
  end
end
