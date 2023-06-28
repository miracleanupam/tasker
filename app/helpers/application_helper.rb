module ApplicationHelper
  def get_task_status_class(status)
    case status
    when 'to_do'
      'badge bg-secondary'
    when 'ongoing'
      'badge bg-info'
    when 'completed'
      'badge bg-success'
    when 'failed'
      'badge bg-warning'
    else
      'badge bg-danger'
    end
  end

  def get_full_page_title(page_title = '')
    base_title = 'Tasker'
    return base_title if page_title.empty?

    "#{page_title} | #{base_title}"
  end
end
