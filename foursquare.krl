ruleset Foursquare {
  meta {
    name "Foursquare"
    description <<
      Interacts with foursquare.
    >>
    author "Mike Curtis"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }
  dispatch {
  }
  global {
  }
  
  rule test_hook is active {
    select when foursquare checkin
    pre {}
    {
      send_directive("text") with body = "my text response";
    }
  }
  
  rule display_checkin is active {
    select when web cloudAppSelected
    pre {
      my_html = <<
        <h5>Checkins go here</h5>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("CS462 Lab 5: Foursquare Checkins", {}, my_html);
    }
  }
}
