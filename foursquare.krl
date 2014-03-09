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
  
  rule process_fs_checkin is active {
    select when foursquare checkin
    pre {
      venue = event:attr("venue");
      city = event:attr("city");
      shout = event:attr("shout");
      createdAt = event:attr("createdAt");
    }
    fired {
      set ent:venue venue;
      set ent:city city;
      set ent:shout shout;
      set ent:createdAt createdAt;
    }
  }
  
  rule display_checkin is active {
    select when web cloudAppSelected
    pre {
      venue = ent:venue;
      city = ent:city;
      shout = ent:shout;
      createdAt = ent:createdAt;
      my_html = <<
        <h5>Venue: #{ent:venue}</h5>
        <h5>City: #{ent:city}</h5>
        <h5>Shout: #{ent:shout}</h5>
        <h5>CreatedAt: #{ent:createdAt}</h5>
      >>;
    }
    if (ent:venue || ent:city || ent:shout || ent:createdAt) then {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("CS462 Lab 5: Foursquare Checkins", {}, "<h5>#{venue} #{city} #{shout} #{createdAt}</h5>");
    }
  }
}
