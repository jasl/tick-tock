module ApplicationHelper
  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def print_error_messages resource
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count)

    html = <<-HTML
    <div class="alert alert-error">
      <a class="close" data-dismiss="alert"><i class="icon-remove"></i></a>
      <strong>#{sentence}</strong>
      <ul>
        #{messages}
      </ul>
    </div>
    HTML

    html.html_safe
  end

  def notice_message
    flash_messages = []
    flash.each do |type, message|
      if message
        type = :success if type == :notice
        html = <<-HTML
        <div class=\"alert fade in alert-#{type}\">
          <a class="close" data-dismiss="alert"><i class="icon-remove"></i></a>
          #{message}
        </div>
        HTML
        flash_messages << html
      end
    end
    flash_messages.join("\n").html_safe
  end
end
