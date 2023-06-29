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

  def link_to_add_fields(name, fo, association)
    # build a new task object
    # it has every attribute as nil, including the id:nil
    new_object = fo.object.send(association).klass.new
    # this object_id is different from task id
    # but is the id of the object itself which holds the info about the said task
    id = new_object.object_id

    fields = fo.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + '_fields', f: builder)
    end
    link_to(name, '#', class: 'btn btn-secondary', id: 'add-task-fields', data: { id: id, fields: fields })
  end
end
