//= require rails-ujs
//= require jquery
//= require materialize
//= require turbolinks
//= require_tree .

$(document).on('turbolinks:load', function() {
  $('.dropdown-trigger').dropdown();
});

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";

Rails.start();
Turbolinks.start();

