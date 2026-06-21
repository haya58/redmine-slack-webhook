class SlackWebhookSettingsController < ApplicationController
  before_action :find_project
  before_action :authorize

  def show
    @setting = SlackWebhookSetting.find_or_initialize_by(project_id: @project.id)
  end

  def update
    @setting = SlackWebhookSetting.find_or_initialize_by(project_id: @project.id)
    @setting.assign_attributes(setting_params)

    if @setting.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to project_slack_webhook_settings_path(@project)
    else
      render :show
    end
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def setting_params
    params.require(:slack_webhook_setting).permit(:webhook_url, :enabled)
  end
end
