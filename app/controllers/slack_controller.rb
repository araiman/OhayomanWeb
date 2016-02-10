class SlackController < ApplicationController
  def post_status
    # TODO status_codeを取り出してくる処理の実装

    if status_code == 10
      post_status_message '起動しました'
    elsif status_code == 11
      post_status_message '停止しました'
    elsif status_code == 20
      post_status_message '正常に動いています'
    elsif status_code == 30
      post_status_message 'インターネットに繋がっていない可能性があります'
    end
  end

  private

  def post_status_message message
    Slack.chat_postMessage text: "[status] #{message}", username: 'おはようマン', channel: '#ohayoman'
  end
end
