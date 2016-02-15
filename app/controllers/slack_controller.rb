class SlackController < ApplicationController
  def post_status
    # TODO status_codeを取り出してくる処理の実装
    status_code = params[:status_code].to_i

    if status_code == 10
      post_status_message '起動しました'
      $has_satus_posted = false
      check_ohayoman_active.delay
    elsif status_code == 11
      post_status_message '停止しました'
    elsif status_code == 20
      post_status_message '正常に動いています'
      $has_satus_posted = true
    end

    head :ok
  end

  private

  def post_status_message message
    Slack.chat_postMessage text: "[status] #{message}", username: 'おはようマン', channel: '#ohayoman'
  end

  def check_ohayoman_active
    Log.v 'debug', 'check_ohayoman_active called'
    sleep 180
    if $has_satus_posted
      $has_satus_posted = false
      check_ohayoman_active
    else
      post_status_message 'インターネットに繋がっていない可能性があります'
    end
  end
end
