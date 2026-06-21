class SlackWebhookSettingsController < ApplicationController
  before_action :find_project
  before_action :authorize

  def update
    @setting = SlackWebhookSetting.find_or_initialize_by(project_id: @project.id)
    @setting.assign_attributes(setting_params)

    if @setting.save
      flash[:notice] = l(:notice_successful_update)
    else
      flash[:error] = @setting.errors.full_messages.join(', ')
    end

    redirect_to settings_project_path(@project, tab: 'slack_webhook')
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def setting_params
    params.require(:slack_webhook_setting).permit(:webhook_url, :enabled)
  end
end
