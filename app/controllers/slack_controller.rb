class SlackController < ApplicationController
  def post_status
    status_code = params[:status_code].to_i

    if status_code == 10
      post_status_message '起動しました'
      $is_app_active = true
      $has_status_posted = false
      Thread.new do
        check_app_active
      end
    elsif status_code == 11
      post_status_message '停止しました'
      $is_app_active = false
    elsif status_code == 20
      post_status_message '正常に動いています'
      $has_status_posted = true
    end
    head :ok
  end

  private

  def post_status_message message
    Slack.chat_postMessage text: "[status] #{message}", username: 'おはようマン', channel: '#status_log'
  end

  def check_app_active
    loop do
      # 3分毎におはようマンからステータスが送られてくるので、判定の間隔に少し余裕を持たせる
      $is_app_active? (sleep 190) : break
      if $has_status_posted
        $has_status_posted = false
      else
        post_status_message 'インターネットに繋がっていない可能性があります'
        break
      end
    end
  end
end
