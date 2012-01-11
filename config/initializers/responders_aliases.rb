ActionController::Responder.class_eval do
  alias :to_iphone :to_html
end
