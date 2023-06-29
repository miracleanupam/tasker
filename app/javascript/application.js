// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import $ from "jquery";
import "jquery";
import "bootstrap";

$("#add-task-fields").click(function(e) {
    e.preventDefault();
    let time = Date.now()
    let regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
})
