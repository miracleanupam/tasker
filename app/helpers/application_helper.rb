module ApplicationHelper
  def get_task_status_class(status)
    case status
    when "to_do"
      "badge bg-secondary"
    when "ongoing"
      "badge bg-info"
    when "completed"
      "badge bg-success"
    when "failed"
      "badge bg-warning"
    else
      "badge bg-danger"
    end
  end
end
